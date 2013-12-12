Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LLGtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:49:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3LLGtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:49:00 -0500
Date: Wed, 11 Dec 2013 22:50:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.74
Message-ID: <20131212065045.GA13639@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.74 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-i801  |    1 +
 Makefile                           |    2 +-
 arch/um/os-Linux/start_up.c        |    2 ++
 crypto/algif_hash.c                |    3 +++
 crypto/algif_skcipher.c            |    3 +++
 crypto/authenc.c                   |    7 ++++---
 crypto/ccm.c                       |    3 ++-
 drivers/ata/ahci.c                 |   24 ++++++++++++++++++++++++
 drivers/char/i8k.c                 |    7 +++++++
 drivers/gpio/gpio-mpc8xxx.c        |    8 ++++++--
 drivers/i2c/busses/Kconfig         |    1 +
 drivers/i2c/busses/i2c-i801.c      |    3 +++
 drivers/input/Kconfig              |    2 +-
 drivers/input/keyboard/Kconfig     |    4 ++--
 drivers/input/serio/Kconfig        |    6 +++---
 drivers/misc/enclosure.c           |    7 +++++++
 drivers/net/ethernet/smsc/smc91x.h |   22 ++++------------------
 drivers/scsi/hpsa.c                |    4 ++--
 drivers/scsi/libsas/sas_ata.c      |    2 +-
 drivers/usb/class/cdc-acm.c        |    2 ++
 drivers/usb/serial/mos7840.c       |   32 ++++++++++++++++----------------
 drivers/usb/serial/pl2303.c        |   32 +++++++++++++++-----------------
 drivers/usb/serial/spcp8x5.c       |   30 ++++++++++++++----------------
 fs/nfs/nfs4proc.c                  |   10 ++++++++--
 include/crypto/scatterwalk.h       |    3 ++-
 kernel/irq/pm.c                    |    2 +-
 net/ipv4/udp.c                     |    3 +++
 sound/soc/codecs/wm8731.c          |    4 ++--
 sound/soc/codecs/wm8990.c          |    2 ++
 29 files changed, 142 insertions(+), 89 deletions(-)

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration

Colin Leitner (3):
      USB: pl2303: fixed handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: spcp8x5: correct handling of CS5 setting

Dan Williams (1):
      SCSI: libsas: fix usage of ata_tf_to_fis

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

Greg Kroah-Hartman (1):
      Linux 3.4.74

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac

James Bottomley (1):
      SCSI: enclosure: fix WARN_ON in dual path device removing

James Ralston (1):
      ahci: Add Device IDs for Intel Lynx Point-LP PCH

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Sergei Trofimovich (1):
      um: add missing declaration of 'getrlimit()' and friends

Seth Heasley (2):
      ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs
      i2c: i801: SMBus patch for Intel Avoton DeviceIDs

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Stephen M. Cameron (2):
      SCSI: hpsa: do not discard scsi status on aborted commands
      SCSI: hpsa: return 0 from driver probe function on success, not 1

Tom Gundersen (2):
      Input: allow deselecting serio drivers even without CONFIG_EXPERT
      Input: mousedev - allow disabling even without CONFIG_EXPERT

Tom Lendacky (3):
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Trond Myklebust (1):
      NFSv4: Update list of irrecoverable errors on DELEGRETURN


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqVzEAAoJEDjbvchgkmk+7ksP/2KHaCWAdznrHkQzDp5+Fs8q
ix1guh2bGezFdgb9wYda7+HlLtn+m6hpUlwh7Rt1opBmG4FfxlLrivZX4o2+CugF
Q36SEuyDXpOQpPHOF9kHx2aUYSB27wgl0t5/Wkf1XTJY4YzzINigzXieSK4PpoTC
QusVEDEFqAgRLqh7yBcBcYK893vdUOTYWR6mm2qSr8jKBaRtbHx0ZyOVDLwHSTC/
kSeviAHcViip8b9bAvySAloiSVBdvc4CQv4EAAHYMbDGHnjfakGugeuUWO2Gsvk9
C/0mvzjWOJnoAKlfC0KJ/Oc4ULI/VEQVfMkBcRxUFTbjVQ/zpxzYJ9F0F6E6hXwO
z4dVEZSI7/k4o4MNprEyXRzOuShqxZSi/W0TeJwf3TK2LEeG4jvy06tLQ9DgQyO9
ALsAfXPbLoNj+3IbIiYSFEmpaNwmSJSQKnXKqyFa0pwYSt2dRYiimAdiJnDgDlWv
QNoxsFUgp3Dlbr4jKo472bx/dyyIgpF1SHQqE41nx1Xhu6Cc+OMg9H+73Hi5uQer
XamBJfj+2NvZhYmADlucoc9Jucg+HHYphjsAZ7iDiV/mACZ0cqNbAEUNTmYYET6o
ero8TX9hzw/Yg09jj7V66aiCPRtOpMqXsW4nYPYGKXrOH8d3dKAPTmQqb8Rod6DG
GplqLQHDivG3eMAq7ZU7
=sT0s
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
