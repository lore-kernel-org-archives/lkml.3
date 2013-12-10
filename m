Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3LJH7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:59:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3LJH7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/52] 3.10.24-stable review
Date: Tue, 10 Dec 2013 00:00:33 -0800
Message-Id: <20131210075954.196229872@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.24 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Dec 12 07:59:40 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.24-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.24-rc1

Arnaud Ebalard <arno@natisbad.org>
    ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable

Arnaud Ebalard <arno@natisbad.org>
    ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260

Alan Cox <alan@linux.intel.com>
    drivers/char/i8k.c: add Dell XPLS L421X

David Cluytens <david.cluytens@gmail.com>
    USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

Colin Leitner <colin.leitner@googlemail.com>
    USB: spcp8x5: correct handling of CS5 setting

Colin Leitner <colin.leitner@googlemail.com>
    USB: mos7840: correct handling of CS5 setting

Colin Leitner <colin.leitner@googlemail.com>
    USB: ftdi_sio: fixed handling of unsupported CSIZE setting

Colin Leitner <colin.leitner@googlemail.com>
    USB: pl2303: fixed handling of CS5 setting

Tomas Winkler <tomas.winkler@intel.com>
    mei: add 9 series PCH mei device ids

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add Lynx Point Wellsburg work station device id

Tom Gundersen <teg@jklm.no>
    Input: mousedev - allow disabling even without CONFIG_EXPERT

Tom Gundersen <teg@jklm.no>
    Input: allow deselecting serio drivers even without CONFIG_EXPERT

Joonyoung Shim <jy0922.shim@samsung.com>
    lib/genalloc.c: fix overflow of ending address of memory chunk

AceLan Kao <acelan.kao@canonical.com>
    HID: usbhid: quirk for SiS Touchscreen

AceLan Kao <acelan.kao@canonical.com>
    HID: usbhid: quirk for Synaptics Large Touchccreen

Ivan Vecera <ivecera@redhat.com>
    tg3: avoid double-freeing of rx data memory

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: don't override mac80211's queue setting

Martin K. Petersen <martin.petersen@oracle.com>
    SCSI: Disable WRITE SAME for RAID and virtual host adapter drivers

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, build: Always pass in -mno-sse

Shawn Landden <shawn@churchofgit.com>
    net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Laxman Dewangan <ldewangan@nvidia.com>
    irq: Enable all irqs unconditionally in irq_resume

Hong Zhiguo <zhiguohong@tencent.com>
    Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.

Matt Wilson <msw@amazon.com>
    xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Helge Deller <deller@gmx.de>
    parisc: fix mmap(MAP_FIXED|MAP_SHARED) to already mmapped address

Liu Gang <Gang.Liu@freescale.com>
    powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Martin Schwidefsky <schwidefsky@de.ibm.com>
    time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Update list of irrecoverable errors on DELEGRETURN

Linus Walleij <linus.walleij@linaro.org>
    net: smc91: fix crash regression on the versatile

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: return 0 from driver probe function on success, not 1

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: do not discard scsi status on aborted commands

Dan Williams <dan.j.williams@intel.com>
    SCSI: libsas: fix usage of ata_tf_to_fis

James Bottomley <JBottomley@Parallels.com>
    SCSI: enclosure: fix WARN_ON in dual path device removing

Vijaya Mohan Guvva <vmohan@brocade.com>
    SCSI: bfa: Fix crash when symb name set for offline vport

Marc Kleine-Budde <mkl@pengutronix.de>
    can: c_can: don't call pm_runtime_get_sync() from interrupt context

Oliver Hartkopp <socketcan@hartkopp.net>
    can: sja1000: fix {pre,post}_irq() handling and IRQ handler return value

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: fix subtle use-after-free of pipe_inode_info

Bo Shen <voice.shen@atmel.com>
    ASoC: wm8731: fix dsp mode configuration

Mark Brown <broonie@linaro.org>
    ASoC: wm8990: Mark the register map as dirty when powering down

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: mvebu: use the virtual CPU registers to access coherency registers

Ludovic Desroches <ludovic.desroches@atmel.com>
    ARM: at91: sama5d3: reduce TWI internal clock frequency

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: footbridge: fix EBSA285 LEDs

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: footbridge: fix VGA initialisation

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix booting low-vectors machines

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: authenc - Find proper IV address in ablkcipher callback

Horia Geanta <horia.geanta@freescale.com>
    crypto: ccm - Fix handling of zero plaintext when computing mac

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: scatterwalk - Set the chain pointer indication bit

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    crypto: s390 - Fix aes-xts parameter corruption

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add mono speaker quirk for Dell Inspiron 5439

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix silent output on MacBook Air 2,1

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix headset mic input after muted internal mic (Dell/Realtek)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Another fixup for ASUS laptop with ALC660 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix silent output on ASUS W7J laptop


-------------

Diffstat:

 Makefile                                  |  4 +-
 arch/arm/boot/dts/armada-370-xp.dtsi      |  2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi  | 16 +++----
 arch/arm/boot/dts/armada-xp-mv78260.dtsi  | 78 +++++++++++++++++++++++++------
 arch/arm/include/asm/pgtable.h            |  2 +-
 arch/arm/mach-at91/sama5d3.c              |  6 +--
 arch/arm/mach-footbridge/common.c         |  3 ++
 arch/arm/mach-footbridge/dc21285.c        |  2 -
 arch/arm/mach-footbridge/ebsa285.c        | 22 +++++----
 arch/arm/mm/mmap.c                        |  2 +-
 arch/arm/mm/pgd.c                         |  3 +-
 arch/parisc/kernel/sys_parisc.c           | 25 ++++++----
 arch/s390/crypto/aes_s390.c               | 31 ++++++------
 arch/x86/Makefile                         |  8 +++-
 block/blk-cgroup.h                        |  8 ++--
 crypto/algif_hash.c                       |  3 ++
 crypto/algif_skcipher.c                   |  3 ++
 crypto/authenc.c                          |  7 +--
 crypto/ccm.c                              |  3 +-
 drivers/ata/libata-scsi.c                 |  1 +
 drivers/char/i8k.c                        |  7 +++
 drivers/firewire/sbp2.c                   |  1 +
 drivers/gpio/gpio-mpc8xxx.c               |  8 +++-
 drivers/hid/hid-ids.h                     |  5 ++
 drivers/hid/usbhid/hid-quirks.c           |  3 ++
 drivers/input/Kconfig                     |  2 +-
 drivers/input/keyboard/Kconfig            |  4 +-
 drivers/input/serio/Kconfig               |  6 +--
 drivers/misc/enclosure.c                  |  7 +++
 drivers/misc/mei/hw-me-regs.h             |  6 ++-
 drivers/misc/mei/pci-me.c                 |  5 +-
 drivers/net/can/c_can/c_can.c             | 21 ++++++---
 drivers/net/can/sja1000/sja1000.c         | 17 +++----
 drivers/net/ethernet/broadcom/tg3.c       | 12 ++---
 drivers/net/ethernet/smsc/smc91x.h        | 22 ++-------
 drivers/net/wireless/iwlwifi/dvm/tx.c     | 14 ++----
 drivers/scsi/3w-9xxx.c                    |  3 +-
 drivers/scsi/3w-sas.c                     |  3 +-
 drivers/scsi/3w-xxxx.c                    |  3 +-
 drivers/scsi/aacraid/linit.c              |  1 +
 drivers/scsi/arcmsr/arcmsr_hba.c          |  1 +
 drivers/scsi/bfa/bfa_fcs.h                |  1 +
 drivers/scsi/bfa/bfa_fcs_lport.c          | 14 ++++--
 drivers/scsi/bfa/bfad_attr.c              |  7 +--
 drivers/scsi/gdth.c                       |  1 +
 drivers/scsi/hosts.c                      |  1 +
 drivers/scsi/hpsa.c                       |  5 +-
 drivers/scsi/ipr.c                        |  3 +-
 drivers/scsi/ips.c                        |  1 +
 drivers/scsi/libsas/sas_ata.c             |  2 +-
 drivers/scsi/megaraid.c                   |  1 +
 drivers/scsi/megaraid/megaraid_mbox.c     |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c |  1 +
 drivers/scsi/pmcraid.c                    |  1 +
 drivers/scsi/sd.c                         |  6 +++
 drivers/scsi/storvsc_drv.c                |  1 +
 drivers/usb/class/cdc-acm.c               |  2 +
 drivers/usb/serial/ftdi_sio.c             | 37 +++++++++------
 drivers/usb/serial/mos7840.c              | 32 ++++++-------
 drivers/usb/serial/pl2303.c               | 32 ++++++-------
 drivers/usb/serial/spcp8x5.c              | 30 ++++++------
 drivers/xen/grant-table.c                 |  6 ++-
 fs/nfs/nfs4proc.c                         | 10 +++-
 fs/pipe.c                                 | 39 ++++++++--------
 include/crypto/scatterwalk.h              |  1 +
 include/linux/genalloc.h                  |  4 +-
 include/scsi/scsi_host.h                  |  6 +++
 kernel/irq/pm.c                           |  2 +-
 kernel/time/timekeeping.c                 |  2 +-
 lib/genalloc.c                            | 19 +++++---
 net/ipv4/udp.c                            |  3 ++
 sound/pci/hda/patch_realtek.c             | 55 ++++++++++++++++++----
 sound/soc/codecs/wm8731.c                 |  4 +-
 sound/soc/codecs/wm8990.c                 |  2 +
 74 files changed, 456 insertions(+), 256 deletions(-)


