Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3LLGuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:50:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3LLGuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:50:05 -0500
Date: Wed, 11 Dec 2013 22:51:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.5
Message-ID: <20131212065152.GA13784@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.5 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                                |    2=20
 arch/arm/boot/dts/armada-370-db.dts                     |   28 +-
 arch/arm/boot/dts/armada-370-xp.dtsi                    |    2=20
 arch/arm/boot/dts/armada-xp-mv78230.dtsi                |   24 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi                |  109 ++++++++--
 arch/arm/boot/dts/omap4-panda-common.dtsi               |   20 -
 arch/arm/configs/multi_v7_defconfig                     |    2=20
 arch/arm/include/asm/pgtable.h                          |    2=20
 arch/arm/mach-at91/sama5d3.c                            |    6=20
 arch/arm/mach-footbridge/common.c                       |    3=20
 arch/arm/mach-footbridge/dc21285.c                      |    2=20
 arch/arm/mach-footbridge/ebsa285.c                      |   22 +-
 arch/arm/mm/mmap.c                                      |    2=20
 arch/arm/mm/pgd.c                                       |    3=20
 arch/parisc/kernel/sys_parisc.c                         |   25 +-
 arch/s390/crypto/aes_s390.c                             |   31 +--
 arch/x86/Makefile                                       |    8=20
 block/blk-cgroup.h                                      |    8=20
 crypto/algif_hash.c                                     |    3=20
 crypto/algif_skcipher.c                                 |    3=20
 crypto/authenc.c                                        |    7=20
 crypto/ccm.c                                            |    3=20
 drivers/ata/libata-scsi.c                               |    1=20
 drivers/char/i8k.c                                      |    7=20
 drivers/cpuidle/cpuidle.c                               |    2=20
 drivers/firewire/sbp2.c                                 |    1=20
 drivers/firmware/efi/efi-pstore.c                       |  163 +++++++++++=
+++--
 drivers/firmware/efi/efivars.c                          |   12 -
 drivers/firmware/efi/vars.c                             |   12 -
 drivers/gpio/gpio-mpc8xxx.c                             |    8=20
 drivers/input/Kconfig                                   |    2=20
 drivers/input/keyboard/Kconfig                          |    4=20
 drivers/input/serio/Kconfig                             |    6=20
 drivers/misc/enclosure.c                                |    7=20
 drivers/misc/mei/hw-me-regs.h                           |    6=20
 drivers/misc/mei/pci-me.c                               |    5=20
 drivers/net/can/c_can/c_can.c                           |   21 +-
 drivers/net/can/flexcan.c                               |    2=20
 drivers/net/can/sja1000/sja1000.c                       |   17 -
 drivers/net/ethernet/broadcom/tg3.c                     |   12 -
 drivers/net/wireless/iwlwifi/dvm/tx.c                   |   14 -
 drivers/pnp/driver.c                                    |   12 +
 drivers/scsi/3w-9xxx.c                                  |    3=20
 drivers/scsi/3w-sas.c                                   |    3=20
 drivers/scsi/3w-xxxx.c                                  |    3=20
 drivers/scsi/aacraid/linit.c                            |    1=20
 drivers/scsi/arcmsr/arcmsr_hba.c                        |    1=20
 drivers/scsi/bfa/bfa_fcs.h                              |    1=20
 drivers/scsi/bfa/bfa_fcs_lport.c                        |   14 +
 drivers/scsi/bfa/bfad_attr.c                            |    7=20
 drivers/scsi/gdth.c                                     |    1=20
 drivers/scsi/hosts.c                                    |    1=20
 drivers/scsi/hpsa.c                                     |    5=20
 drivers/scsi/ipr.c                                      |    3=20
 drivers/scsi/ips.c                                      |    1=20
 drivers/scsi/libsas/sas_ata.c                           |    2=20
 drivers/scsi/megaraid.c                                 |    1=20
 drivers/scsi/megaraid/megaraid_mbox.c                   |    1=20
 drivers/scsi/megaraid/megaraid_sas_base.c               |    1=20
 drivers/scsi/pmcraid.c                                  |    1=20
 drivers/scsi/sd.c                                       |    6=20
 drivers/scsi/storvsc_drv.c                              |    1=20
 drivers/spi/spi-pxa2xx.c                                |    2=20
 drivers/tty/n_tty.c                                     |    6=20
 drivers/usb/class/cdc-acm.c                             |    2=20
 drivers/usb/serial/ftdi_sio.c                           |   37 ++-
 drivers/usb/serial/mos7840.c                            |   32 +--
 drivers/usb/serial/pl2303.c                             |   30 +-
 drivers/usb/serial/spcp8x5.c                            |   30 +-
 drivers/video/omap2/displays-new/panel-sony-acx565akm.c |    5=20
 drivers/xen/grant-table.c                               |    6=20
 fs/nfs/nfs4proc.c                                       |   10=20
 fs/pipe.c                                               |   39 +--
 include/crypto/scatterwalk.h                            |    3=20
 include/linux/efi.h                                     |    4=20
 include/scsi/scsi_host.h                                |    6=20
 include/sound/soc-dapm.h                                |    3=20
 kernel/irq/pm.c                                         |    2=20
 kernel/time/timekeeping.c                               |    2=20
 net/ipv4/udp.c                                          |    3=20
 sound/pci/hda/patch_analog.c                            |    4=20
 sound/pci/hda/patch_realtek.c                           |   55 ++++-
 sound/soc/codecs/wm8731.c                               |    4=20
 sound/soc/codecs/wm8990.c                               |    2=20
 84 files changed, 676 insertions(+), 297 deletions(-)

Aaro Koskinen (1):
      ARM: OMAPFB: panel-sony-acx565akm: fix bad unlock balance

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Arnaud Ebalard (2):
      ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable
      ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260

Balaji T K (1):
      ARM: dts: omap4-panda-common: Fix pin muxing for wl12xx

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

Dmitry Torokhov (1):
      PNP: fix restoring devices after hibernation

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't override mac80211's queue setting

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Greg Kroah-Hartman (1):
      Linux 3.12.5

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

Konrad Rzeszutek Wilk (1):
      cpuidle: Check for dev before deregistering it.

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Torvalds (1):
      vfs: fix subtle use-after-free of pipe_inode_info

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Ludovic Desroches (1):
      ARM: at91: sama5d3: reduce TWI internal clock frequency

Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Marc Kleine-Budde (2):
      can: flexcan: use correct clock as base for bit rate calculation
      can: c_can: don't call pm_runtime_get_sync() from interrupt context

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Martin K. Petersen (1):
      SCSI: Disable WRITE SAME for RAID and virtual host adapter drivers

Martin Schwidefsky (1):
      time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Matt Wilson (1):
      xen/gnttab: leave lazy MMU mode in the case of a m2p override failure

Mika Westerberg (1):
      spi/pxa2xx: add new ACPI IDs

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return va=
lue

Olof Johansson (1):
      ARM: multi_v7_defconfig: enable SDHCI_BCM_KONA and MMC_BLOCK_MINORS=
=3D16

Peter Hurley (1):
      n_tty: Fix missing newline echo

Russell King (3):
      ARM: fix booting low-vectors machines
      ARM: footbridge: fix VGA initialisation
      ARM: footbridge: fix EBSA285 LEDs

Seiji Aguchi (1):
      efivars, efi-pstore: Hold off deletion of sysfs entry until the scan =
is completed

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Stephen M. Cameron (2):
      SCSI: hpsa: do not discard scsi status on aborted commands
      SCSI: hpsa: return 0 from driver probe function on success, not 1

Stephen Warren (1):
      ASoC: dapm: Use SND_SOC_DAPM_INIT_REG_VAL in SND_SOC_DAPM_MUX

Takashi Iwai (5):
      ALSA: hda - Fix silent output on ASUS W7J laptop
      ALSA: hda - Another fixup for ASUS laptop with ALC660 codec
      ALSA: hda - Use always amps for auto-mute on AD1986A codec
      ALSA: hda - Fix bad EAPD setup for HP machines with AD1984A
      ALSA: hda - Fix silent output on MacBook Air 2,1

Thomas Petazzoni (1):
      ARM: mvebu: re-enable PCIe on Armada 370 DB

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


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqV0IAAoJEDjbvchgkmk+5PMQANPNAfZiNp+ZuHWgZlSOOarq
o9s150GCku8xTP7pgAbAHLPxSHdrEFsRHiJOKup+37LuGGCgwnF5ywFIt+BppD4r
qZX4M4r1wdalIscUdO8sYCK+olJy8bXLUHHGDc3O0Y5THTPhANg/hYMJ3RXkuOMW
59aqcC/JRKJGHZaHcWDsazoLsQuwOJtc9y9/qoLVyJ+gbbhw/xq3qUZiUeSlzDhD
ERinHCct4dUIReCt2r2HVU/BcMXWu/sgTCpEtDAUl5yzVWL1GjDJkzuS4O6cKpJC
oaIxdegLe3OlWR43EpVSqIZiBYTkDzXsmeUZ38bTV+d3X/O7REqRIEKIvlpGGXi2
/bwTcZMhz2ycwvCM/5pRCgwEgU/5FPnKt2NIrwjpcA4BPThGXbICsZ9LjgdrytyO
GZWD0hxBgupnNU6m3u50g08jdjtlli4dGKAL5hyI7egz8bwqF6TceTB9rgIhkNHk
uBBe6TBbrSOzd4H96Cc7PYnz+l2F88ZOGigDrVlmI9mLKXL08RinnrmTBj2mJ68d
UhNbs6t6w5CnOIkiTdVqdt29V1jXsj/Q5w1XuhP6sWrsaQ3x0Y6LwyrbvjlFDpXu
ytpDy1/Dl1au7jwcgy5mhxh9lBAtMcM6miRM+PZBZOcA9UX5vXd40LTaRiSNJbeR
m8OFN5k6E+UPJststt9F
=yYhD
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
