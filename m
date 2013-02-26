Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3BZX4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:56:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3BZX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:56:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/150] 3.8.1-stable review
Date: Tue, 26 Feb 2013 15:54:17 -0800
Message-Id: <20130226235523.930663721@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.1 release.
There are 150 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 28 23:52:34 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.1-rc1

Fabio Baltieri <fabio.baltieri@linaro.org>
    usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare

Ming Lei <ming.lei@canonical.com>
    usb: musb: fix dependency on transceiver driver

Ming Lei <ming.lei@canonical.com>
    usb: musb: core: fix failure path

Josh Boyer <jwboyer@redhat.com>
    USB: usb-storage: unusual_devs update for Super TOP SATA bridge

fangxiaozhi <huananhu@huawei.com>
    USB: storage: properly handle the endian issues of idProduct

Roger Quadros <rogerq@ti.com>
    USB: ehci-omap: Fix autoloading of module

Bjørn Mork <bjorn@mork.no>
    USB: option: add Huawei "ACM" devices using protocol = vendor

Bjørn Mork <bjorn@mork.no>
    USB: option: add Yota / Megafon M100-1 4g modem

Bjørn Mork <bjorn@mork.no>
    USB: option: add and update Alcatel modems

Maciej Sosnowski <maciej.sosnowski@intel.com>
    dca: check against empty dca_domains list before unregister provider

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    dma: sh: Don't use ENODEV for failing slave lookup

Magnus Damm <damm@opensource.se>
    gpio: em: Use irq_domain_add_simple() to fix runtime error

Roger Quadros <rogerq@ti.com>
    USB: ehci-omap: Don't free gpios that we didn't request

Johannes Berg <johannes.berg@intel.com>
    mac80211: always unblock CSA queue stop when disconnecting

Cong Wang <amwang@redhat.com>
    vlan: adjust vlan_set_encap_proto() for its callers

Mathias Krause <minipli@googlemail.com>
    sock_diag: Fix out-of-bounds access to sock_diag_handlers[]

Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
    mlx4_en: fix allocation of CPU affinity reverse-map

Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
    mlx4_en: fix allocation of device tx_cq

Yuchung Cheng <ycheng@google.com>
    tcp: fix SYN-data space mis-accounting

Li Wei <lw@cn.fujitsu.com>
    ipv4: fix error handling in icmp_protocol.

Eric Dumazet <edumazet@google.com>
    ipv6: use a stronger hash for tcp

Li Wei <lw@cn.fujitsu.com>
    ipv4: fix a bug in ping_err().

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    ipv6: fix race condition regarding dst->expires and dst->from.

Eric Dumazet <edumazet@google.com>
    ppp: set qdisc_tx_busylock to avoid LOCKDEP splat

Romain KUNTZ <r.kuntz@ipflavors.com>
    xfrm: release neighbor upon dst destruction

Ying Xue <ying.xue@windriver.com>
    net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

David Vrabel <david.vrabel@citrix.com>
    xen-netback: cancel the credit timer when taking the vif down

David Vrabel <david.vrabel@citrix.com>
    xen-netback: correctly return errors from netbk_count_requests()

Bjørn Mork <bjorn@mork.no>
    net: cdc_ncm: fix probing of devices with multiple control interface altsettings

David Herrmann <dh.herrmann@gmail.com>
    HID: wiimote: fix nunchuck button parser

Balaji T K <balajitk@ti.com>
    mmc: core: expose RPMB partition only for CMD23 capable hosts

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci-esdhc-imx: fix host version read

Takashi Iwai <tiwai@suse.de>
    fb: Yet another band-aid for fixing lockdep mess

Alan Cox <alan@linux.intel.com>
    fb: rework locking to fix lock ordering on takeover

Dave Airlie <airlied@redhat.com>
    fbcon: don't lose the console font across generic->chip driver switch

Anatolij Gustschin <agust@denx.de>
    drivers/video: fsl-diu-fb: fix bugs in interrupt handling

Anatolij Gustschin <agust@denx.de>
    drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp

Jean Delvare <khali@linux-fr.org>
    pcmcia/vrc4171: Add missing spinlock init

John David Anglin <dave.anglin@bell.net>
    Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    powerpc/eeh: Fix crash when adding a device in a slot with DDW

Suzuki K. Poulose <suzuki@in.ibm.com>
    uprobes/powerpc: Add dependency on single step emulation

Phileas Fogg <phileas-fogg@mail.ru>
    powerpc/kexec: Disable hard IRQ before kexec

Joonsoo Kim <js1304@gmail.com>
    ARM: 7643/1: sched: correct update_sched_clock()

Will Deacon <will.deacon@arm.com>
    arm64: compat: use compat_uptr_t type for compat_ucontext.uc_link

Will Deacon <will.deacon@arm.com>
    ARM: integrator: ensure ap_syscon_base is initialised when !CONFIG_MMU

Steffen Trumtrar <s.trumtrar@pengutronix.de>
    ARM: i.MX25: clk: parent per5_clk to AHB clock

Arnd Bergmann <arnd@arndb.de>
    ARM: samsung: fix assembly syntax for new gas

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes

Igor Grinberg <grinberg@compulab.co.il>
    ARM: PXA3xx: program the CSMSADRCFG register

Linus Walleij <linus.walleij@linaro.org>
    ARM: 7635/1: versatile: fix the PCI IRQ regression

Ryo Tsutsui <ryo.tsutsui@wolfsonmicro.com>
    ASoC: arizona: Fixed a bug in FLL fractional calculation

Chris Rattray <crattray@opensource.wolfsonmicro.com>
    ASoC: wm2200: correct IN2L and IN3L digital mute

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix URB submitted while active warning.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Revert: 64bit fixes: dpc.c incorrect addressing of void structure.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: revert : 64 bit- Correctly address void structure.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: correct differential channel sequence for AI commands

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: set up command4 register *after* command3

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors

Minchan Kim <minchan@kernel.org>
    staging: zsmalloc: Fix TLB coherency and build problem

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Handle untiled planes when computing their offsets

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: inverted brightness quirk for Acer Aspire 4736Z

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Use HAS_L3_GPU_CACHE in i915_gem_l3_remap

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add missing \n to UTS_RELEASE in the error_state

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/i915: Set i9xx sdvo clock limits according to specifications

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    drm/i915: disable shared panel fitter for pipe

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: write backlight harder

Ben Widawsky <ben@bwidawsk.net>
    drm/i915: Fix RC6VIDS encode/decode

Ben Widawsky <ben@bwidawsk.net>
    drm/i915: Fix CAGF for HSW

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Only run idle processing from i915_gem_retire_requests_worker

Damien Lespiau <damien.lespiau@intel.com>
    drm/i915: Preserve the FDI line reversal override bit on CPT

Damien Lespiau <damien.lespiau@intel.com>
    drm/i915: Preserve the DDI link reversal configuration

Al Viro <viro@zeniv.linux.org.uk>
    get rid of unprotected dereferencing of mnt->mnt_ns

Daniel Vetter <daniel.vetter@ffwll.ch>
    intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets

Dave Airlie <airlied@redhat.com>
    drm/usb: bind driver to correct device

Daniel Vetter <daniel.vetter@ffwll.ch>
    Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm: Use C8 instead of RGB332 when determining the format from depth/bpp

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm: Fill depth/bits_per_pixel for C8 format

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm: shut up invalid edid messages

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm: don't add inferred modes for monitors that don't support them

Alex Williamson <alex.williamson@redhat.com>
    PCI: Fix PCI Express Capability accessors for PCI_EXP_FLAGS

Dave Airlie <airlied@redhat.com>
    vgacon/vt: clear buffer attributes when we load a 512 character font (v2)

Dave Airlie <airlied@redhat.com>
    drm/udl: disable fb_defio by default

Dave Airlie <airlied@redhat.com>
    drm/udl: make usage as a console safer

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly validate the atpx interface

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: remove overzealous warning in hdmi handling

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix multi-head power profile stability on BTC+ asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce6: fix display powergating

David S. Miller <davem@davemloft.net>
    sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handler.

David S. Miller <davem@davemloft.net>
    sparc64: Fix tsb_grow() in atomic context.

David S. Miller <davem@davemloft.net>
    sparc64: Handle hugepage TSB being NULL.

David S. Miller <davem@davemloft.net>
    sparc64: Fix gfp_flags setting in tsb_grow().

Bob Peterson <rpeterso@redhat.com>
    GFS2: Get a block reservation before resizing a file

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - hdmi: ELD shouldn't be valid after unplug

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix broken workaround for HDMI/SPDIF conflicts

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB with ALC889

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - Fix default multichannel HDMI mapping regression

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Disable runtime PM for Intel 5 Series/3400

Pawel Moll <mail@pawelmoll.com>
    ALSA: usb: Fix Processing Unit Descriptor parsers

Jiri Slaby <jslaby@suse.cz>
    ALSA: usb/quirks, fix out-of-bounds access

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix Roland A-PRO support

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: corrected USB ID for T-Com Sinus 154 data II

Weston Andros Adamson <dros@netapp.com>
    NFSv4.1: Don't decode skipped layoutgets

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Fix bulk recall and destroy of layouts

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Fix an ABBA locking issue with session and state serialisation

Trond Myklebust <Trond.Myklebust@netapp.com>
    NLM: Ensure that we resend all pending blocking locks after a reclaim

fanchaoting <fanchaoting@cn.fujitsu.com>
    umount oops when remove blocklayoutdriver first

Grant Likely <grant.likely@secretlab.ca>
    drivercore: Fix ordering between deferred_probe and exiting initcalls

Mel Gorman <mgorman@suse.de>
    mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages

Greg Thelen <gthelen@google.com>
    tmpfs: fix use-after-free of mempolicy object

David Howells <dhowells@redhat.com>
    KEYS: Revert one application of "Fix unreachable code" patch

Lars-Peter Clausen <lars@metafoo.de>
    drivers/video/backlight/adp88?0_bl.c: fix resume

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: unlock super lock if lockres refresh failed

MITSUNARI Shigeo <herumi@nifty.com>
    fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()

Jim Somerville <Jim.Somerville@windriver.com>
    inotify: remove broken mask checks causing unmount to be EINVAL

Thomas Gleixner <tglx@linutronix.de>
    futex: Revert "futex: Mark get_robust_list as deprecated"

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/kvm: Fix store status for ACRS/FPRS

Cornelia Huck <cornelia.huck@de.ibm.com>
    KVM: s390: Handle hosts not supporting s390-virtio.

Robin Holt <holt@sgi.com>
    mmu_notifier_unregister NULL Pointer deref and multiple ->release() callouts

Bjorn Helgaas <bhelgaas@google.com>
    Driver core: treat unregistered bus_types as having no devices

Minchan Kim <minchan@kernel.org>
    zram: Fix deadlock bug in partial read/write

George Spelvin <linux@horizon.com>
    pps: Fix a use-after free bug when unregistering a source.

George Spelvin <linux@horizon.com>
    pps: Use pps_lookup_dev to reduce ldisc coupling

George Spelvin <linux@horizon.com>
    pps: Add pps_lookup_dev() function

Wei Liu <wei.liu2@citrix.com>
    xen: close evtchn port if binding to irq fails

Stefan Bader <stefan.bader@canonical.com>
    xen: Send spinlock IPI to all waiters

Nicolas Pitre <nicolas.pitre@linaro.org>
    tty vt: fix character insertion overflow

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    rtlwifi: usb: allocate URB control message setup_packet and data buffer separately

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new USB ID

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Increase number of RX DMA slots

Michael Chan <mchan@broadcom.com>
    serial_core: Fix type definition for PORT_BRCM_TRUMANAGE.

Thomas Gleixner <tglx@linutronix.de>
    serial: imx: Fix recursive locking bug

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix null-pointer dereferences on disconnect

Oleg Nesterov <oleg@redhat.com>
    tty: set_termios/set_termiox should not return -EINTR

Dirkjan Bussink <d.bussink@gmail.com>
    tty: Prevent deadlock in n_gsm driver

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Fix Oops while PM resume

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: rme32.c irq enabling after spin_lock_irq

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: ali5451: remove irq enabling in pointer callback

Konstantin Khlebnikov <khlebnikov@openvz.org>
    workqueue: un-GPL function delayed_work_timer_fn()

Olaf Hering <[mailto:olaf@aepfle.de]>
    x86: Hyper-V: register clocksource only if its advertised

Leonid Shatz <leonid.shatz@ravellosystems.com>
    hrtimer: Prevent hrtimer_enqueue_reprogram race

Stanislaw Gruszka <sgruszka@redhat.com>
    posix-cpu-timers: Fix nanosleep task_struct leak

Thomas Gleixner <tglx@linutronix.de>
    genirq: Avoid deadlock in spurious handling

H. Peter Anvin <hpa@linux.intel.com>
    timeconst.pl: Eliminate Perl warning

Jiri Olsa <jolsa@redhat.com>
    perf hists: Fix period symbol_conf.field_sep display

Vinson Lee <vlee@twitter.com>
    perf tools: Fix build with bison 2.3 and older.

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, mm: Remove reference to alloc_remap()

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, mm: Remove reference to resume_map_numa_kva()

Dave Hansen <dave@linux.vnet.ibm.com>
    x86-32, mm: Rip out x86_32 NUMA remapping code


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm/boot/dts/at91sam9n12.dtsi               |   8 --
 arch/arm/boot/dts/at91sam9x5.dtsi                |   6 -
 arch/arm/kernel/sched_clock.c                    |   4 +-
 arch/arm/mach-imx/clk-imx25.c                    |   3 +
 arch/arm/mach-integrator/integrator_ap.c         |   2 +-
 arch/arm/mach-pxa/include/mach/smemc.h           |   1 +
 arch/arm/mach-pxa/smemc.c                        |  15 ++-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S |  12 +-
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S |   4 +-
 arch/arm/mach-s3c24xx/pm-h1940.S                 |   2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S            |  12 +-
 arch/arm/mach-s3c24xx/sleep-s3c2412.S            |  12 +-
 arch/arm/mach-versatile/core.c                   |  15 ++-
 arch/arm/mach-versatile/pci.c                    |  11 +-
 arch/arm/plat-samsung/include/plat/debug-macro.S |  18 +--
 arch/arm64/kernel/signal32.c                     |   4 +-
 arch/parisc/include/asm/pgtable.h                |  13 ++-
 arch/parisc/kernel/cache.c                       |  18 +++
 arch/powerpc/Kconfig                             |   4 +
 arch/powerpc/include/asm/eeh.h                   |   3 +
 arch/powerpc/kernel/machine_kexec_64.c           |   5 +
 arch/powerpc/kernel/of_platform.c                |   3 +
 arch/powerpc/kernel/pci-common.c                 |   7 +-
 arch/powerpc/lib/Makefile                        |   4 +-
 arch/powerpc/platforms/pseries/eeh.c             |  24 +++-
 arch/s390/kvm/kvm-s390.c                         |   8 ++
 arch/sparc/include/asm/hugetlb.h                 |   1 -
 arch/sparc/include/asm/page_64.h                 |   4 +-
 arch/sparc/include/asm/tsb.h                     |  28 +++--
 arch/sparc/kernel/tsb.S                          |  39 ++++++-
 arch/sparc/mm/fault_64.c                         |   9 +-
 arch/sparc/mm/init_64.c                          |  62 +++++++----
 arch/sparc/mm/tlb.c                              |  11 +-
 arch/sparc/mm/tsb.c                              |   2 +-
 arch/x86/Kconfig                                 |   4 -
 arch/x86/include/asm/mmzone_32.h                 |   6 -
 arch/x86/kernel/cpu/mshyperv.c                   |   3 +-
 arch/x86/mm/numa.c                               |  32 ++----
 arch/x86/mm/numa_32.c                            | 161 ---------------------------
 arch/x86/mm/numa_internal.h                      |   6 -
 arch/x86/power/hibernate_32.c                    |   2 -
 arch/x86/xen/spinlock.c                          |   1 -
 drivers/base/bus.c                               |   4 +-
 drivers/base/dd.c                                |   2 +
 drivers/dca/dca-core.c                           |   5 +
 drivers/dma/sh/shdma.c                           |   2 +-
 drivers/gpio/gpio-em.c                           |   3 +-
 drivers/gpu/drm/drm_crtc.c                       |   3 +-
 drivers/gpu/drm/drm_edid.c                       |  12 +-
 drivers/gpu/drm/drm_usb.c                        |   2 +-
 drivers/gpu/drm/i915/i915_debugfs.c              |  12 +-
 drivers/gpu/drm/i915/i915_drv.h                  |   2 +-
 drivers/gpu/drm/i915/i915_gem.c                  |   5 +-
 drivers/gpu/drm/i915/i915_reg.h                  |   9 +-
 drivers/gpu/drm/i915/intel_crt.c                 |  14 ++-
 drivers/gpu/drm/i915/intel_ddi.c                 |  25 +++--
 drivers/gpu/drm/i915/intel_display.c             |  68 ++++++-----
 drivers/gpu/drm/i915/intel_drv.h                 |  11 +-
 drivers/gpu/drm/i915/intel_panel.c               |  13 ++-
 drivers/gpu/drm/i915/intel_sprite.c              |   8 +-
 drivers/gpu/drm/radeon/atombios_crtc.c           |   6 +-
 drivers/gpu/drm/radeon/evergreen.c               |  13 +++
 drivers/gpu/drm/radeon/r600_hdmi.c               |   1 -
 drivers/gpu/drm/radeon/radeon_atpx_handler.c     |  73 +++++++++++-
 drivers/gpu/drm/radeon/radeon_pm.c               |   2 +-
 drivers/gpu/drm/udl/udl_drv.h                    |   2 +
 drivers/gpu/drm/udl/udl_fb.c                     |  48 +++++++-
 drivers/hid/hid-wiimote-ext.c                    |   8 +-
 drivers/iommu/intel-iommu.c                      |   8 +-
 drivers/mmc/core/mmc.c                           |   2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c               |  19 ++--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |   4 +-
 drivers/net/ppp/ppp_generic.c                    |   8 ++
 drivers/net/usb/cdc_ncm.c                        |  11 +-
 drivers/net/wireless/b43/dma.h                   |   2 +-
 drivers/net/wireless/p54/p54usb.c                |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |   9 +-
 drivers/net/wireless/rtlwifi/usb.c               |  49 +++++---
 drivers/net/wireless/rtlwifi/usb.h               |   3 +-
 drivers/net/xen-netback/interface.c              |   3 +-
 drivers/net/xen-netback/netback.c                |   8 +-
 drivers/pci/access.c                             |   2 +-
 drivers/pcmcia/vrc4171_card.c                    |   1 +
 drivers/pps/clients/pps-ldisc.c                  |  10 +-
 drivers/pps/pps.c                                |  47 +++++++-
 drivers/s390/kvm/kvm_virtio.c                    |  38 +++++--
 drivers/staging/comedi/comedi_fops.c             |   5 +
 drivers/staging/comedi/drivers/ni_labpc.c        |  34 +++---
 drivers/staging/vt6656/dpc.c                     |   4 +-
 drivers/staging/vt6656/rxtx.c                    |   2 +-
 drivers/staging/vt6656/usbpipe.c                 |  28 +++--
 drivers/staging/zram/zram_drv.c                  |   9 +-
 drivers/staging/zsmalloc/zsmalloc-main.c         |  10 +-
 drivers/tty/n_gsm.c                              |  42 ++++++-
 drivers/tty/serial/imx.c                         |  11 +-
 drivers/tty/tty_ioctl.c                          |   4 +-
 drivers/tty/vt/vt.c                              | 138 ++++++++++++++++-------
 drivers/usb/host/ehci-omap.c                     |  10 +-
 drivers/usb/musb/am35x.c                         |   2 +-
 drivers/usb/musb/blackfin.c                      |   2 +-
 drivers/usb/musb/da8xx.c                         |   7 +-
 drivers/usb/musb/davinci.c                       |   7 +-
 drivers/usb/musb/musb_core.c                     |   1 +
 drivers/usb/musb/musb_dsps.c                     |   2 +-
 drivers/usb/musb/omap2430.c                      |   2 +-
 drivers/usb/musb/tusb6010.c                      |   2 +-
 drivers/usb/musb/ux500.c                         |  12 +-
 drivers/usb/serial/ftdi_sio.c                    |  20 ++--
 drivers/usb/serial/mct_u232.c                    |  22 ++--
 drivers/usb/serial/option.c                      |  16 ++-
 drivers/usb/serial/quatech2.c                    |  18 ++-
 drivers/usb/serial/sierra.c                      |   8 +-
 drivers/usb/serial/ssu100.c                      |  19 ++--
 drivers/usb/serial/usb-serial.c                  |  14 ++-
 drivers/usb/serial/usb_wwan.c                    |   8 +-
 drivers/usb/storage/initializers.c               |   4 +-
 drivers/usb/storage/unusual_cypress.h            |   2 +-
 drivers/video/backlight/adp8860_bl.c             |   2 +-
 drivers/video/backlight/adp8870_bl.c             |   2 +-
 drivers/video/console/fbcon.c                    |  47 ++++++--
 drivers/video/console/vgacon.c                   |  22 ++--
 drivers/video/fbmem.c                            |   9 +-
 drivers/video/fbsysfs.c                          |   3 +
 drivers/video/fsl-diu-fb.c                       |  64 ++++++-----
 drivers/xen/evtchn.c                             |  10 ++
 fs/block_dev.c                                   |   1 +
 fs/gfs2/bmap.c                                   |   4 +
 fs/lockd/clntproc.c                              |   3 +
 fs/namespace.c                                   |  29 +++--
 fs/nfs/blocklayout/blocklayout.c                 |   1 +
 fs/nfs/callback_proc.c                           |  61 ++--------
 fs/nfs/nfs4proc.c                                |  35 +++---
 fs/nfs/objlayout/objio_osd.c                     |   1 +
 fs/nfs/pnfs.c                                    | 150 +++++++++++++++++++++----
 fs/nfs/pnfs.h                                    |   7 +-
 fs/notify/inotify/inotify_user.c                 |   4 -
 fs/ocfs2/dlmglue.c                               |   5 +-
 include/linux/console.h                          |   2 +
 include/linux/if_vlan.h                          |   6 +-
 include/linux/pps_kernel.h                       |  17 ++-
 include/linux/vt_kern.h                          |   3 +
 include/net/dst.h                                |   8 +-
 include/net/icmp.h                               |   1 +
 include/net/inet6_hashtables.h                   |   8 +-
 include/net/inet_sock.h                          |   1 +
 include/net/ip6_fib.h                            |  39 ++-----
 include/net/ipv6.h                               |  12 ++
 include/net/sock.h                               |   2 +-
 include/uapi/linux/serial_core.h                 |   2 +-
 include/uapi/linux/usb/audio.h                   |   6 +-
 kernel/futex.c                                   |   2 -
 kernel/futex_compat.c                            |   2 -
 kernel/hrtimer.c                                 |  36 +++---
 kernel/irq/spurious.c                            |   7 +-
 kernel/posix-cpu-timers.c                        |  23 +++-
 kernel/timeconst.pl                              |   6 +-
 kernel/workqueue.c                               |   2 +-
 mm/fadvise.c                                     |  18 ++-
 mm/mmu_notifier.c                                |  82 +++++++-------
 mm/shmem.c                                       |  10 +-
 net/core/dst.c                                   |   1 +
 net/core/sock_diag.c                             |   3 +
 net/ipv4/af_inet.c                               |  11 +-
 net/ipv4/icmp.c                                  |  23 ++++
 net/ipv4/ping.c                                  |   4 +-
 net/ipv4/tcp_output.c                            |  18 +--
 net/ipv6/route.c                                 |   8 +-
 net/ipv6/xfrm6_policy.c                          |   2 +
 net/mac80211/mlme.c                              |   4 +-
 security/keys/process_keys.c                     |   2 +
 sound/drivers/aloop.c                            |   5 +-
 sound/pci/ali5451/ali5451.c                      |   2 +-
 sound/pci/hda/hda_codec.c                        |  43 ++++---
 sound/pci/hda/hda_codec.h                        |   3 +-
 sound/pci/hda/hda_intel.c                        |   2 +-
 sound/pci/hda/patch_hdmi.c                       |  18 ++-
 sound/pci/hda/patch_realtek.c                    |   1 +
 sound/pci/rme32.c                                |   2 +-
 sound/soc/codecs/arizona.c                       |  11 +-
 sound/soc/codecs/wm2200.c                        |   4 +-
 sound/usb/quirks-table.h                         |   2 +-
 sound/usb/quirks.c                               |   2 +-
 tools/perf/Makefile                              |   4 +-
 tools/perf/ui/hist.c                             |   6 +-
 tools/perf/util/parse-events.y                   |   1 -
 tools/perf/util/pmu.y                            |   1 -
 187 files changed, 1605 insertions(+), 970 deletions(-)


