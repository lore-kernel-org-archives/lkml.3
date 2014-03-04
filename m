Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaCDUCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:02:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCDUCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.13 000/172] 3.13.6-stable review
Date: Tue,  4 Mar 2014 12:01:24 -0800
Message-Id: <20140304200259.626667112@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.13.6 release.
There are 172 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar  6 20:02:29 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.6-rc1

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: add native aux defer retry limit

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: increase native aux defer retry timeout

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: free uvd ring on unload

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable pll sharing for DP on DCE4.1

Christian König <christian.koenig@amd.com>
    drm/radeon: fix missing bo reservation

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: print the supported atpx function mask

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix audio disable on dce6+

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix the error path for the thin device constructor

Mike Snitzer <snitzer@redhat.com>
    dm thin: avoid metadata commit if a pool's thin devices haven't changed

Mike Snitzer <snitzer@redhat.com>
    dm cache: move hook_info into common portion of per_bio_data structure

Hannes Reinecke <hare@suse.de>
    dm mpath: fix stalls when handling invalid ioctls

Linus Walleij <linus.walleij@linaro.org>
    dma: ste_dma40: don't dereference free:d descriptor

Sebastian Capella <sebastian.capella@linaro.org>
    PM / hibernate: Fix restore hang in freeze_processes()

Jean Delvare <jdelvare@suse.de>
    i7300_edac: Fix device reference count

Dr. Greg Wettstein <greg@enjellic.com>
    qla2xxx: Fix kernel panic on selective retransmission request

Olof Johansson <olof@lixom.net>
    ARM64: unwind: Fix PC calculation

James Hogan <james.hogan@imgtec.com>
    irq-metag*: stop set_affinity vectoring to offline cpus

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm, thp: fix infinite loop on memcg OOM

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    Input - arizona-haptics: Fix double lock of dapm_mutex

Davidlohr Bueso <davidlohr@hp.com>
    ipc,mqueue: remove limits for the amount of system-wide queues

Jan Kara <jack@suse.cz>
    quota: Fix race between dqput() and dquot_scan_active()

Dan Williams <dan.j.williams@intel.com>
    ioat: fix tasklet tear down

Eric Paris <eparis@redhat.com>
    SELinux: bigendian problems with filename trans rules

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: introduce spill_registers_kernel macro

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: save current register frame in fast_syscall_spill_registers_fixup

Andrew Lunn <andrew@lunn.ch>
    irqchip: orion: Fix getting generic chip pointer.

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    irqchip: orion: clear stale interrupts in irq_startup

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    irqchip: orion: use handle_edge_irq on bridge irqs

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    irqchip: orion: clear bridge cause register on init

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for HP Folio 13 mute LED

Peter Zijlstra <peterz@infradead.org>
    perf: Fix hotplug splat

Ben Hutchings <ben@decadent.org.uk>
    perf trace: Add fallback definition of EFD_SEMAPHORE

Will Deacon <will.deacon@arm.com>
    iommu/arm-smmu: set CBARn.BPSHCFG to NSH for s1-s2-bypass contexts

Will Deacon <will.deacon@arm.com>
    iommu/arm-smmu: fix table flushing during initial allocations

Will Deacon <will.deacon@arm.com>
    iommu/arm-smmu: really fix page table locking

Yifan Zhang <zhangyf@marvell.com>
    iommu/arm-smmu: fix pud/pmd entry fill sequence

Denis CIOCCA <denis.ciocca@st.com>
    iio:gyro: bug on L3GD20H gyroscope support

Manu Gupta <manugupt1@gmail.com>
    staging: r8188eu: Add new device ID

Juergen Beisert <jbe@pengutronix.de>
    staging:iio:adc:MXS:LRADC: fix touchscreen statemachine

Arve Hjønnevåg <arve@android.com>
    staging: binder: Fix death notifications

Pekon Gupta <pekon@ti.com>
    mtd: nand: omap: fix ecclayout->oobfree->length

Pekon Gupta <pekon@ti.com>
    mtd: nand: omap: fix ecclayout->oobfree->offset

Pekon Gupta <pekon@ti.com>
    mtd: nand: omap: fix ecclayout to be in sync with u-boot NAND driver

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: da9063: Bug fix when setting max voltage on LDOs 5-11

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: ensure @task is valid across kthread_stop()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max1668) Fix writing the minimum temperature

Chao Bi <chao.bi@intel.com>
    mei: set client's read_cb to NULL when flow control fails

Joerg Dorchain <joerg@dorchain.net>
    USB: ftdi_sio: add Cressi Leonardo PID

Stanislaw Gruszka <sgruszka@redhat.com>
    usb: ehci: fix deadlock when threadirqs option is used

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Florian Fainelli <florian@openwrt.org>
    usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Matthieu CASTET <matthieu.castet@parrot.com>
    usb: chipidea: need to mask when writting endptflush and endptprime

Olivier Sobrie <olivier@sobrie.be>
    can: kvaser_usb: check number of channels returned by HW

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Use LFM bus ratio as min ratio/P state

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / processor: Rework processor throttling with work_on_cpu()

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Filter the _BCL table for duplicate brightness values

Jean Delvare <jdelvare@suse.de>
    i7core_edac: Fix PCI device reference count

Tomasz Nowicki <tomasz.nowicki@linaro.org>
    ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable INTx if BIOS left them disabled

Andrew Lunn <andrew@lunn.ch>
    PCI: mvebu: Use Device ID and revision from underlying endpoint

Jan Kara <jack@suse.cz>
    Revert "writeback: do not sync data dirtied after sync start"

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Tejun Heo <tj@kernel.org>
    sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN

Denis V. Lunev <den@openvz.org>
    ata: enable quirk from jmicron JMB350 for JMB394

Peter Zijlstra <peterz@infradead.org>
    perf/x86: Fix event scheduling

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf trace: Fix ioctl 'request' beautifier build problems on !(i386 || x86_64) arches

Marek Szyprowski <m.szyprowski@samsung.com>
    x86: dma-mapping: fix GFP_ATOMIC macro usage

Levente Kurusa <levex@linux.com>
    ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/powernv: Fix indirect XSCOM unmangling

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/powernv: Fix opal_xscom_{read,write} prototype

Laurent Dufour <ldufour@linux.vnet.ibm.com>
    powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Tony Breeds <tony@bakeyournoodle.com>
    powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

Paul Mackerras <paulus@samba.org>
    powerpc: Increase stack redzone for 64-bit userspace to 512 bytes

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Ensure that gss_auth isn't freed before its upcall messages

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Fix races in xs_nospace()

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: wm8958-dsp: Fix firmware block loading

Takashi Iwai <tiwai@suse.de>
    ASoC: sta32x: Fix array access overflow

Takashi Iwai <tiwai@suse.de>
    ASoC: sta32x: Fix wrong enum for limiter2 release rate

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sta32x: Fix cache sync

Mark Brown <broonie@linaro.org>
    ASoC: da732x: Mark DC offset control registers volatile

Takashi Iwai <tiwai@suse.de>
    ASoC: wm8770: Fix wrong number of enum items

Dylan Reid <dgreid@chromium.org>
    ASoC: max98090: sync regcache on entering STANDBY

Shawn Guo <shawn.guo@linaro.org>
    ASoC: fsl: fix pm support of machine drivers

Alexander Shiyan <shc_work@mail.ru>
    ASoC: txx9aclc_ac97: Fix kernel crash on probe

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: rt5640: Add ACPI ID for Intel Baytrail

Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
    ASoC: da9055: Fix device registration of PMIC and CODEC devices

Paolo Bonzini <pbonzini@redhat.com>
    kvm, vmx: Really fix lazy FPU on nested guest

Andrew Honig <ahonig@google.com>
    kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Johannes Berg <johannes.berg@intel.com>
    export: declare ksymtab symbols

Christoph Hellwig <hch@infradead.org>
    fs: fix iversion handling

Tejun Heo <tj@kernel.org>
    cgroup: update cgroup_enable_task_cg_lists() to grab siglock

Tejun Heo <tj@kernel.org>
    cgroup: fix locking in cgroup_cfts_commit()

Tejun Heo <tj@kernel.org>
    cgroup: fix error return from cgroup_create()

Tejun Heo <tj@kernel.org>
    cgroup: fix error return value in cgroup_mount()

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Enable front audio jacks on one HP desktop model

Hsin-Yu Chao <hychao@chromium.org>
    ALSA: hda/ca0132 - Fix recording from mode id 0x8

Hsin-Yu Chao <hychao@chromium.org>
    ALSA: hda/ca0132 - setup/cleanup streams

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - add headset mic detect quirks for two Dell laptops

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around KEF X300A firmware bug

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: fix potential kernel paging error for unicast transmissions

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: avoid double free when orig_node initialization fails

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: free skb on TVLV parsing success

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: fix TT CRC computation by ensuring byte order

Simon Wunderlich <sw@simonwunderlich.de>
    batman-adv: fix potential orig_node reference leak

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: avoid potential race condition when adding a new neighbour

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: properly check pskb_may_pull return value

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: release vlan object after checking the CRC

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: fix TT-TVLV parsing on OGM reception

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: fix soft-interface MTU computation

Eric Dumazet <edumazet@google.com>
    net: use __GFP_NORETRY for high order allocations

willy tarreau <w@1wt.eu>
    net: mvneta: replace Tx timer with a real interrupt

willy tarreau <w@1wt.eu>
    net: mvneta: add missing bit descriptions for interrupt masks and causes

willy tarreau <w@1wt.eu>
    net: mvneta: do not schedule in mvneta_tx_timeout

willy tarreau <w@1wt.eu>
    net: mvneta: use per_cpu stats to fix an SMP lock up

willy tarreau <w@1wt.eu>
    net: mvneta: increase the 64-bit rx/tx stats out of the hot path

Florian Westphal <fw@strlen.de>
    net: ip, ipv6: handle gso skbs in forwarding path

Florian Westphal <fw@strlen.de>
    net: core: introduce netif_skb_dev_features

Florian Westphal <fw@strlen.de>
    net: add and use skb_gso_transport_seglen()

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    ipv4: fix counter in_slow_tot

Jiri Bohac <jiri@boha.cz>
    bonding: 802.3ad: make aggregator_identifier bond-private

Emil Goode <emilgoode@gmail.com>
    usbnet: remove generic hard_header_len check

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    gre: add link local route when local addr is any

Emil Goode <emilgoode@gmail.com>
    net: asix: add missing flag to struct driver_info

Haiyang Zhang <haiyangz@microsoft.com>
    hyperv: Fix the carrier status setting

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix ref cnt checking deadlock

Nithin Sujir <nsujir@broadcom.com>
    tg3: Fix deadlock in tg3_change_mtu()

John Ogness <john.ogness@linutronix.de>
    tcp: tsq: fix nonagle handling

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Netgear Aircard 340U

Sabrina Dubroca <sd@queasysnail.net>
    netpoll: fix netconsole IPv6 setup

Maciej Żenczykowski <maze@google.com>
    net: fix 'ip rule' iif/oif device rename

Geert Uytterhoeven <geert@linux-m68k.org>
    ipv4: Fix runtime WARNING in rtmsg_ifa()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: add destructor for self generated skbs

Cong Wang <cwang@twopensource.com>
    bridge: fix netconsole setup over bridge

Richard Yao <ryao@gentoo.org>
    9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Eric Dumazet <edumazet@google.com>
    6lowpan: fix lockdep splats

Andy Adamson <andros@netapp.com>
    NFS fix error return in nfs4_select_rw_stateid

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Do not set NFS_INO_INVALID_LABEL unless server supports labeled NFS

Olivier Langlois <olivier@trillion01.com>
    rtlwifi: rtl8192ce: Fix too long disable of IRQs

Olivier Langlois <olivier@trillion01.com>
    rtlwifi: Fix incorrect return from rtl_ps_enable_nic()

Stanislaw Gruszka <stf_xl@wp.pl>
    rtl8187: fix regression on MIPS without coherent DMA

Pavel Shilovsky <piastry@etersoft.ru>
    CIFS: Fix too big maxBuf size for SMB3 mounts

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that uncached writes handle unmapped areas correctly

Chen Gang <gang.chen.5i5j@gmail.com>
    avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Paul Gortmaker <paul.gortmaker@windriver.com>
    avr32: fix missing module.h causing build failure in mimc200/fram.c

Dan Carpenter <dan.carpenter@oracle.com>
    jbd2: fix use after free in jbd2_journal_start_reserved()

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Rework EEH reset

Kevin Hao <haokexin@gmail.com>
    powerpc: Set the correct ksp_limit on ppc32 when switching to irq stack

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: only run PL310 init on systems with one

Shawn Guo <shawn.guo@linaro.org>
    ARM: imx6: build pm-imx6q.c independently of CONFIG_PM

Pekon Gupta <pekon@ti.com>
    ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ONENAND is built as module

Pekon Gupta <pekon@ti.com>
    ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND is built as module

Vinayak Kale <vkale@apm.com>
    ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon <will.deacon@arm.com>
    ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev

Will Deacon <will.deacon@arm.com>
    ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU

Christoffer Dall <christoffer.dall@linaro.org>
    ARM: 7950/1: mm: Fix stage-2 device memory attributes

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dma-mapping: fix GFP_ATOMIC macro usage

Theodore Ts'o <tytso@mit.edu>
    ext4: don't leave i_crtime.tv_sec uninitialized

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resize with a non-standard blocks per group setting

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resize with very large inode tables

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to modify s_flags if the the file system is read-only

Zheng Liu <wenqing.lz@taobao.com>
    ext4: fix error paths in swap_inode_boot_loader()

Eric Whitney <enwlinux@gmail.com>
    ext4: fix xfstest generic/299 block validity failures

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Add intel_ring_cachline_align()

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nv50/disp: use correct register to determine DP display bpp

Emil Velikov <emil.l.velikov@gmail.com>
    drm/nouveau/fb: use correct ram oclass for nv1a hardware

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau: set irq_enabled manually

Christian König <christian.koenig@amd.com>
    drm/radeon: fix CP semaphores on CIK

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix display tiling setup on SI

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/ni: fix typo in dpm sq ramping setup


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/include/asm/cacheflush.h               |   1 +
 arch/arm/include/asm/pgtable-3level.h           |  15 +-
 arch/arm/include/asm/spinlock.h                 |  15 +-
 arch/arm/mach-imx/Makefile                      |   2 -
 arch/arm/mach-imx/common.h                      |   4 +-
 arch/arm/mach-omap2/gpmc.c                      |   4 +-
 arch/arm/mach-tegra/tegra.c                     |  10 ++
 arch/arm/mm/dma-mapping.c                       |   2 +-
 arch/arm/mm/mm.h                                |   1 +
 arch/arm/mm/mmu.c                               |   7 +-
 arch/arm/mm/proc-v6.S                           |   3 +-
 arch/arm/mm/proc-v7.S                           |   2 +-
 arch/arm64/kernel/stacktrace.c                  |   6 +-
 arch/avr32/Makefile                             |   2 +-
 arch/avr32/boards/mimc200/fram.c                |   1 +
 arch/powerpc/include/asm/compat.h               |   5 +-
 arch/powerpc/include/asm/opal.h                 |   4 +-
 arch/powerpc/include/asm/ptrace.h               |  16 +-
 arch/powerpc/kernel/crash_dump.c                |   8 +-
 arch/powerpc/kernel/misc_32.S                   |   5 +-
 arch/powerpc/kernel/signal_64.c                 |   4 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c       |  29 +---
 arch/powerpc/platforms/powernv/opal-xscom.c     |  21 ++-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  22 +--
 arch/x86/kernel/cpu/perf_event.c                |   3 +
 arch/x86/kernel/pci-dma.c                       |   4 +-
 arch/x86/kvm/vmx.c                              |   2 +-
 arch/x86/kvm/x86.c                              |   2 +-
 arch/xtensa/include/asm/traps.h                 |  44 +++--
 arch/xtensa/kernel/entry.S                      |  72 ++++++--
 drivers/acpi/pci_irq.c                          |   1 +
 drivers/acpi/processor_throttling.c             |  69 ++++----
 drivers/acpi/video.c                            |   8 +-
 drivers/ata/ahci.c                              |  14 ++
 drivers/ata/libata-pmp.c                        |   7 +-
 drivers/ata/sata_sil.c                          |   1 +
 drivers/base/firmware_class.c                   |   1 +
 drivers/cpufreq/intel_pstate.c                  |   2 +-
 drivers/cpufreq/powernow-k8.c                   |  10 +-
 drivers/dma/ioat/dma.c                          |  52 +++++-
 drivers/dma/ioat/dma.h                          |   1 +
 drivers/dma/ioat/dma_v2.c                       |  11 +-
 drivers/dma/ioat/dma_v3.c                       |   3 +
 drivers/dma/ste_dma40.c                         |   4 +-
 drivers/edac/i7300_edac.c                       |  38 +++--
 drivers/edac/i7core_edac.c                      |   9 +-
 drivers/gpu/drm/i915/intel_display.c            |  14 ++
 drivers/gpu/drm/i915/intel_dp.c                 |  19 ++-
 drivers/gpu/drm/i915/intel_ringbuffer.c         |  21 +++
 drivers/gpu/drm/i915/intel_ringbuffer.h         |   1 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c   |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c           |   3 +
 drivers/gpu/drm/radeon/atombios_crtc.c          |  29 +++-
 drivers/gpu/drm/radeon/dce6_afmt.c              |   2 +-
 drivers/gpu/drm/radeon/evergreen.c              |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon.h                 |   4 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |   3 +-
 drivers/gpu/drm/radeon/radeon_kms.c             |   6 +
 drivers/gpu/drm/radeon/radeon_ring.c            |   2 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c       |  19 ++-
 drivers/gpu/drm/radeon/radeon_uvd.c             |   2 +
 drivers/gpu/drm/radeon/rv770.c                  |   2 +-
 drivers/hwmon/max1668.c                         |   2 +-
 drivers/iio/gyro/Kconfig                        |   2 +-
 drivers/iio/gyro/st_gyro.h                      |   1 -
 drivers/iio/gyro/st_gyro_core.c                 |   9 +-
 drivers/iio/gyro/st_gyro_i2c.c                  |   1 -
 drivers/iio/gyro/st_gyro_spi.c                  |   1 -
 drivers/input/misc/arizona-haptics.c            |  11 +-
 drivers/iommu/arm-smmu.c                        | 101 ++++++-----
 drivers/irqchip/irq-metag-ext.c                 |   2 +-
 drivers/irqchip/irq-metag.c                     |   2 +-
 drivers/irqchip/irq-orion.c                     |  22 ++-
 drivers/md/dm-cache-target.c                    |   2 +-
 drivers/md/dm-mpath.c                           |   7 +-
 drivers/md/dm-thin-metadata.c                   |  17 ++
 drivers/md/dm-thin-metadata.h                   |   2 +
 drivers/md/dm-thin.c                            |   8 +-
 drivers/mfd/da9055-i2c.c                        |  12 +-
 drivers/misc/mei/client.c                       |   4 +-
 drivers/mtd/nand/omap2.c                        |  61 ++++---
 drivers/net/bonding/bond_3ad.c                  |   6 +-
 drivers/net/bonding/bond_3ad.h                  |   1 +
 drivers/net/can/dev.c                           |  15 +-
 drivers/net/can/janz-ican3.c                    |  18 +-
 drivers/net/can/usb/kvaser_usb.c                |   2 +
 drivers/net/can/vcan.c                          |   9 +-
 drivers/net/ethernet/broadcom/tg3.c             |   4 +-
 drivers/net/ethernet/marvell/mvneta.c           | 217 +++++++++++++-----------
 drivers/net/hyperv/netvsc_drv.c                 |  53 ++++--
 drivers/net/usb/asix_devices.c                  |   3 +-
 drivers/net/usb/ax88179_178a.c                  |   4 +
 drivers/net/usb/gl620a.c                        |   4 +
 drivers/net/usb/mcs7830.c                       |   5 +-
 drivers/net/usb/net1080.c                       |   4 +
 drivers/net/usb/qmi_wwan.c                      |   9 +-
 drivers/net/usb/rndis_host.c                    |   4 +
 drivers/net/usb/smsc75xx.c                      |   4 +
 drivers/net/usb/smsc95xx.c                      |   4 +
 drivers/net/usb/usbnet.c                        |  25 ++-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h  |  10 +-
 drivers/net/wireless/rtlwifi/ps.c               |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     |  18 +-
 drivers/pci/host/pci-mvebu.c                    |  11 +-
 drivers/pci/pci.c                               |  10 ++
 drivers/regulator/da9063-regulator.c            |   4 +-
 drivers/scsi/qla2xxx/qla_target.c               |   3 +-
 drivers/staging/android/binder.c                |   3 +-
 drivers/staging/iio/adc/mxs-lradc.c             |   1 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c     |   1 +
 drivers/usb/chipidea/udc.c                      |   4 +-
 drivers/usb/gadget/bcm63xx_udc.c                |  58 ++++---
 drivers/usb/host/ehci-hcd.c                     |  13 +-
 drivers/usb/host/ehci-hub.c                     |  26 ++-
 drivers/usb/serial/ftdi_sio.c                   |   2 +
 drivers/usb/serial/ftdi_sio_ids.h               |   6 +
 drivers/usb/serial/option.c                     |   3 +-
 drivers/vhost/net.c                             |  41 +++--
 fs/attr.c                                       |   5 -
 fs/btrfs/inode.c                                |   8 +-
 fs/cifs/file.c                                  |  37 +++-
 fs/cifs/smb2glob.h                              |   3 +
 fs/cifs/smb2ops.c                               |  14 +-
 fs/cifs/smb2pdu.c                               |   4 +-
 fs/ext4/ext4.h                                  |   2 +
 fs/ext4/extents.c                               |   1 +
 fs/ext4/inode.c                                 |   4 +
 fs/ext4/ioctl.c                                 |   3 +-
 fs/ext4/resize.c                                |  34 ++--
 fs/ext4/super.c                                 |  20 ++-
 fs/fs-writeback.c                               |  33 ++--
 fs/jbd2/transaction.c                           |   6 +-
 fs/nfs/inode.c                                  |  14 +-
 fs/nfs/internal.h                               |   9 +
 fs/nfs/nfs4state.c                              |   5 +-
 fs/quota/dquot.c                                |  14 +-
 fs/sync.c                                       |  15 +-
 fs/xfs/xfs_super.c                              |   2 +-
 include/linux/can/skb.h                         |  38 +++++
 include/linux/export.h                          |   1 +
 include/linux/ipc_namespace.h                   |   2 -
 include/linux/netdevice.h                       |   7 +-
 include/linux/skbuff.h                          |  18 ++
 include/linux/writeback.h                       |   2 +-
 include/trace/events/writeback.h                |   6 +-
 ipc/mq_sysctl.c                                 |  18 +-
 ipc/mqueue.c                                    |   6 +-
 kernel/cgroup.c                                 |  32 ++--
 kernel/events/core.c                            |  12 +-
 kernel/workqueue.c                              |   7 +
 mm/huge_memory.c                                |   9 +-
 mm/memory.c                                     |  14 +-
 net/9p/trans_virtio.c                           |   5 +-
 net/batman-adv/bat_iv_ogm.c                     |  30 ++--
 net/batman-adv/hard-interface.c                 |  22 ++-
 net/batman-adv/originator.c                     |  36 ++++
 net/batman-adv/originator.h                     |   4 +
 net/batman-adv/routing.c                        |   4 +-
 net/batman-adv/send.c                           |   9 +-
 net/batman-adv/translation-table.c              |  23 ++-
 net/bridge/br_device.c                          |  51 +++---
 net/can/af_can.c                                |   3 +-
 net/can/bcm.c                                   |   4 +-
 net/core/dev.c                                  |  22 +--
 net/core/fib_rules.c                            |   7 +
 net/core/netpoll.c                              |   4 +-
 net/core/skbuff.c                               |  25 +++
 net/core/sock.c                                 |   6 +-
 net/ieee802154/6lowpan.c                        |  20 +++
 net/ipv4/devinet.c                              |   3 +-
 net/ipv4/ip_forward.c                           |  71 +++++++-
 net/ipv4/route.c                                |   4 +-
 net/ipv4/tcp_output.c                           |  13 +-
 net/ipv6/addrconf.c                             |   2 +
 net/ipv6/ip6_output.c                           |  17 +-
 net/sched/sch_tbf.c                             |  13 +-
 net/sctp/socket.c                               |  41 ++++-
 net/sunrpc/auth_gss/auth_gss.c                  |  13 +-
 net/sunrpc/xprtsock.c                           |   6 +-
 security/selinux/ss/policydb.c                  |   8 +-
 sound/pci/hda/patch_ca0132.c                    |  68 +-------
 sound/pci/hda/patch_realtek.c                   |   2 +
 sound/pci/hda/patch_sigmatel.c                  |  33 ++++
 sound/soc/codecs/da732x.c                       |  12 ++
 sound/soc/codecs/da9055.c                       |  11 +-
 sound/soc/codecs/max98090.c                     |  20 +--
 sound/soc/codecs/rt5640.c                       |   1 +
 sound/soc/codecs/sta32x.c                       |  76 ++++-----
 sound/soc/codecs/wm8770.c                       |   4 +-
 sound/soc/codecs/wm8958-dsp2.c                  |   2 +-
 sound/soc/fsl/imx-mc13783.c                     |   1 -
 sound/soc/fsl/imx-sgtl5000.c                    |  10 +-
 sound/soc/fsl/imx-wm8962.c                      |  11 +-
 sound/soc/txx9/txx9aclc-ac97.c                  |   8 +-
 sound/usb/mixer_maps.c                          |   9 +
 tools/perf/builtin-trace.c                      |  22 +++
 199 files changed, 1792 insertions(+), 929 deletions(-)


