Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3B0Ahp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:37:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3BZX6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/53] 3.0.67-stable review
Date: Tue, 26 Feb 2013 15:57:29 -0800
Message-Id: <20130226235619.844721947@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.67 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 28 23:55:32 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.67-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.67-rc1

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

Eric Dumazet <edumazet@google.com>
    ipv6: use a stronger hash for tcp

Li Wei <lw@cn.fujitsu.com>
    ipv4: fix a bug in ping_err().

David Vrabel <david.vrabel@citrix.com>
    xen-netback: cancel the credit timer when taking the vif down

David Vrabel <david.vrabel@citrix.com>
    xen-netback: correctly return errors from netbk_count_requests()

Stephen Hemminger <stephen@networkplumber.org>
    bridge: set priority of STP packets

Takashi Iwai <tiwai@suse.de>
    fb: Yet another band-aid for fixing lockdep mess

Alan Cox <alan@linux.intel.com>
    fb: rework locking to fix lock ordering on takeover

Dave Airlie <airlied@redhat.com>
    fbcon: don't lose the console font across generic->chip driver switch

Jean Delvare <khali@linux-fr.org>
    pcmcia/vrc4171: Add missing spinlock init

John David Anglin <dave.anglin@bell.net>
    Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Phileas Fogg <phileas-fogg@mail.ru>
    powerpc/kexec: Disable hard IRQ before kexec

Igor Grinberg <grinberg@compulab.co.il>
    ARM: PXA3xx: program the CSMSADRCFG register

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix URB submitted while active warning.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    drm/i915: disable shared panel fitter for pipe

Alan Stern <stern@rowland.harvard.edu>
    NLS: improve UTF8 -> UTF16 string conversion routine

Dave Airlie <airlied@redhat.com>
    drm/usb: bind driver to correct device

David S. Miller <davem@davemloft.net>
    sunvdc: Fix off-by-one in generic_request().

Dan Carpenter <error27@gmail.com>
    ext4: add missing kfree() on error return path in add_new_gdb()

Tao Ma <boyu.mt@taobao.com>
    ext4: Free resources in some error path in ext4_fill_super

Pawel Moll <mail@pawelmoll.com>
    ALSA: usb: Fix Processing Unit Descriptor parsers

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix Roland A-PRO support

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust <Trond.Myklebust@netapp.com>
    NLM: Ensure that we resend all pending blocking locks after a reclaim

Mel Gorman <mgorman@suse.de>
    mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages

Greg Thelen <gthelen@google.com>
    tmpfs: fix use-after-free of mempolicy object

Lars-Peter Clausen <lars@metafoo.de>
    drivers/video/backlight/adp88?0_bl.c: fix resume

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: unlock super lock if lockres refresh failed

Jim Somerville <Jim.Somerville@windriver.com>
    inotify: remove broken mask checks causing unmount to be EINVAL

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

Stefan Bader <stefan.bader@canonical.com>
    xen: Send spinlock IPI to all waiters

Ian Campbell <ian.campbell@citrix.com>
    xen/netback: check correct frag when looking for head frag

Oleg Nesterov <oleg@redhat.com>
    tty: set_termios/set_termiox should not return -EINTR

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: rme32.c irq enabling after spin_lock_irq

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: ali5451: remove irq enabling in pointer callback

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
    x86-32, mm: Remove reference to resume_map_numa_kva()


-------------

Diffstat:

 Makefile                               |   4 +-
 arch/arm/mach-pxa/include/mach/smemc.h |   1 +
 arch/arm/mach-pxa/smemc.c              |  15 +++-
 arch/parisc/include/asm/pgtable.h      |  13 +++-
 arch/parisc/kernel/cache.c             |  18 +++++
 arch/powerpc/kernel/machine_kexec_64.c |   5 ++
 arch/s390/kvm/kvm-s390.c               |   8 ++
 arch/x86/include/asm/mmzone_32.h       |   6 --
 arch/x86/power/hibernate_32.c          |   2 -
 arch/x86/xen/spinlock.c                |   1 -
 drivers/base/bus.c                     |   4 +-
 drivers/block/sunvdc.c                 |   2 +-
 drivers/dca/dca-core.c                 |   5 ++
 drivers/gpu/drm/drm_usb.c              |   2 +-
 drivers/gpu/drm/i915/intel_display.c   |   8 ++
 drivers/net/wireless/p54/p54usb.c      |   2 +-
 drivers/net/xen-netback/interface.c    |   3 +-
 drivers/net/xen-netback/netback.c      |  10 +--
 drivers/pcmcia/vrc4171_card.c          |   1 +
 drivers/s390/kvm/kvm_virtio.c          |  38 ++++++++--
 drivers/staging/comedi/comedi_fops.c   |   5 ++
 drivers/staging/hv/hv_kvp.c            |  10 ++-
 drivers/staging/vt6656/usbpipe.c       |  28 +++++--
 drivers/tty/tty_ioctl.c                |   4 +-
 drivers/tty/vt/vt.c                    | 134 +++++++++++++++++++++++---------
 drivers/usb/host/ehci-omap.c           |   2 +-
 drivers/usb/serial/option.c            |  16 +++-
 drivers/usb/storage/initializers.c     |   4 +-
 drivers/usb/storage/unusual_cypress.h  |   2 +-
 drivers/video/backlight/adp8860_bl.c   |   2 +-
 drivers/video/backlight/adp8870_bl.c   |   2 +-
 drivers/video/console/fbcon.c          |  47 ++++++++++--
 drivers/video/fbmem.c                  |   9 ++-
 drivers/video/fbsysfs.c                |   3 +
 fs/ext4/resize.c                       |   1 +
 fs/ext4/super.c                        |  19 +++--
 fs/fat/namei_vfat.c                    |   3 +-
 fs/lockd/clntproc.c                    |   3 +
 fs/nls/nls_base.c                      |  43 ++++++++---
 fs/notify/inotify/inotify_user.c       |   4 -
 fs/ocfs2/dlmglue.c                     |   5 +-
 include/linux/console.h                |   2 +
 include/linux/mmu_notifier.h           |   1 +
 include/linux/nls.h                    |   5 +-
 include/linux/usb/audio.h              |   6 +-
 include/linux/vt_kern.h                |   2 +
 include/net/inet6_hashtables.h         |   8 +-
 include/net/inet_sock.h                |   1 +
 include/net/ipv6.h                     |  12 +++
 kernel/hrtimer.c                       |  36 ++++-----
 kernel/irq/spurious.c                  |   7 +-
 kernel/posix-cpu-timers.c              |  23 +++++-
 kernel/timeconst.pl                    |   6 +-
 mm/fadvise.c                           |  18 ++++-
 mm/mmu_notifier.c                      | 147 +++++++++++++++++++++---------------
 mm/page_alloc.c                        |  15 ++--
 mm/shmem.c                             |  10 ++-
 net/bridge/br_stp_bpdu.c               |   2 +
 net/ipv4/af_inet.c                     |   9 ++-
 net/ipv4/ping.c                        |   4 +-
 sound/pci/ali5451/ali5451.c            |   2 +-
 sound/pci/rme32.c                      |   2 +-
 sound/usb/quirks-table.h               |   2 +-
 63 files changed, 573 insertions(+), 241 deletions(-)


