Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaBDVAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:00:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbaBDVAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/37] 3.4.79-stable review
Date: Tue,  4 Feb 2014 13:00:36 -0800
Message-Id: <20140204210055.992134150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.79 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb  6 21:00:31 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.79-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.79-rc1

Paul Mackerras <paulus@samba.org>
    powerpc: Make sure "cache" directory is removed when offlining cpu

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Andy Grover <agrover@redhat.com>
    target/iscsi: Fix network portal creation race

Vijaya Mohan Guvva <vmohan@brocade.com>
    SCSI: bfa: Chinook quad port 16G FC HBA claim issue

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: core: get config and string descriptors for unauthorized devices

Andy Honig <ahonig@google.com>
    KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)

Richard Weinberger <richard@nod.at>
    net,via-rhine: Fix tx_timeout handling

Hannes Frederic Sowa <hannes@stressinduktion.org>
    net: avoid reference counter overflows on fib_rules in multicast forwarding

Neal Cardwell <ncardwell@google.com>
    inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

Michal Schmidt <mschmidt@redhat.com>
    bnx2x: fix DMA unmapping of TSO split BDs

Takashi Iwai <tiwai@suse.de>
    hp_accel: Add a new PnP ID HPQ6007 for new HP laptops

Takashi Iwai <tiwai@suse.de>
    ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks

Takashi Iwai <tiwai@suse.de>
    ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Borislav Petkov <bp@alien8.de>
    rtc-cmos: Add an alarm disable quirk

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    parport: parport_pc: remove double PCI ID for NetMos

Yegor Yefremov <yegorslists@googlemail.com>
    serial: add support for 200 v3 series Titan card

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    ARM: at91: smc: bug fix in sam9_smc_cs_read()

Marek Roszko <mark.roszko@gmail.com>
    tty/serial: at91: Handle shutdown more safely

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Set device type to wlan

ZHAO Gang <gamerh2o@gmail.com>
    b43: fix the wrong assignment of status.freq in b43_rx()

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix unload oops if firmware is not available

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix unload oops if firmware is not available

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix lockdep splat

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix some code in RF handling

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Set the link state

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new device ID

Jack Pham <jackp@codeaurora.org>
    usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Mikhail Zolotaryov <lebon@lebon.org.ua>
    USB: Nokia 502 is an unusual device

Johan Hovold <jhovold@gmail.com>
    USB: cypress_m8: fix ring-indicator detection and reporting

Rahul Bedarkar <rahulbedarkar89@gmail.com>
    USB: serial: add support for iBall 3.5G connect usb modem

张君 <zjn77777@163.com>
    usb: option: add new zte 3g modem pids to option driver

PaX Team <pageexec@freemail.hu>
    x86, x32: Correct invalid use of user timespec in the kernel

Aristeu Rozanski <aris@redhat.com>
    e752x_edac: Fix pci_dev usage count

Andrea Arcangeli <aarcange@redhat.com>
    mm: hugetlbfs: fix hugetlbfs optimization

NeilBrown <neilb@suse.de>
    md/raid5: fix long-standing problem with bitmap handling on write failure.


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/mach-at91/sam9_smc.c                   |   2 +-
 arch/powerpc/kernel/cacheinfo.c                 |   3 +
 arch/x86/kvm/lapic.c                            |   3 +-
 drivers/edac/e752x_edac.c                       |   4 +-
 drivers/md/raid5.c                              |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |  13 ++-
 drivers/net/ethernet/via/via-rhine.c            |   1 +
 drivers/net/wireless/b43/b43.h                  |   4 +-
 drivers/net/wireless/b43/main.c                 |  27 +++---
 drivers/net/wireless/b43/xmit.c                 |   4 +-
 drivers/net/wireless/b43legacy/main.c           |   1 +
 drivers/net/wireless/rtlwifi/core.c             |   1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c     |  29 ++++---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c     |   1 +
 drivers/parport/parport_pc.c                    |  10 +--
 drivers/platform/x86/hp_accel.c                 |   1 +
 drivers/rtc/rtc-cmos.c                          |  52 +++++++++++-
 drivers/scsi/bfa/bfad.c                         |   6 +-
 drivers/staging/rtl8712/usb_intf.c              |   5 ++
 drivers/staging/vt6656/baseband.c               |   3 -
 drivers/target/iscsi/iscsi_target.c             |  34 +++++---
 drivers/tty/serial/8250/8250_pci.c              |   4 +
 drivers/tty/serial/atmel_serial.c               |  20 +++--
 drivers/usb/core/config.c                       |   7 --
 drivers/usb/core/hub.c                          |  40 ++-------
 drivers/usb/host/xhci.c                         |   3 +
 drivers/usb/serial/cypress_m8.h                 |   2 +-
 drivers/usb/serial/option.c                     |  15 ++++
 drivers/usb/storage/unusual_devs.h              |   7 ++
 fs/btrfs/extent-tree.c                          |   2 +-
 include/linux/hugetlb.h                         |   6 ++
 mm/hugetlb.c                                    |  17 ++++
 mm/swap.c                                       | 107 +++++++++++++++++-------
 net/compat.c                                    |   9 +-
 net/ipv4/inet_diag.c                            |   4 +-
 net/ipv4/ipmr.c                                 |   7 +-
 net/ipv6/ip6mr.c                                |   7 +-
 sound/pci/Kconfig                               |  12 +++
 sound/pci/rme9652/rme9652.c                     |   2 +-
 sound/soc/codecs/adau1701.c                     |   2 +-
 41 files changed, 326 insertions(+), 156 deletions(-)


