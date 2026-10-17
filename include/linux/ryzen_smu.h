/* SPDX-License-Identifier: GPL-2.0 */
/* Interface exported by ryzen_smu to other kernel modules. */

#ifndef _LINUX_RYZEN_SMU_H
#define _LINUX_RYZEN_SMU_H

#include <linux/types.h>
#include <linux/device.h>

enum smu_processor_codename;
enum smu_if_version;

/* PM table access. Returns the number of bytes read or a negative errno. */
int ryzen_smu_read_pm_table(void *dst, size_t *len);
/* Size of the PM table in bytes, or 0 before the first successful read. */
size_t ryzen_smu_get_pm_table_size(void);

/* Metadata */
enum smu_processor_codename ryzen_smu_get_codename(void);
const char *ryzen_smu_get_codename_name(void);
int ryzen_smu_get_pm_table_version(u32 *version);
enum smu_if_version ryzen_smu_get_mp1_if_version(void);

/* CPUID-derived CPU identification */
u32 ryzen_smu_get_cpu_family(void);
u32 ryzen_smu_get_cpu_model(void);
u32 ryzen_smu_get_cpu_stepping(void);
u32 ryzen_smu_get_cpu_package_type(void);

/* The root complex the driver is bound to, e.g. as a hwmon parent. */
struct device *ryzen_smu_get_device(void);

#endif /* _LINUX_RYZEN_SMU_H */
