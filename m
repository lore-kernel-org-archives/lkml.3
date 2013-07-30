Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3G3WsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:48:01 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33414 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3G3Wr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:47:57 -0400
Date: Tue, 30 Jul 2013 15:47:51 -0700
From: Jim Davis <jim.epost@gmail.com>
To: sfr@can.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, brudley@broadcom.com, arend@broadcom.com,
        frankly@broadcom.com, meuleman@broadcom.com
Subject: randconfig build error with next-20130730, in
 drivers/net/wirelessbrcm80211
Message-ID: <20130730224751.GA13682@krebstar.arl.arizona.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Building with the attached random configuration file, 

  LD      init/built-in.o
drivers/built-in.o: In function `brcmf_sdbrcm_rxglom':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1276: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1280: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1288: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1297: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1307: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1310: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1326: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1329: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1339: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1350: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_readframes':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1565: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1578: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1588: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1604: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1621: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1630: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1636: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1639: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1650: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1663: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1667: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1683: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1685: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1708: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1710: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_release_dongle':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3682: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3685: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe_attach':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3511: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3588: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3605: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_probe_init':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3613: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3625: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_txctl':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2490: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2492: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2536: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2538: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2545: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2548: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_stop':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1946: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1980: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_dpc':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2061: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2144: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2192: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2226: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_txpkt':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1838: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1866: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_sendfromq':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1906: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:1910: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_dpc':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2257: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2259: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_download_firmware':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3230: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3238: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_init':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3268: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3342: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdbrcm_bus_watchdog':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3403: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3407: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3454: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3456: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_buffrw':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:361: undefined reference to `sdio_memcpy_toio'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:365: undefined reference to `sdio_memcpy_fromio'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:370: undefined reference to `sdio_readsb'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:477: undefined reference to `mmc_set_data_timeout'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:478: undefined reference to `mmc_wait_for_req'
drivers/built-in.o: In function `brcmf_sdio_intr_unregister':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:140: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:143: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:156: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:157: undefined reference to `sdio_release_irq'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:158: undefined reference to `sdio_release_irq'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:159: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_intr_register':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:110: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:123: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:126: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:127: undefined reference to `sdio_claim_irq'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:128: undefined reference to `sdio_claim_irq'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:129: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_ramrw':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:660: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:708: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_pd_probe':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:477: undefined reference to `sdio_register_driver'
drivers/built-in.o: In function `brcmf_sdio_pd_remove':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:491: undefined reference to `sdio_unregister_driver'
drivers/built-in.o: In function `brcmf_sdioh_f0_write_byte':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:105: undefined reference to `sdio_enable_func'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:111: undefined reference to `sdio_disable_func'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:124: undefined reference to `sdio_writeb'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:130: undefined reference to `sdio_f0_writeb'
drivers/built-in.o: In function `brcmf_sdioh_request_byte':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:152: undefined reference to `sdio_writeb'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:155: undefined reference to `sdio_f0_readb'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:158: undefined reference to `sdio_readb'
drivers/built-in.o: In function `brcmf_sdioh_request_word':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:190: undefined reference to `sdio_writel'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:193: undefined reference to `sdio_writew'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:199: undefined reference to `sdio_readl'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:201: undefined reference to `sdio_readw'
drivers/built-in.o: In function `brcmf_sdioh_attach':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:279: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:281: undefined reference to `sdio_set_block_size'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:287: undefined reference to `sdio_set_block_size'
drivers/built-in.o: In function `brcmf_sdioh_enablefuncs':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:261: undefined reference to `sdio_enable_func'
drivers/built-in.o: In function `brcmf_sdioh_attach':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:296: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdioh_detach':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:306: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:307: undefined reference to `sdio_disable_func'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:308: undefined reference to `sdio_release_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:311: undefined reference to `sdio_claim_host'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:312: undefined reference to `sdio_disable_func'
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:313: undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_exit':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:511: undefined reference to `sdio_unregister_driver'
drivers/built-in.o: In function `brcmf_sdio_init':
/home/jim/linux/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:523: undefined reference to `sdio_register_driver'
make: *** [vmlinux] Error 1

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="randconfig-1375213081.txt"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.11.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_PRINTK is not set
# CONFIG_BUG is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
# CONFIG_FUTEX is not set
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_PCI_QUIRKS is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
CONFIG_MGEODE_LX=y
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_USE_3DNOW=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ACPI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_RAPIDIO=m
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
CONFIG_RAPIDIO_CPS_XX=m
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=m
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CONNTRACK_PROCFS is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_FTP=m
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_SIP is not set
# CONFIG_NF_NAT_TFTP is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
# CONFIG_IP_SET_BITMAP_IPMAC is not set
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
# CONFIG_IP_VS_WLC is not set
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=m
# CONFIG_IP_VS_NQ is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT_IPV4=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=m
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=m
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
# CONFIG_RDS_RDMA is not set
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
CONFIG_COPS=m
CONFIG_COPS_DAYNA=y
CONFIG_COPS_TANGENT=y
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
# CONFIG_NET_EMATCH_META is not set
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_LL_RX_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_INTERNAL_REGDB=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=m
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
# CONFIG_PNP is not set
# CONFIG_BLK_DEV is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=m
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_IFB=m
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=m
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
# CONFIG_MACVLAN is not set
CONFIG_VXLAN=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=m
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=m
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=m
CONFIG_ARCNET_COM20020_PCI=y
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set
# CONFIG_VHOST_SCSI is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
CONFIG_VORTEX=m
CONFIG_TYPHOON=y
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
# CONFIG_LANCE is not set
# CONFIG_PCNET32 is not set
CONFIG_NI65=m
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=y
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
# CONFIG_SKGE is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=m
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
# CONFIG_QLGE is not set
CONFIG_NETXEN_NIC=m
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=m
CONFIG_SIS190=m
CONFIG_SFC=m
CONFIG_SFC_MTD=y
# CONFIG_SFC_MCDI_MON is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_PLATFORM is not set
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=y
CONFIG_PPTP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_ATH_CARDS=y
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH6KL=y
# CONFIG_ATH6KL_SDIO is not set
CONFIG_ATH6KL_DEBUG=y
CONFIG_ATH6KL_REGDOMAIN=y
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_SDIO=m
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_MESH is not set
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
CONFIG_SBNI=m
# CONFIG_SBNI_MULTILINE is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=m
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_TWL6040_VIBRA=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
# CONFIG_SERIO_LIBPS2 is not set
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
CONFIG_R3964=y
CONFIG_APPLICOM=m
CONFIG_SONYPI=m
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=m
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=m
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TWL6040=m
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=m
CONFIG_GPIO_AMD8111=m
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=m
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=m
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=m
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MAX77693=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_RC5T583=m
CONFIG_REGULATOR_S2MPS11=m
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TPS65910 is not set
# CONFIG_REGULATOR_TPS80031 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_AS3711=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_V4L2_INT_DEVICE=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_VIDEO_VIA_CAMERA is not set
CONFIG_VIDEO_TIMBERDALE=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=m
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_PMS=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=m

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
# CONFIG_SOC_CAMERA_IMX074 is not set
CONFIG_SOC_CAMERA_MT9M001=m
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
# CONFIG_SOC_CAMERA_OV2640 is not set
# CONFIG_SOC_CAMERA_OV5642 is not set
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=m
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
# CONFIG_VGA_ARB is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=y
CONFIG_FB_PM3=m
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_MAX8925=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_TPS65217=m
# CONFIG_BACKLIGHT_AS3711 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_MSNDCLAS=y

#
# Compiled-in MSND Classic support requires firmware during compilation.
#
CONFIG_MSNDCLAS_HAVE_BOOT=y
CONFIG_MSNDCLAS_INIT_FILE="/etc/sound/msndinit.bin"
CONFIG_MSNDCLAS_PERM_FILE="/etc/sound/msndperm.bin"
CONFIG_MSNDCLAS_IRQ=5
CONFIG_MSNDCLAS_MEM=D0000
CONFIG_MSNDCLAS_IO=290
CONFIG_SOUND_MSNDPIN=y

#
# Compiled-in MSND Pinnacle support requires firmware during compilation.
#
CONFIG_MSNDPIN_HAVE_BOOT=y
CONFIG_MSNDPIN_INIT_FILE="/etc/sound/pndspini.bin"
CONFIG_MSNDPIN_PERM_FILE="/etc/sound/pndsperm.bin"
CONFIG_MSNDPIN_IRQ=5
CONFIG_MSNDPIN_MEM=D0000
CONFIG_MSNDPIN_IO=290
# CONFIG_MSNDPIN_DIGITAL is not set
CONFIG_MSNDPIN_NONPNP=y

#
# MSND Pinnacle DSP section will be configured to above parameters.
#
CONFIG_MSNDPIN_CFG=250

#
# Pinnacle-specific Device Configuration (0 disables)
#
CONFIG_MSNDPIN_MPU_IO=0
CONFIG_MSNDPIN_MPU_IRQ=0
CONFIG_MSNDPIN_IDE_IO0=0
CONFIG_MSNDPIN_IDE_IO1=0
CONFIG_MSNDPIN_IDE_IRQ=0
CONFIG_MSNDPIN_JOYSTICK_IO=0
CONFIG_MSND_FIFOSIZE=128
# CONFIG_SOUND_OSS is not set

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
# CONFIG_MLX5_INFINIBAND is not set
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_OCRDMA=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_KCOMEDILIB is not set
# CONFIG_COMEDI_TEST is not set
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=m
# CONFIG_COMEDI_PCL724 is not set
CONFIG_COMEDI_PCL726=m
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
# CONFIG_COMEDI_PCM3724 is not set
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
CONFIG_COMEDI_AMPLC_PC263_ISA=m
# CONFIG_COMEDI_RTI800 is not set
# CONFIG_COMEDI_RTI802 is not set
CONFIG_COMEDI_DAS16M1=m
# CONFIG_COMEDI_DAS08_ISA is not set
# CONFIG_COMEDI_DAS16 is not set
# CONFIG_COMEDI_DAS800 is not set
CONFIG_COMEDI_DAS1800=m
CONFIG_COMEDI_DAS6402=m
# CONFIG_COMEDI_DT2801 is not set
CONFIG_COMEDI_DT2811=m
# CONFIG_COMEDI_DT2814 is not set
CONFIG_COMEDI_DT2815=m
# CONFIG_COMEDI_DT2817 is not set
CONFIG_COMEDI_DT282X=m
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_FL512=m
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
# CONFIG_COMEDI_C6XDIGIO is not set
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
CONFIG_COMEDI_NI_AT_AO=m
# CONFIG_COMEDI_NI_LABPC_ISA is not set
CONFIG_COMEDI_PCMAD=m
# CONFIG_COMEDI_PCMDA12 is not set
CONFIG_COMEDI_PCMMIO=m
# CONFIG_COMEDI_PCMUIO is not set
CONFIG_COMEDI_MULTIQ3=m
# CONFIG_COMEDI_POC is not set
# CONFIG_COMEDI_S526 is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_R8187SE is not set
# CONFIG_RTLLIB is not set
CONFIG_VT6655=m
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=m
# CONFIG_FB_XGI is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_DT3155=m
# CONFIG_DT3155_CCIR is not set
CONFIG_DT3155_STREAMING=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_CHROMEOS_LAPTOP=m
# CONFIG_DELL_LAPTOP is not set
CONFIG_AMILO_RFKILL=m
CONFIG_SENSORS_HDAPS=m
CONFIG_IBM_RTL=m
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
CONFIG_MAX1363=m
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_SENSORS_LM3533=m
CONFIG_SENSORS_TSL2563=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure Sensors
#
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=m
# CONFIG_9P_FSCACHE is not set
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
CONFIG_BACKTRACE_SELF_TEST=m
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_AMD is not set
CONFIG_LGUEST=m
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=m
CONFIG_OID_REGISTRY=m

--FL5UXtIhxfXey3p5--
