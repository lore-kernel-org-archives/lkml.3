Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3LLGtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:49:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3LLGte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:49:34 -0500
Date: Wed, 11 Dec 2013 22:51:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.24
Message-ID: <20131212065120.GA13723@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.24 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 arch/arm/boot/dts/armada-370-xp.dtsi      |    2=20
 arch/arm/boot/dts/armada-xp-mv78230.dtsi  |   16 +++---
 arch/arm/boot/dts/armada-xp-mv78260.dtsi  |   78 ++++++++++++++++++++++++-=
-----
 arch/arm/include/asm/pgtable.h            |    2=20
 arch/arm/mach-at91/sama5d3.c              |    6 +-
 arch/arm/mach-footbridge/common.c         |    3 +
 arch/arm/mach-footbridge/dc21285.c        |    2=20
 arch/arm/mach-footbridge/ebsa285.c        |   22 +++++---
 arch/arm/mm/mmap.c                        |    2=20
 arch/arm/mm/pgd.c                         |    3 -
 arch/parisc/kernel/sys_parisc.c           |   25 +++++----
 arch/s390/crypto/aes_s390.c               |   31 ++++++-----
 arch/x86/Makefile                         |    8 ++-
 block/blk-cgroup.h                        |    8 +--
 crypto/algif_hash.c                       |    3 +
 crypto/algif_skcipher.c                   |    3 +
 crypto/authenc.c                          |    7 +-
 crypto/ccm.c                              |    3 -
 drivers/ata/libata-scsi.c                 |    1=20
 drivers/char/i8k.c                        |    7 ++
 drivers/firewire/sbp2.c                   |    1=20
 drivers/gpio/gpio-mpc8xxx.c               |    8 ++-
 drivers/hid/hid-ids.h                     |    5 +
 drivers/hid/usbhid/hid-quirks.c           |    3 +
 drivers/input/Kconfig                     |    2=20
 drivers/input/keyboard/Kconfig            |    4 -
 drivers/input/serio/Kconfig               |    6 +-
 drivers/misc/enclosure.c                  |    7 ++
 drivers/misc/mei/hw-me-regs.h             |    6 +-
 drivers/misc/mei/pci-me.c                 |    5 +
 drivers/net/can/c_can/c_can.c             |   21 +++++---
 drivers/net/can/sja1000/sja1000.c         |   17 +++---
 drivers/net/ethernet/broadcom/tg3.c       |   12 ++--
 drivers/net/ethernet/smsc/smc91x.h        |   22 +-------
 drivers/net/wireless/iwlwifi/dvm/tx.c     |   14 +----
 drivers/scsi/3w-9xxx.c                    |    3 -
 drivers/scsi/3w-sas.c                     |    3 -
 drivers/scsi/3w-xxxx.c                    |    3 -
 drivers/scsi/aacraid/linit.c              |    1=20
 drivers/scsi/arcmsr/arcmsr_hba.c          |    1=20
 drivers/scsi/bfa/bfa_fcs.h                |    1=20
 drivers/scsi/bfa/bfa_fcs_lport.c          |   14 ++++-
 drivers/scsi/bfa/bfad_attr.c              |    7 --
 drivers/scsi/gdth.c                       |    1=20
 drivers/scsi/hosts.c                      |    1=20
 drivers/scsi/hpsa.c                       |    5 +
 drivers/scsi/ipr.c                        |    3 -
 drivers/scsi/ips.c                        |    1=20
 drivers/scsi/libsas/sas_ata.c             |    2=20
 drivers/scsi/megaraid.c                   |    1=20
 drivers/scsi/megaraid/megaraid_mbox.c     |    1=20
 drivers/scsi/megaraid/megaraid_sas_base.c |    1=20
 drivers/scsi/pmcraid.c                    |    1=20
 drivers/scsi/sd.c                         |    6 ++
 drivers/scsi/storvsc_drv.c                |    1=20
 drivers/usb/class/cdc-acm.c               |    2=20
 drivers/usb/serial/ftdi_sio.c             |   37 +++++++++-----
 drivers/usb/serial/mos7840.c              |   32 ++++++------
 drivers/usb/serial/pl2303.c               |   32 +++++-------
 drivers/usb/serial/spcp8x5.c              |   30 +++++------
 drivers/xen/grant-table.c                 |    6 +-
 fs/nfs/nfs4proc.c                         |   10 +++
 fs/pipe.c                                 |   39 +++++++--------
 include/crypto/scatterwalk.h              |    3 -
 include/linux/genalloc.h                  |    4 -
 include/scsi/scsi_host.h                  |    6 ++
 kernel/irq/pm.c                           |    2=20
 kernel/time/timekeeping.c                 |    2=20
 lib/genalloc.c                            |   19 ++++---
 net/ipv4/udp.c                            |    3 +
 sound/pci/hda/patch_realtek.c             |   55 ++++++++++++++++++---
 sound/soc/codecs/wm8731.c                 |    4 -
 sound/soc/codecs/wm8990.c                 |    2=20
 74 files changed, 456 insertions(+), 256 deletions(-)

AceLan Kao (2):
      HID: usbhid: quirk for Synaptics Large Touchccreen
      HID: usbhid: quirk for SiS Touchscreen

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Arnaud Ebalard (2):
      ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260
      ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration

Colin Leitner (4):
      USB: pl2303: fixed handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: mos7840: correct handling of CS5 setting
      USB: spcp8x5: correct handling of CS5 setting

Dan Williams (1):
      SCSI: libsas: fix usage of ata_tf_to_fis

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

David Henningsson (2):
      ALSA: hda - Fix headset mic input after muted internal mic (Dell/Real=
tek)
      ALSA: hda - Add mono speaker quirk for Dell Inspiron 5439

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't override mac80211's queue setting

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Greg Kroah-Hartman (1):
      Linux 3.10.24

Gregory CLEMENT (1):
      ARM: mvebu: use the virtual CPU registers to access coherency registe=
rs

H. Peter Anvin (1):
      x86-64, build: Always pass in -mno-sse

Helge Deller (1):
      parisc: fix mmap(MAP_FIXED|MAP_SHARED) to already mmapped address

Hong Zhiguo (1):
      Update of blkg_stat and blkg_rwstat may happen in bh context. While u=
64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is no=
t enough to avoid preemption by bh and may read strange 64 bit value.

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac

Ivan Vecera (1):
      tg3: avoid double-freeing of rx data memory

James Bottomley (1):
      SCSI: enclosure: fix WARN_ON in dual path device removing

Joonyoung Shim (1):
      lib/genalloc.c: fix overflow of ending address of memory chunk

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Torvalds (1):
      vfs: fix subtle use-after-free of pipe_inode_info

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Ludovic Desroches (1):
      ARM: at91: sama5d3: reduce TWI internal clock frequency

Marc Kleine-Budde (1):
      can: c_can: don't call pm_runtime_get_sync() from interrupt context

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Martin K. Petersen (1):
      SCSI: Disable WRITE SAME for RAID and virtual host adapter drivers

Martin Schwidefsky (1):
      time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return va=
lue

Russell King (3):
      ARM: fix booting low-vectors machines
      ARM: footbridge: fix VGA initialisation
      ARM: footbridge: fix EBSA285 LEDs

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Stephen M. Cameron (2):
      SCSI: hpsa: do not discard scsi status on aborted commands
      SCSI: hpsa: return 0 from driver probe function on success, not 1

Takashi Iwai (3):
      ALSA: hda - Fix silent output on ASUS W7J laptop
      ALSA: hda - Another fixup for ASUS laptop with ALC660 codec
      ALSA: hda - Fix silent output on MacBook Air 2,1

Tom Gundersen (2):
      Input: allow deselecting serio drivers even without CONFIG_EXPERT
      Input: mousedev - allow disabling even without CONFIG_EXPERT

Tom Lendacky (3):
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Tomas Winkler (2):
      mei: me: add Lynx Point Wellsburg work station device id
      mei: add 9 series PCH mei device ids

Trond Myklebust (1):
      NFSv4: Update list of irrecoverable errors on DELEGRETURN

Vijaya Mohan Guvva (1):
      SCSI: bfa: Fix crash when symb name set for offline vport


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqVzoAAoJEDjbvchgkmk+rtMP/0+IFgC2HnmnMDD0ns+6NvB6
CDCXd8eE0bv5Mhozw9RCg0ReX5SgVklc9VSpaBH4xCRXSNY8ipSXqTzF6/0RSg9y
mJSqlHxCQAABNCEPw5l3qzhkOt7GcZhpy4KoPDePE0WYYiCmd6pgtd4qqKuLGBjw
f1r9V5mHdUBV+mQ2oq6/ZNiF7aKxzFe2TunYEa1s8V37TFw5YGd7dlwMLcbaogd2
VzjY3q2Z/yVMkcnMYkG40JXauSIuTw+YT4q3uOca4S71EmvsVLoHIye6FbwglbBy
Ub0F6OoYGnRyTylf3XvSnkbz/T+3Kw84ZYEvQxFbuiAxi9z1Z75ati1r0WKCeywS
vsB/xtHbha9rS+9VFnd8rP1rJL8cGTKwfe9p2DSVja9y5gTXq3xhqP3jtURvetqx
kCz0mWgViCbXBg6Oj5X00v33FISJQGN3dmrdTrq8qOHAzmq3OSbOFoAH0la1eFao
qzAXdz+6nNjDU+syCeYSGCCXAF4DX/jz16mmwIcY/cBfSnSVCMr+upJnglle+FqF
P4RALzjROGPcc66RVXdOQ17wX0NSTG/liYJgGNKJ5wFoQHM2IzsBMivR9Yxq87hx
hrVfE5cRU4rZ0yAgBWKRTyogo6rhWOcRrem2+NTZYvOsX8sheoMAitOdtARQOlhT
yUzKaKgPy9mMoecK7iTW
=eDik
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
