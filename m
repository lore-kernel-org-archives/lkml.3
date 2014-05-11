Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaEKTUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:20:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbaEKTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:20:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/83] 3.14.4-stable review
Date: Sun, 11 May 2014 21:19:01 +0200
Message-Id: <20140511191907.024339448@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.4 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May 13 19:18:44 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.4-rc1

George Spelvin <linux@horizon.com>
    x86-64, build: Fix stack protector Makefile breakage with 32-bit userland

Gerd Hoffmann <kraxel@redhat.com>
    drm: bochs: add power management support

Gerd Hoffmann <kraxel@redhat.com>
    drm: cirrus: add power management support

Chen Gang <gang.chen.5i5j@gmail.com>
    cpufreq: unicore32: fix typo issue for 'clk'

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / processor: Fix failure of loading acpi-cpufreq driver

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: at32ap: don't declare local variable as static

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: loongson2_cpufreq: don't declare local variable as static

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for ThinkPad Edge E431

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1

Takashi Iwai <tiwai@suse.de>
    thinkpad_acpi: Fix inconsistent mute LED after resume

Russell King <rmk+kernel@arm.linux.org.uk>
    mmc: sdhci-bcm-kona: fix build errors when built-in

Jens Axboe <axboe@fb.com>
    lib/percpu_counter.c: fix bad percpu counter state during suspend

Jeff Layton <jlayton@redhat.com>
    lockd: ensure we tear down any live sockets when socket creation fails during lockd_up

Benjamin LaHaise <bcrl@kvack.org>
    aio: v4 ensure access to ctx->ring_pages is correctly serialised for migration

Sekhar Nori <nsekhar@ti.com>
    dma: edma: fix incorrect SG list handling

Joe Thornber <ejt@redhat.com>
    dm cache: fix a lock-inversion

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix dangling bio in process_deferred_bios error path

Joe Thornber <ejt@redhat.com>
    dm: take care to copy the space map roots before locking the superblock

Joe Thornber <ejt@redhat.com>
    dm transaction manager: fix corruption due to non-atomic transaction commit

Mike Snitzer <snitzer@redhat.com>
    dm cache: prevent corruption caused by discard_block_size > cache_block_size

Giacomo Comes <comes@naic.edu>
    Skip intel_crt_init for Dell XPS 8700

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()

Sasha Levin <sasha.levin@oracle.com>
    mtd: diskonchip: mem resource name is not optional

Herve Codina <Herve.CODINA@celad.com>
    mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Mikulas Patocka <mpatocka@redhat.com>
    tgafb: fix data copying

Mikulas Patocka <mpatocka@redhat.com>
    tgafb: fix mode setting with fbset

Andrew Bresticker <abrestic@chromium.org>
    pinctrl: as3722: fix handling of GPIO invert bit

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
    ath9k: fix ready time of the multicast buffer queue

Felix Fietkau <nbd@openwrt.org>
    mac80211: exclude AP_VLAN interfaces from tx power calculation

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix software remain-on-channel implementation

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix suspend vs. authentication race

Michael Braun <michael-dev@fami-braun.de>
    mac80211: fix WPA with VLAN on AP side with ps-sta again

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix potential use-after-free

Ilya Dryomov <ilya.dryomov@inktank.com>
    crush: fix off-by-one errors in total_tries refactor

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: disable uAPSD due to bugs in the firmware

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: take mutex when sending SYNC BT config command

Martin K. Petersen <martin.petersen@oracle.com>
    libata: Update queued trim blacklist for M5x0 drives

Alexander Gordeev <agordeev@redhat.com>
    ahci: Do not receive interrupts sent by dummy ports

Alexander Gordeev <agordeev@redhat.com>
    ahci: Ensure "MSI Revert to Single Message" mode is not enforced

Dan Williams <dan.j.williams@intel.com>
    libata/ahci: accommodate tag ordered controllers

David Milburn <dmilburn@redhat.com>
    ahci: do not request irq for dummy port

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Revert "net: mvneta: fix usage as a module on RGMII configurations"

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

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe

Steve Dickson <steved@redhat.com>
    SUNRPC: Ensure call_connect_status() deals correctly with SOFTCONN tasks

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Ensure that call_connect times out correctly

Richard Weinberger <richard@nod.at>
    ARC: Remove ARC_HAS_COH_RTSC

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Sebastian Ott <sebott@linux.vnet.ibm.com>
    s390/chsc: fix SEI usage on old FW levels

Li Zhong <zhong@linux.vnet.ibm.com>
    powerpc: Fix Oops in rtas_stop_self()

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Disable IRQ in tm_recheckpoint

Anton Blanchard <anton@samba.org>
    powerpc/compat: 32-bit little endian machine name is ppcle, not ppc

Tyler Stachecki <tstache1@binghamton.edu>
    mpt2sas: Don't disable device twice at suspend.

Fam Zheng <famz@redhat.com>
    virtio-scsi: Skip setting affinity on uninitialized vq

Joel Stanley <joel@jms.id.au>
    tools/virtio: add a missing )

Rusty Russell <rusty@rustcorp.com.au>
    virtio_balloon: don't softlockup on huge balloon changes.

Huacai Chen <chenhc@lemote.com>
    MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Anton Blanchard <anton@samba.org>
    KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n

James Hogan <james.hogan@imgtec.com>
    MIPS: KVM: Pass reserved instruction exceptions to guest

Paolo Bonzini <pbonzini@redhat.com>
    KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)

Oleg Nesterov <oleg@redhat.com>
    KVM: async_pf: mm->mm_users can not pin apf->mm

Mark Salter <msalter@redhat.com>
    arm: KVM: fix possible misalignment of PGDs and bounce page

Haibin Wang <wanghaibin.wang@huawei.com>
    KVM: ARM: vgic: Fix sgi dispatch problem

Matthew Daley <mattd@bugfuzz.com>
    floppy: don't write kernel-only members to FDRAWCMD ioctl output

Matthew Daley <mattd@bugfuzz.com>
    floppy: ignore kernel-only members in FDRAWCMD ioctl input

Peter Hurley <peter@hurleysoftware.com>
    n_tty: Fix n_tty_write crash when echoing in raw mode

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix lockless tty buffer race

Michael Welling <mwelling@ieee.org>
    tty: serial: 8250_core.c Bug fix for Exar chips.

Tomoki Sekiyama <tomoki.sekiyama@hds.com>
    drivers/tty/hvc: don't free hvc_console_setup after init


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/entry.S                            |   8 +-
 arch/arc/plat-arcfpga/Kconfig                      |   1 -
 arch/arm/kvm/mmu.c                                 |  15 +-
 arch/mips/kvm/kvm_mips_emul.c                      |   7 +-
 arch/mips/power/hibernate.S                        |   1 +
 arch/powerpc/include/asm/compat.h                  |   4 +
 arch/powerpc/include/asm/reg.h                     |   1 +
 arch/powerpc/kernel/process.c                      |  34 ++-
 arch/powerpc/kernel/signal_32.c                    |   2 +
 arch/powerpc/kernel/signal_64.c                    |   2 +
 arch/powerpc/kernel/tm.S                           |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   5 +-
 arch/s390/net/bpf_jit_comp.c                       |   1 -
 arch/x86/Makefile                                  |   1 +
 drivers/acpi/acpi_processor.c                      |   7 +-
 drivers/ata/ahci.c                                 |  27 +-
 drivers/ata/ahci.h                                 |   1 +
 drivers/ata/libata-core.c                          |  27 +-
 drivers/block/floppy.c                             |  11 +-
 drivers/cpufreq/at32ap-cpufreq.c                   |   2 +-
 drivers/cpufreq/loongson2_cpufreq.c                |   2 +-
 drivers/cpufreq/unicore2-cpufreq.c                 |   2 +-
 drivers/dma/edma.c                                 |   6 +-
 drivers/gpio/gpio-mxs.c                            |   3 +-
 drivers/gpu/drm/bochs/bochs.h                      |   1 +
 drivers/gpu/drm/bochs/bochs_drv.c                  |  44 ++++
 drivers/gpu/drm/cirrus/cirrus_drv.c                |  42 +++
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   3 +
 drivers/gpu/drm/i915/intel_crt.c                   |   8 +
 drivers/input/mouse/synaptics.c                    |  50 ++++
 drivers/md/dm-cache-metadata.c                     |  98 ++++---
 drivers/md/dm-cache-metadata.h                     |   9 +-
 drivers/md/dm-cache-target.c                       |  65 +----
 drivers/md/dm-thin-metadata.c                      |  80 +++---
 drivers/md/dm-thin.c                               |   2 +-
 drivers/md/persistent-data/dm-block-manager.c      |  15 +-
 drivers/md/persistent-data/dm-block-manager.h      |   3 +-
 .../md/persistent-data/dm-transaction-manager.c    |   5 +-
 .../md/persistent-data/dm-transaction-manager.h    |  17 +-
 drivers/mmc/host/sdhci-bcm-kona.c                  |   2 +-
 drivers/mtd/nand/atmel_nand.c                      |   1 +
 drivers/mtd/nand/diskonchip.c                      |   2 +-
 drivers/mtd/nand/nuc900_nand.c                     |   2 +-
 drivers/mtd/sm_ftl.c                               |  11 +-
 drivers/net/ethernet/marvell/mvneta.c              |  41 ++-
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/b43/phy_n.c                   |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |  20 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |  27 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   6 +
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |  18 +-
 drivers/pinctrl/pinctrl-as3722.c                   |  17 +-
 drivers/platform/x86/thinkpad_acpi.c               |  12 +
 drivers/s390/cio/chsc.c                            |  22 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |   1 -
 drivers/scsi/virtio_scsi.c                         |   6 +-
 drivers/tty/hvc/hvc_console.c                      |   2 +-
 drivers/tty/n_tty.c                                |   4 +
 drivers/tty/serial/8250/8250_core.c                |   2 +-
 drivers/tty/tty_buffer.c                           |  17 +-
 drivers/video/aty/mach64_accel.c                   |   3 +-
 drivers/video/aty/mach64_cursor.c                  |  22 +-
 drivers/video/cfbcopyarea.c                        | 153 +++++------
 drivers/video/matrox/matroxfb_accel.c              |  38 ++-
 drivers/video/matrox/matroxfb_base.h               |   2 +
 drivers/video/tgafb.c                              | 282 +++++----------------
 drivers/virtio/virtio_balloon.c                    |   6 +
 fs/aio.c                                           | 120 +++++----
 fs/lockd/svc.c                                     |   1 +
 fs/locks.c                                         |   7 +-
 include/linux/libata.h                             |   1 +
 lib/percpu_counter.c                               |   2 +-
 net/ceph/crush/mapper.c                            |  46 ++--
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/main.c                                |   2 +
 net/mac80211/mlme.c                                |  28 +-
 net/mac80211/offchannel.c                          |   1 +
 net/mac80211/pm.c                                  |  14 +-
 net/mac80211/tx.c                                  |   2 +-
 net/sunrpc/clnt.c                                  |  12 +-
 sound/soc/soc-dapm.c                               |   1 -
 tools/virtio/virtio_test.c                         |   2 +-
 virt/kvm/arm/vgic.c                                |   1 +
 virt/kvm/async_pf.c                                |   8 +-
 virt/kvm/ioapic.c                                  |   2 +-
 91 files changed, 938 insertions(+), 697 deletions(-)


