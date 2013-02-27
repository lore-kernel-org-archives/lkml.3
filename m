Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab3B0AIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:08:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab3B0AIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:08:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/86] 3.4.34-stable review
Date: Tue, 26 Feb 2013 16:07:08 -0800
Message-Id: <20130226235912.881663118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.34 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 28 23:58:09 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.34-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.34-rc1

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

Roger Quadros <rogerq@ti.com>
    USB: ehci-omap: Don't free gpios that we didn't request

Cong Wang <amwang@redhat.com>
    vlan: adjust vlan_set_encap_proto() for its callers

Mathias Krause <minipli@googlemail.com>
    sock_diag: Fix out-of-bounds access to sock_diag_handlers[]

Eric Dumazet <edumazet@google.com>
    ipv6: use a stronger hash for tcp

Li Wei <lw@cn.fujitsu.com>
    ipv4: fix a bug in ping_err().

Ying Xue <ying.xue@windriver.com>
    net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

David Vrabel <david.vrabel@citrix.com>
    xen-netback: cancel the credit timer when taking the vif down

David Vrabel <david.vrabel@citrix.com>
    xen-netback: correctly return errors from netbk_count_requests()

Eric Dumazet <edumazet@google.com>
    net: fix infinite loop in __skb_recv_datagram()

Stephen Hemminger <stephen@networkplumber.org>
    bridge: set priority of STP packets

David Herrmann <dh.herrmann@gmail.com>
    HID: wiimote: fix nunchuck button parser

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci-esdhc-imx: fix host version read

Takashi Iwai <tiwai@suse.de>
    fb: Yet another band-aid for fixing lockdep mess

Alan Cox <alan@linux.intel.com>
    fb: rework locking to fix lock ordering on takeover

Dave Airlie <airlied@redhat.com>
    fbcon: don't lose the console font across generic->chip driver switch

Anatolij Gustschin <agust@denx.de>
    drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp

Jean Delvare <khali@linux-fr.org>
    pcmcia/vrc4171: Add missing spinlock init

John David Anglin <dave.anglin@bell.net>
    Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Phileas Fogg <phileas-fogg@mail.ru>
    powerpc/kexec: Disable hard IRQ before kexec

Joonsoo Kim <js1304@gmail.com>
    ARM: 7643/1: sched: correct update_sched_clock()

Arnd Bergmann <arnd@arndb.de>
    ARM: samsung: fix assembly syntax for new gas

Igor Grinberg <grinberg@compulab.co.il>
    ARM: PXA3xx: program the CSMSADRCFG register

Chris Rattray <crattray@opensource.wolfsonmicro.com>
    ASoC: wm2200: correct IN2L and IN3L digital mute

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix URB submitted while active warning.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/i915: Set i9xx sdvo clock limits according to specifications

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    drm/i915: disable shared panel fitter for pipe

Daniel Vetter <daniel.vetter@ffwll.ch>
    intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix divide by zero bug in fabric_max_sectors for unconfigured devices

Dave Airlie <airlied@redhat.com>
    drm/usb: bind driver to correct device

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm: Use C8 instead of RGB332 when determining the format from depth/bpp

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm: Fill depth/bits_per_pixel for C8 format

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm: don't add inferred modes for monitors that don't support them

Dave Airlie <airlied@redhat.com>
    vgacon/vt: clear buffer attributes when we load a 512 character font (v2)

Dave Airlie <airlied@redhat.com>
    drm/udl: disable fb_defio by default

Dave Airlie <airlied@redhat.com>
    drm/udl: make usage as a console safer

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce6: fix display powergating

David S. Miller <davem@davemloft.net>
    sunvdc: Fix off-by-one in generic_request().

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - hdmi: ELD shouldn't be valid after unplug

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB with ALC889

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()

Pawel Moll <mail@pawelmoll.com>
    ALSA: usb: Fix Processing Unit Descriptor parsers

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix Roland A-PRO support

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: corrected USB ID for T-Com Sinus 154 data II

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

Andrea Arcangeli <aarcange@redhat.com>
    mm: mmu_notifier: make the mmu_notifier srcu static

Sagi Grimberg <sagig@mellanox.co.il>
    mm: mmu_notifier: have mmu_notifiers use a global SRCU so they may safely schedule

Bjorn Helgaas <bhelgaas@google.com>
    Driver core: treat unregistered bus_types as having no devices

Wei Liu <wei.liu2@citrix.com>
    xen: close evtchn port if binding to irq fails

Stefan Bader <stefan.bader@canonical.com>
    xen: Send spinlock IPI to all waiters

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    rtlwifi: usb: allocate URB control message setup_packet and data buffer separately

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new USB ID

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Increase number of RX DMA slots

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix null-pointer dereferences on disconnect

Oleg Nesterov <oleg@redhat.com>
    tty: set_termios/set_termiox should not return -EINTR

Dirkjan Bussink <d.bussink@gmail.com>
    tty: Prevent deadlock in n_gsm driver

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: rme32.c irq enabling after spin_lock_irq

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: ali5451: remove irq enabling in pointer callback

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

Linus Torvalds <torvalds@linux-foundation.org>
    mm: fix pageblock bitmap allocation

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, mm: Remove reference to alloc_remap()

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, mm: Remove reference to resume_map_numa_kva()

Dave Hansen <dave@linux.vnet.ibm.com>
    x86-32, mm: Rip out x86_32 NUMA remapping code


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm/kernel/sched_clock.c                    |   4 +-
 arch/arm/mach-pxa/include/mach/smemc.h           |   1 +
 arch/arm/mach-pxa/smemc.c                        |  15 ++-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S |  12 +-
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S |   4 +-
 arch/arm/mach-s3c24xx/pm-h1940.S                 |   2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S            |  12 +-
 arch/arm/mach-s3c24xx/sleep-s3c2412.S            |  12 +-
 arch/arm/plat-samsung/include/plat/debug-macro.S |  18 +--
 arch/parisc/include/asm/pgtable.h                |  13 +-
 arch/parisc/kernel/cache.c                       |  18 +++
 arch/powerpc/kernel/machine_kexec_64.c           |   5 +
 arch/s390/kvm/kvm-s390.c                         |   8 ++
 arch/x86/Kconfig                                 |   4 -
 arch/x86/include/asm/mmzone_32.h                 |   6 -
 arch/x86/kernel/cpu/mshyperv.c                   |   3 +-
 arch/x86/mm/numa.c                               |  32 ++---
 arch/x86/mm/numa_32.c                            | 161 -----------------------
 arch/x86/mm/numa_internal.h                      |   6 -
 arch/x86/power/hibernate_32.c                    |   2 -
 arch/x86/xen/spinlock.c                          |   1 -
 drivers/base/bus.c                               |   4 +-
 drivers/base/dd.c                                |   2 +
 drivers/block/sunvdc.c                           |   2 +-
 drivers/dca/dca-core.c                           |   5 +
 drivers/gpu/drm/drm_crtc.c                       |   3 +-
 drivers/gpu/drm/drm_edid.c                       |   3 +-
 drivers/gpu/drm/drm_usb.c                        |   2 +-
 drivers/gpu/drm/i915/intel_display.c             |  12 +-
 drivers/gpu/drm/radeon/atombios_crtc.c           |   6 +-
 drivers/gpu/drm/udl/udl_drv.h                    |   2 +
 drivers/gpu/drm/udl/udl_fb.c                     |  48 ++++++-
 drivers/hid/hid-wiimote-ext.c                    |   8 +-
 drivers/iommu/intel-iommu.c                      |   8 +-
 drivers/mmc/host/sdhci-esdhc-imx.c               |  19 +--
 drivers/net/wireless/b43/dma.h                   |   2 +-
 drivers/net/wireless/p54/p54usb.c                |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |   1 +
 drivers/net/wireless/rtlwifi/usb.c               |  44 ++++---
 drivers/net/xen-netback/interface.c              |   3 +-
 drivers/net/xen-netback/netback.c                |   8 +-
 drivers/pcmcia/vrc4171_card.c                    |   1 +
 drivers/s390/kvm/kvm_virtio.c                    |  38 ++++--
 drivers/staging/comedi/comedi_fops.c             |   5 +
 drivers/staging/vt6656/usbpipe.c                 |  28 ++--
 drivers/target/target_core_device.c              |   8 +-
 drivers/tty/n_gsm.c                              |  42 +++++-
 drivers/tty/tty_ioctl.c                          |   4 +-
 drivers/tty/vt/vt.c                              | 136 +++++++++++++------
 drivers/usb/host/ehci-omap.c                     |  10 +-
 drivers/usb/serial/ftdi_sio.c                    |  20 ++-
 drivers/usb/serial/mct_u232.c                    |  22 ++--
 drivers/usb/serial/option.c                      |  16 ++-
 drivers/usb/serial/sierra.c                      |   8 +-
 drivers/usb/serial/ssu100.c                      |  19 ++-
 drivers/usb/serial/usb-serial.c                  |  14 +-
 drivers/usb/serial/usb_wwan.c                    |   8 +-
 drivers/usb/storage/initializers.c               |   4 +-
 drivers/usb/storage/unusual_cypress.h            |   2 +-
 drivers/video/backlight/adp8860_bl.c             |   2 +-
 drivers/video/backlight/adp8870_bl.c             |   2 +-
 drivers/video/console/fbcon.c                    |  47 ++++++-
 drivers/video/console/vgacon.c                   |  22 +++-
 drivers/video/fbmem.c                            |   9 +-
 drivers/video/fbsysfs.c                          |   3 +
 drivers/video/fsl-diu-fb.c                       |   6 +-
 drivers/xen/evtchn.c                             |  10 ++
 fs/block_dev.c                                   |   1 +
 fs/lockd/clntproc.c                              |   3 +
 fs/nfs/blocklayout/blocklayout.c                 |   1 +
 fs/nfs/objlayout/objio_osd.c                     |   1 +
 fs/notify/inotify/inotify_user.c                 |   4 -
 fs/ocfs2/dlmglue.c                               |   5 +-
 include/linux/console.h                          |   2 +
 include/linux/if_vlan.h                          |   6 +-
 include/linux/mmu_notifier.h                     |   1 +
 include/linux/usb/audio.h                        |   6 +-
 include/linux/vt_kern.h                          |   3 +
 include/net/inet6_hashtables.h                   |   8 +-
 include/net/inet_sock.h                          |   1 +
 include/net/ipv6.h                               |  12 ++
 include/net/sock.h                               |   2 +-
 kernel/futex.c                                   |   2 -
 kernel/futex_compat.c                            |   2 -
 kernel/hrtimer.c                                 |  36 ++---
 kernel/irq/spurious.c                            |   7 +-
 kernel/posix-cpu-timers.c                        |  23 +++-
 kernel/timeconst.pl                              |   6 +-
 mm/fadvise.c                                     |  18 ++-
 mm/mmu_notifier.c                                | 147 ++++++++++++---------
 mm/page_alloc.c                                  |  15 ++-
 mm/shmem.c                                       |  10 +-
 net/bridge/br_stp_bpdu.c                         |   2 +
 net/core/datagram.c                              |   2 +-
 net/core/sock_diag.c                             |   3 +
 net/ipv4/af_inet.c                               |   9 +-
 net/ipv4/ping.c                                  |   4 +-
 sound/pci/ali5451/ali5451.c                      |   2 +-
 sound/pci/hda/patch_hdmi.c                       |   7 +-
 sound/pci/hda/patch_realtek.c                    |   1 +
 sound/pci/rme32.c                                |   2 +-
 sound/soc/codecs/wm2200.c                        |   4 +-
 sound/usb/quirks-table.h                         |   2 +-
 104 files changed, 807 insertions(+), 566 deletions(-)


