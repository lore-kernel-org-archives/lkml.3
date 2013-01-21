Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3AUTy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:54:26 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34415 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3AUTyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:54:24 -0500
Date: Mon, 21 Jan 2013 11:54:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.4
Message-ID: <20130121195420.GA6534@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.4 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm64/include/asm/pgtable.h             |   16 +++--
 arch/s390/include/asm/timex.h                |   28 +++++++++
 arch/s390/kernel/time.c                      |    2=20
 arch/s390/kvm/interrupt.c                    |    2=20
 arch/sh/include/asm/elf.h                    |    4 -
 arch/x86/kernel/entry_32.S                   |    1=20
 arch/x86/kernel/setup.c                      |   78 ++++++++++++++++++++++=
+++++
 drivers/base/firmware_class.c                |    2=20
 drivers/gpu/drm/radeon/r600_cs.c             |    6 +-
 drivers/gpu/drm/radeon/radeon_cs.c           |    5 +
 drivers/iommu/intel-iommu.c                  |   31 ++++++++++
 drivers/net/ethernet/intel/igb/igb_main.c    |   22 +++++--
 drivers/staging/vt6656/bssdb.h               |    1=20
 drivers/staging/vt6656/int.h                 |    1=20
 drivers/staging/vt6656/iocmd.h               |   33 +++++------
 drivers/staging/vt6656/iowpa.h               |    8 +-
 drivers/staging/wlan-ng/prism2mgmt.c         |    2=20
 drivers/target/target_core_device.c          |    1=20
 drivers/target/target_core_fabric_configfs.c |   12 ++++
 drivers/target/target_core_tpg.c             |    1=20
 drivers/target/target_core_transport.c       |   11 ++-
 drivers/target/tcm_fc/tfc_sess.c             |   12 +++-
 drivers/tty/pty.c                            |    2=20
 drivers/tty/serial/8250/8250.c               |   11 +++
 drivers/tty/serial/8250/8250.h               |    1=20
 drivers/tty/serial/8250/8250_dw.c            |    2=20
 drivers/tty/serial/8250/8250_pci.c           |   38 +++++++++++++
 drivers/tty/serial/ifx6x60.c                 |    1=20
 drivers/tty/serial/mxs-auart.c               |    4 +
 drivers/tty/serial/vt8500_serial.c           |    2=20
 drivers/usb/chipidea/host.c                  |    3 +
 drivers/usb/serial/io_ti.c                   |    3 +
 drivers/usb/serial/option.c                  |    9 ++-
 drivers/xen/grant-table.c                    |   48 ++++++++++------
 fs/ext4/inode.c                              |    2=20
 include/target/target_core_base.h            |    4 +
 include/uapi/linux/serial_core.h             |    4 +
 sound/pci/hda/patch_hdmi.c                   |    2=20
 sound/usb/quirks.c                           |    8 +-
 40 files changed, 341 insertions(+), 84 deletions(-)

Ben Hutchings (1):
      staging: vt6656: Fix inconsistent structure packing

Bj=F8rn Mork (2):
      USB: option: add TP-LINK HSUPA Modem MA180
      USB: option: blacklist network interface on ONDA MT8205 4G LTE

David Henningsson (1):
      ALSA: usb - fix race in creation of M-Audio Fast track pro driver

Eric Sandeen (1):
      ext4: init pagevec in ext4_da_block_invalidatepages

Fabio Estevam (1):
      usb: chipidea: Allow disabling streaming not only in udc mode

Frediano Ziglio (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS gu=
ests.

Greg Kroah-Hartman (1):
      Linux 3.7.4

Hannes Reinecke (1):
      target: use correct sense code for LUN communication failure

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow

Ilija Hadzic (2):
      drm/radeon: fix NULL pointer dereference in UMS mode
      drm/radeon: fix a bogus kfree

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Jiri Slaby (1):
      pty: return EINVAL for TIOCGPTN for BSD ptys

Luciano Coelho (1):
      firmware: make sure the fw file size is not 0

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
      tcm_fc: Do not report target role when target is not defined

Matt Wilson (1):
      xen/grant-table: correctly initialize grant table version 1

Maxime Ripard (1):
      tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

Nicholas Bellinger (1):
      target: Add link_magic for fabric allow_link destination target_items

Roland Dreier (3):
      target: Fix missing CMD_T_ACTIVE bit regression for pending WRITEs
      target: Fix use-after-free in LUN RESET handling
      target: Release se_cmd when LUN lookup fails for TMR

Stefan Assmann (1):
      igb: release already assigned MSI-X interrupts if setup fails

Steffen Trumtrar (1):
      mxs: uart: fix setting RTS from software

Stephen Hurd (1):
      8250/16?50: Add support for Broadcom TruManage redirected serial port

Takashi Iwai (1):
      ALSA: hda/hdmi - Work around "alsactl restore" errors

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Dom=
ain

Tormod Volden (1):
      staging: wlan-ng: Fix clamping of returned SSID length

Wei Yongjun (1):
      tty: serial: vt8500: fix return value check in vt8500_serial_probe()

Will Deacon (1):
      arm64: mm: only wrprotect clean ptes if they are present

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

chao bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port


--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/ZzsAAoJEDjbvchgkmk+ThgQAMIofJreZjuXrQ6iK5IdykiG
vrichki1vGlL4V7MwRb4T5XSKcbYghuOXFgMErJU6JIHb8mqn1Et9bRmSqRet7tI
+M2NCEbhPm5GS1hYhWfmvVRFx3tS9tBwPD2+x3u+vaExGdLtdtwVGcJvQh24Mu/T
ap5R/Kt+J4eKChG9dMON2hQFm/KTkQh/HR9tpODMQbN7uuxZS8ty7kQGgRQF5Bz8
PxqXh2X+Su86JNJk3ZFh99vyXoi+gHMq4/CzvKMYV6VxFD+fpS2+S7wz/MPtdMs4
Ci2r84lkoTcw1AVE2VLk4xu9Zb/5jE6jn4rPWgdVTJSVAQERiZkDWkCzF6qmxbA/
W3eUVnJS8Mc5aHhywFKe26h4b2TuWzWzc3cvGIny32c9I2ruombJUfp3FsGDpDWP
NM6/FyaZGBd9tH+ekgO6qyGSaYAbDno00zkAlEzHbtbf7Oi2SN9mkPZEfjE1k+41
jOXeDXvrEMv8cKlTApVzsph9tgelOl64LZqMP3b3t7snOXRjGnGrv+jHZvJtGfzW
ngfdVSvl5wJnOlvgW5RdxT4eLtR9IBP6PrE6+knztt1fAeDLywOnOd2+xHGYWaVi
4T3mpxfWZqEzYGxlnYS5VhwdR1A8vgfQneWke7xndH3Y9cMFxKkzhtedjai0Okh/
b5wQOdu/qnJKij9Inz6n
=5Ufk
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
