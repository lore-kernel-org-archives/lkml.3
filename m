Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaA2NG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:06:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaA2NGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:06:55 -0500
Date: Wed, 29 Jan 2014 05:08:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.1
Message-ID: <20140129130809.GA3063@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.13.1 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 +-
 drivers/extcon/extcon-gpio.c                    |   11 ++++++-----
 drivers/md/raid5.c                              |    9 +++++----
 drivers/staging/comedi/comedi_fops.c            |    2 ++
 drivers/staging/comedi/drivers/addi_apci_1032.c |    4 ++--
 drivers/staging/comedi/drivers/adl_pci9111.c    |    2 +-
 drivers/tty/serial/amba-pl011.c                 |    6 ++++++
 fs/gfs2/inode.c                                 |   16 +++++++++++++++-
 include/linux/mm.h                              |   13 ++++++++-----
 sound/pci/hda/patch_hdmi.c                      |    6 +++++-
 10 files changed, 51 insertions(+), 20 deletions(-)

Bernd Porr (1):
      staging: comedi: fix result of memdup_user for user chanlist

Bob Peterson (1):
      GFS2: Increase i_writecount during gfs2_setattr_chown

David Henningsson (1):
      ALSA: hda - Explicitly keep codec powered up in hdmi_present_sense

Geert Uytterhoeven (1):
      mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

Greg Kroah-Hartman (1):
      Linux 3.13.1

Guenter Roeck (1):
      extcon: gpio: Request gpio pin before modifying its state

H Hartley Sweeten (2):
      staging: comedi: addi_apci_1032: fix subdevice type/flags bug
      staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()

Jon Medhurst (1):
      serial: amba-pl011: use port lock to guard control register access

NeilBrown (2):
      md/raid5: fix long-standing problem with bitmap handling on write failure.
      md/raid5: close recently introduced race in stripe_head management.


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6P05AAoJEDjbvchgkmk+bs0P/2kmw4oPmOB8X66+MTf2gRmR
mqzN2vUO/Vs8qnSdPLABM3xvCUKkApXrI8J/k7USw4Szpl1cvoFhs2ZY0/+MQhnL
xYIRqUC0CBWTtYoUvdd40MSy+3yUdQ6rA0La2gkUvQxv9UoYcgunvO5XNkKEjCyF
vtQ5cqVwBokJMSgDvM7HC10XsYx7cSOsz0yTxOoL0RXfb7zLnenaZeQ9Q60+wq0O
PCgdfQiz1yotf2Yv1fUJLHaPZ9/k78lzkRBZ3GdKv+8LaG2RHHcIWh6e1c3MYZLY
aTkPluy8nV1gPIOIpEikYI4BEW2NB/PFcm6CjndEQF7kX9rNLLcSdj9tJ4IcJX+C
4UjTzaATFRgx9rLDvQO5GB7+wLedTFKjZMKMBfG1ogAaLqcQu3fia+f0HfHfCx0I
8bWuhqfZnD6bSVg7LHx5UsJ+Bs0h4kdAgnSsoMbXp6hauDeliBeFPuR21dvBACt1
Pqyg21GJwAalEq+3MiFWlIaFy+8+F/NEZldGVm8ujJW+Jfx2MbdBLb0sRf4+T1jg
HC3GdCkjNEiLESrBgW/bBmWQ7jxZwWfjT/nZCUtF7ayJZPscBncQqSFTYjwC3KjZ
EXfswMp058AFyGSZC4Y9EeFGb8UsVAAKxEzg9TwYZLT9ptO6BGnYGqIo311zohLp
ijxjP8dkkiYKBFYyzr2E
=drLG
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
