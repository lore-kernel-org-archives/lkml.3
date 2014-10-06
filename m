Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaJFXNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 19:13:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58834 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780AbaJFXNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:13:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Notice] ACPI+PM commit queue for 3.18 (first pull request)
Date: Tue, 07 Oct 2014 01:33:17 +0200
Message-ID: <1504818.BmyUiDHnvP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

Below is a summary of the current ACPI core and PM core commit queue
for 3.18.  This is the material I'm going to include into my first
pull request for 3.18 and I'm not likely to add anything to that.

If anything is missing, please let me know and I'll queue it up
for subsequent pull requests.

Of course, as usual, fixes are always welcome, so please post them
if you have any (but please make sure that the problems being fixed
haven't been addressed already).

Kind regards,
Rafael


---------------

Aaron Lu (1):
      ACPI / video: check _DOD list when creating backlight devices

Bob Moore (3):
      ACPICA: Add _PSx names to the METHOD_NAME list.
      ACPICA: Disassembler: Fix for gpio_int interrupt polarity flags.
      ACPICA: Update version to 20140828.

Edward Lin (1):
      ACPI / blacklist: add Win8 OSI quirks for some Dell laptop models

Fabian Frederick (1):
      ACPI / processor: use container_of instead of casting first structure member

Geert Uytterhoeven (3):
      PM / domains: Spelling s/domian/domain/
      PM / Domains: Add genpd attach/detach callbacks
      PM / clk: Fix crash in clocks management code if !CONFIG_PM_RUNTIME

Hanjun Guo (2):
      ACPICA: ACPI 5.1/Disassembler: Add GICC affinity subtable to SRAT table.
      ACPICA: Headers: Add GTDT flag definitions for the timer subtable.

Hans de Goede (1):
      ACPI / video: Remove video_set_use_native_backlight quirk

Heikki Krogerus (5):
      ACPI / LPSS: introduce flags
      ACPI / LPSS: drop clkdev_name member from lpss_device_desc
      ACPI / LPSS: support for 133MHz I2C source clock on Baytrail
      ACPI / LPSS: remove struct lpss_shared_clock
      ACPI / LPSS: not using UART RTS override with Auto Flow Control

Heiko Stübner (2):
      regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
      PM / AVS: rockchip-io: add driver handling Rockchip io domains

Joerg Roedel (1):
      PM / hibernate: Iterate over set bits instead of PFNs in swsusp_free()

Johannes Berg (1):
      PM / sysfs: avoid shadowing variables

Kevin Hilman (2):
      cpuidle: big.LITTLE: add Exynos5800 compatible string
      MAINTAINERS: update entry for drivers/power/avs

Lorenzo Pieralisi (7):
      Documentation: arm: define DT idle states bindings
      arm64: kernel: refactor the CPU suspend API for retention states
      arm64: kernel: introduce cpu_init_idle CPU operation
      arm64: add PSCI CPU_SUSPEND based cpu_suspend support
      drivers: cpuidle: implement DT based idle states infrastructure
      drivers: cpuidle: CPU idle ARM64 driver
      drivers: cpuidle: initialize big.LITTLE driver through DT

Lucas Stach (1):
      cpufreq: cpufreq-dt: fix potential double put of cpu OF node

Maciej Matraszek (1):
      PM / Domains: add debugfs listing of struct generic_pm_domain-s

Matthew Garrett (3):
      ACPI / SBS: Don't assume the existence of an SBS charger
      ACPI / SBS: Disable smart battery manager on Apple
      ACPI: Support _OSI("Darwin") correctly

Paul Bolle (1):
      PM / devfreq: Remove ARCH_HAS_OPP completely

Preeti U Murthy (2):
      cpufreq: Allow stop CPU callback to be used by all cpufreq drivers
      cpufreq: powernv: Set the pstate of the last hotplugged out cpu in policy->cpus to minimum

Punit Agrawal (1):
      PM / devfreq: exynos: Enable building exynos PPMU as module

Rafael J. Wysocki (10):
      PM / sleep: Mechanism for aborting system suspends unconditionally
      x86 / PM: Set IRQCHIP_SKIP_SET_WAKE for IOAPIC IRQ chip objects
      PCI / PM: Make PCIe PME interrupts wake up from suspend-to-idle
      PM / genirq: Document rules related to system suspend and interrupts
      ACPI / SBS: Fix check in acpi_ac_get_present()
      ACPICA: Clear all non-wakeup GPEs in acpi_hw_enable_wakeup_gpe_block()
      ACPICA: Introduce acpi_enable_all_wakeup_gpes()
      PM / sleep: Export dpm_suspend_late/noirq() and dpm_resume_early/noirq()
      PM / sleep: Rename platform suspend/resume functions in suspend.c
      ACPI / sleep: Rework the handling of ACPI GPE wakeup from suspend-to-idle

Rasmus Villemoes (3):
      ACPI / battery: Replace strnicmp with strncasecmp
      cpuidle: Replace strnicmp with strncasecmp
      cpufreq: Replace strnicmp with strncasecmp

Shilpasri G Bhat (1):
      cpufreq: powernv: Set the cpus to nominal frequency during reboot/kexec

Srinivas Pandruvada (3):
      PM / sleep: Support freeze as test_suspend option
      PM / sleep: Enhance test_suspend option with repeat capability
      PM / sleep: Update test_suspend option documentation

Stepan Bujnak (1):
      ACPI / video: force vendor backlight on Lenovo Ideapad Z570

Sudip Mukherjee (1):
      ACPI / fan: printk replacement

Thomas Gleixner (9):
      genirq: Move suspend/resume logic into irq/pm code
      genirq: Add sanity checks for PM options on shared interrupt lines
      genirq: Make use of pm misfeature accounting
      genirq: Move MASK_ON_SUSPEND handling into suspend_device_irqs()
      genirq: Avoid double loop on suspend
      genirq: Distangle edge handler entry
      genirq: Create helper for flow handler entry check
      genirq: Mark wakeup sources as armed on suspend
      genirq: Simplify wakeup mechanism

Todd E Brandt (1):
      PM / sleep: new suspend_resume trace event for console resume

Tomasz Figa (2):
      PM / Domains: Add generic OF-based PM domain look-up
      ARM: exynos: Move to generic PM domain DT bindings

Ulf Hansson (27):
      PM / domains: Remove the pm_genpd_add|remove_callbacks APIs
      PM / domains: Ignore callbacks for subsys generic_pm_domain_data
      PM / domains: Remove system PM callbacks from gpd_dev_ops
      ARM: shmobile: Drop dev_irq_safe from r8a7779 genpd config
      ARM: shmobile: Drop dev_irq_safe from R-mobile genpd config
      PM / domains: Remove dev_irq_safe from genpd config
      PM / domains: Remove redundant check for CONFIG_PM
      PM / domains: Remove pm_genpd_syscore_switch() API
      PM / domains: Remove genpd_queue_power_off_work() API
      PM / domains: Add late_initcall to disable unused PM domains
      ARM: exynos: Leave disabling of unused PM domains to genpd
      ARM: s3c64xx: Leave disabling of unused PM domains to genpd
      drivers: sh: Leave disabling of unused PM domains to genpd
      PM / domains: Remove default_stop_ok() API
      PM / domains: Keep declaration of dev_power_governors together
      PM / Domains: Add a detach callback to the struct dev_pm_domain
      ACPI / PM: Assign the ->detach() callback when attaching the PM domain
      PM / Domains: Add APIs to attach/detach a PM domain for a device
      drivercore / platform: Convert to dev_pm_domain_attach|detach()
      i2c: core: Convert to dev_pm_domain_attach|detach()
      mmc: sdio: Convert to dev_pm_domain_attach|detach()
      spi: core: Convert to dev_pm_domain_attach|detach()
      amba: Add support for attach/detach of PM domains
      ACPI / PM: Convert acpi_dev_pm_detach() into a static function
      PM / Domains: Remove legacy API for adding devices through DT
      PM / Domains: Move dev_pm_domain_attach|detach() to pm_domain.h
      PM / Domains: Rename cpu_data to cpuidle_data

Viresh Kumar (10):
      cpufreq: Add support for per-policy driver data
      cpufreq: cpu0: Update Module Author
      cpufreq: cpu0: don't validate clock on clk_put()
      cpufreq: cpu0: print relevant error when we defer probe
      cpufreq: cpu0: use dev_{err|warn|dbg} instead of pr_{err|warn|debug}
      cpufreq: cpu0: Move per-cluster initialization code to ->init()
      cpufreq: cpu0: try regulators with name "cpu-supply"
      cpufreq: cpu0: Make allocate_resources() work for any CPU
      cpufreq: ppc-corenet: remove duplicate update of cpu_data
      cpufreq: cpu0: rename driver and internals to 'cpufreq_dt'

Yijing Wang (1):
      ACPI / utils: Update acpi_check_dsm() comments

Zhang Rui (1):
      ACPI / PNP: remove Fujitsu device IDs from ACPI PNP ID list

Ãrjan Eide (1):
      PM / devfreq: Export helper functions for drivers

---------------

 Documentation/devicetree/bindings/arm/cpus.txt     |   8 +
 .../bindings/arm/exynos/power_domain.txt           |  13 +-
 .../devicetree/bindings/arm/idle-states.txt        | 679 ++++++++++++++++
 Documentation/devicetree/bindings/arm/psci.txt     |  14 +-
 .../cpufreq/{cpufreq-cpu0.txt => cpufreq-dt.txt}   |   8 +-
 .../devicetree/bindings/power/power_domain.txt     |  49 ++
 .../bindings/power/rockchip-io-domain.txt          |  83 ++
 Documentation/kernel-parameters.txt                |  10 +-
 Documentation/power/suspend-and-interrupts.txt     | 123 +++
 MAINTAINERS                                        |   4 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |  23 +
 arch/arm/configs/mvebu_v7_defconfig                |   2 +-
 arch/arm/mach-exynos/exynos.c                      |   1 -
 arch/arm/mach-exynos/pm_domains.c                  |  78 +-
 arch/arm/mach-imx/imx27-dt.c                       |   2 +-
 arch/arm/mach-imx/mach-imx51.c                     |   2 +-
 arch/arm/mach-mvebu/pmsu.c                         |   2 +-
 arch/arm/mach-omap2/pm.c                           |   2 +-
 arch/arm/mach-s3c64xx/common.c                     |   5 -
 arch/arm/mach-s3c64xx/common.h                     |   7 -
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   1 -
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   1 -
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   1 -
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   1 -
 arch/arm/mach-s3c64xx/mach-ncp.c                   |   1 -
 arch/arm/mach-s3c64xx/mach-real6410.c              |   1 -
 arch/arm/mach-s3c64xx/mach-smartq5.c               |   1 -
 arch/arm/mach-s3c64xx/mach-smartq7.c               |   1 -
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |   1 -
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   1 -
 arch/arm/mach-s3c64xx/pm.c                         |   7 -
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |   2 +-
 arch/arm/mach-shmobile/cpufreq.c                   |   2 +-
 arch/arm/mach-shmobile/pm-r8a7779.c                |   1 -
 arch/arm/mach-shmobile/pm-rmobile.c                |   1 -
 arch/arm/mach-shmobile/setup-sh73a0.c              |   4 +-
 arch/arm/mach-zynq/common.c                        |   2 +-
 arch/arm64/include/asm/cpu_ops.h                   |   3 +
 arch/arm64/include/asm/cpuidle.h                   |  13 +
 arch/arm64/include/asm/suspend.h                   |   1 +
 arch/arm64/kernel/Makefile                         |   1 +
 arch/arm64/kernel/cpuidle.c                        |  31 +
 arch/arm64/kernel/psci.c                           | 104 +++
 arch/arm64/kernel/sleep.S                          |  47 +-
 arch/arm64/kernel/suspend.c                        |  48 +-
 arch/x86/kernel/apic/io_apic.c                     |   5 +
 drivers/acpi/acpi_lpss.c                           | 167 ++--
 drivers/acpi/acpi_pnp.c                            |   4 -
 drivers/acpi/acpica/evxfgpe.c                      |  32 +
 drivers/acpi/acpica/hwgpe.c                        |   8 +-
 drivers/acpi/acpica/utresrc.c                      |   4 +-
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/blacklist.c                           |  36 +-
 drivers/acpi/device_pm.c                           |  71 +-
 drivers/acpi/fan.c                                 |  18 +-
 drivers/acpi/osl.c                                 |  12 +-
 drivers/acpi/pci_root.c                            |  14 +
 drivers/acpi/processor_core.c                      |   6 +-
 drivers/acpi/sbs.c                                 |  80 +-
 drivers/acpi/sleep.c                               |  16 +
 drivers/acpi/utils.c                               |   1 -
 drivers/acpi/video.c                               | 291 +------
 drivers/acpi/video_detect.c                        |   8 +
 drivers/amba/bus.c                                 |  11 +-
 drivers/base/platform.c                            |  16 +-
 drivers/base/power/clock_ops.c                     |  19 +-
 drivers/base/power/common.c                        |  52 ++
 drivers/base/power/domain.c                        | 865 ++++++++++++---------
 drivers/base/power/domain_governor.c               |   7 +-
 drivers/base/power/main.c                          |   8 +-
 drivers/base/power/sysfs.c                         |  24 +-
 drivers/base/power/wakeup.c                        |  16 +-
 drivers/base/syscore.c                             |   7 +-
 drivers/cpufreq/Kconfig                            |   8 +-
 drivers/cpufreq/Kconfig.arm                        |   2 +-
 drivers/cpufreq/Makefile                           |   2 +-
 drivers/cpufreq/cpufreq-cpu0.c                     | 248 ------
 drivers/cpufreq/cpufreq-dt.c                       | 364 +++++++++
 drivers/cpufreq/cpufreq.c                          |   8 +-
 drivers/cpufreq/exynos4210-cpufreq.c               |   2 +-
 drivers/cpufreq/exynos4x12-cpufreq.c               |   2 +-
 drivers/cpufreq/exynos5250-cpufreq.c               |   2 +-
 drivers/cpufreq/highbank-cpufreq.c                 |   6 +-
 drivers/cpufreq/powernv-cpufreq.c                  |  44 ++
 drivers/cpufreq/ppc-corenet-cpufreq.c              |   1 -
 drivers/cpufreq/s5pv210-cpufreq.c                  |   2 +-
 drivers/cpuidle/Kconfig                            |   8 +
 drivers/cpuidle/Kconfig.arm                        |   1 +
 drivers/cpuidle/Kconfig.arm64                      |  14 +
 drivers/cpuidle/Makefile                           |   5 +
 drivers/cpuidle/cpuidle-arm64.c                    | 133 ++++
 drivers/cpuidle/cpuidle-big_little.c               |  20 +
 drivers/cpuidle/dt_idle_states.c                   | 213 +++++
 drivers/cpuidle/dt_idle_states.h                   |   7 +
 drivers/cpuidle/governor.c                         |   2 +-
 drivers/devfreq/Kconfig                            |   3 +-
 drivers/devfreq/devfreq.c                          |   3 +
 drivers/devfreq/exynos/exynos_ppmu.c               |   3 +
 drivers/i2c/i2c-core.c                             |  14 +-
 drivers/mmc/core/sdio_bus.c                        |   5 +-
 drivers/pci/pcie/pme.c                             |  61 +-
 drivers/platform/x86/fujitsu-laptop.c              |  16 +-
 drivers/power/avs/Kconfig                          |   8 +
 drivers/power/avs/Makefile                         |   1 +
 drivers/power/avs/rockchip-io-domain.c             | 351 +++++++++
 drivers/regulator/core.c                           |  63 +-
 drivers/sh/pm_runtime.c                            |  11 -
 drivers/spi/spi.c                                  |  13 +-
 include/acpi/acnames.h                             |   4 +
 include/acpi/acpixf.h                              |   3 +-
 include/acpi/actbl1.h                              |  19 +-
 include/acpi/actbl3.h                              |   9 +-
 include/linux/acpi.h                               |   2 -
 include/linux/cpufreq.h                            |   3 +
 include/linux/interrupt.h                          |   5 -
 include/linux/irq.h                                |   8 +
 include/linux/irqdesc.h                            |  10 +
 include/linux/pm.h                                 |   5 +
 include/linux/pm_domain.h                          | 130 ++--
 include/linux/regulator/consumer.h                 |  20 +
 include/linux/suspend.h                            |   6 +
 kernel/irq/chip.c                                  |  85 +-
 kernel/irq/internals.h                             |  16 +-
 kernel/irq/manage.c                                |  32 +-
 kernel/irq/pm.c                                    | 159 ++--
 kernel/power/Kconfig                               |   4 +
 kernel/power/process.c                             |   1 +
 kernel/power/snapshot.c                            |  54 +-
 kernel/power/suspend.c                             |  51 +-
 kernel/power/suspend_test.c                        |  32 +-
 130 files changed, 3968 insertions(+), 1528 deletions(-)

