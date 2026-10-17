import struct

# Works only on the AMD Ryzen 9 7945HX

if __name__ == "__main__":
    with open("/sys/kernel/ryzen_smu_drv/pm_table", "rb") as pm:
        pm.seek(0x528)
        coreTempsBinary = pm.read(16 * 4)
        temps = struct.unpack("<16f", coreTempsBinary)
        avg = sum(temps) / 16
        hottest = max(temps)
        coldest = min(temps)
        for i, temp in enumerate(temps):
            print(f"Core #{i+1} temp: {round(temp, 1)}\u00b0C")
        print(f"\nAverage temp: {round(avg, 1)}\u00b0C")
        print(f"Hottest core: {round(hottest, 1)}\u00b0C")
        print(f"Coldest core: {round(coldest, 1)}\u00b0C")

