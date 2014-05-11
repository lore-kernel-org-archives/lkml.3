Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaEKTVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:21:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbaEKTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/48] 3.10.40-stable review
Date: Sun, 11 May 2014 21:19:34 +0200
Message-Id: <20140511191948.079900414@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.40 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May 13 19:19:30 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.40-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.40-rc1

Gerd Hoffmann <kraxel@redhat.com>
    drm: cirrus: add power management support

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for ThinkPad Edge E431

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1

Jeff Layton <jlayton@redhat.com>
    lockd: ensure we tear down any live sockets when socket creation fails during lockd_up

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix dangling bio in process_deferred_bios error path

Joe Thornber <ejt@redhat.com>
    dm transaction manager: fix corruption due to non-atomic transaction commit

Giacomo Comes <comes@naic.edu>
    Skip intel_crt_init for Dell XPS 8700

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()

Herve Codina <Herve.CODINA@celad.com>
    mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Mikulas Patocka <mpatocka@redhat.com>
    tgafb: fix data copying

Marek Vasut <marex@denx.de>
    gpio: mxs: Allow for recursive enable_irq_wake() call

Colin Ian King <colin.king@canonical.com>
    rtlwifi: rtl8188ee: initialize packet_beacon

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192se: Fix too long disable of IRQs

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix too long disable of IRQs

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8188ee: Fix too long disable of IRQs

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8723ae: Fix too long disable of IRQs

Jeff Layton <jlayton@redhat.com>
    locks: allow __break_lease to sleep even when break_time is 0

Felix Fietkau <nbd@openwrt.org>
    mac80211: exclude AP_VLAN interfaces from tx power calculation

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix software remain-on-channel implementation

Michael Braun <michael-dev@fami-braun.de>
    mac80211: fix WPA with VLAN on AP side with ps-sta again

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: take mutex when sending SYNC BT config command

Dan Williams <dan.j.williams@intel.com>
    libata/ahci: accommodate tag ordered controllers

Rafał Miłecki <zajec5@gmail.com>
    b43: Fix machine check error due to improper access of B43_MMIO_PSM_PHY_HDR

Mikulas Patocka <mpatocka@redhat.com>
    mach64: fix cursor when character width is not a multiple of 8 pixels

Mikulas Patocka <mpatocka@redhat.com>
    mach64: use unaligned access

Mikulas Patocka <mpatocka@redhat.com>
    matroxfb: restore the registers M_ACCESS and M_PITCH

Mikulas Patocka <mpatocka@redhat.com>
    framebuffer: fix cfb_copyarea

Vineet Gupta <vgupta@synopsys.com>
    ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE

Vineet Gupta <vgupta@synopsys.com>
    ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Sebastian Ott <sebott@linux.vnet.ibm.com>
    s390/chsc: fix SEI usage on old FW levels

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Disable IRQ in tm_recheckpoint

Anton Blanchard <anton@samba.org>
    powerpc/compat: 32-bit little endian machine name is ppcle, not ppc

Tyler Stachecki <tstache1@binghamton.edu>
    mpt2sas: Don't disable device twice at suspend.

Fam Zheng <famz@redhat.com>
    virtio-scsi: Skip setting affinity on uninitialized vq

Rusty Russell <rusty@rustcorp.com.au>
    virtio_balloon: don't softlockup on huge balloon changes.

Huacai Chen <chenhc@lemote.com>
    MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

James Hogan <james.hogan@imgtec.com>
    MIPS: KVM: Pass reserved instruction exceptions to guest

Paolo Bonzini <pbonzini@redhat.com>
    KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)

Sergey Dyasly <dserrg@gmail.com>
    ARM: 7840/1: LPAE: don't reject mapping /dev/mem above 4GB

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err

Matthew Daley <mattd@bugfuzz.com>
    floppy: don't write kernel-only members to FDRAWCMD ioctl output

Matthew Daley <mattd@bugfuzz.com>
    floppy: ignore kernel-only members in FDRAWCMD ioctl input

Peter Hurley <peter@hurleysoftware.com>
    n_tty: Fix n_tty_write crash when echoing in raw mode

Michael Welling <mwelling@ieee.org>
    tty: serial: 8250_core.c Bug fix for Exar chips.

Tomoki Sekiyama <tomoki.sekiyama@hds.com>
    drivers/tty/hvc: don't free hvc_console_setup after init


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/irqflags.h                    |   7 -
 arch/arc/kernel/entry.S                            |  16 +-
 arch/arm/mm/mmap.c                                 |   6 +-
 arch/mips/kvm/kvm_mips_emul.c                      |   7 +-
 arch/mips/power/hibernate.S                        |   1 +
 arch/powerpc/include/asm/compat.h                  |   4 +
 arch/powerpc/include/asm/reg.h                     |   1 +
 arch/powerpc/kernel/process.c                      |  34 ++-
 arch/powerpc/kernel/signal_32.c                    |   2 +
 arch/powerpc/kernel/signal_64.c                    |   2 +
 arch/powerpc/kernel/tm.S                           |   2 +-
 arch/s390/net/bpf_jit_comp.c                       |   1 -
 drivers/ata/libata-core.c                          |  21 +-
 drivers/block/floppy.c                             |  11 +-
 drivers/gpio/gpio-mxs.c                            |   3 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |  42 ++++
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   3 +
 drivers/gpu/drm/i915/intel_crt.c                   |   8 +
 drivers/infiniband/ulp/isert/ib_isert.c            |  29 ++-
 drivers/input/mouse/synaptics.c                    |  50 ++++
 drivers/md/dm-cache-metadata.c                     |   3 +-
 drivers/md/dm-thin.c                               |   2 +-
 drivers/md/persistent-data/dm-block-manager.c      |  15 +-
 drivers/md/persistent-data/dm-block-manager.h      |   3 +-
 .../md/persistent-data/dm-transaction-manager.c    |   5 +-
 .../md/persistent-data/dm-transaction-manager.h    |  17 +-
 drivers/mtd/nand/atmel_nand.c                      |   1 +
 drivers/mtd/nand/nuc900_nand.c                     |   2 +-
 drivers/mtd/sm_ftl.c                               |  11 +-
 drivers/net/wireless/b43/phy_n.c                   |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   8 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |  20 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |  27 ++-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   6 +
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |  18 +-
 drivers/s390/cio/chsc.c                            |  22 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |   1 -
 drivers/scsi/virtio_scsi.c                         |   6 +-
 drivers/tty/hvc/hvc_console.c                      |   2 +-
 drivers/tty/n_tty.c                                |   4 +
 drivers/tty/serial/8250/8250_core.c                |   2 +-
 drivers/video/aty/mach64_accel.c                   |   3 +-
 drivers/video/aty/mach64_cursor.c                  |  22 +-
 drivers/video/cfbcopyarea.c                        | 153 ++++++------
 drivers/video/matrox/matroxfb_accel.c              |  38 ++-
 drivers/video/matrox/matroxfb_base.h               |   2 +
 drivers/video/tgafb.c                              | 264 ++++-----------------
 drivers/virtio/virtio_balloon.c                    |   6 +
 fs/lockd/svc.c                                     |   1 +
 fs/locks.c                                         |   7 +-
 include/linux/libata.h                             |   1 +
 net/mac80211/main.c                                |   2 +
 net/mac80211/offchannel.c                          |   1 +
 net/mac80211/tx.c                                  |   2 +-
 virt/kvm/ioapic.c                                  |   2 +-
 58 files changed, 529 insertions(+), 435 deletions(-)


