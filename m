Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3JVLYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:24:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3JVLYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:24:18 -0400
Date: Tue, 22 Oct 2013 12:25:43 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.67
Message-ID: <20131022112543.GA5735@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.67 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/parisc/kernel/traps.c              |    6 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2=20
 drivers/char/random.c                   |    3 -
 drivers/gpu/drm/radeon/evergreen.c      |    2=20
 drivers/watchdog/ts72xx_wdt.c           |    3 -
 fs/ext4/xattr.c                         |    2=20
 fs/statfs.c                             |    2=20
 include/linux/random.h                  |    1=20
 init/main.c                             |    2=20
 mm/mmap.c                               |   77 +++++++++++++++++++++++++++=
+++--
 sound/pci/hda/patch_realtek.c           |    1=20
 sound/usb/usx2y/usbusx2yaudio.c         |   22 +--------
 sound/usb/usx2y/usx2yhwdeppcm.c         |    7 --
 14 files changed, 93 insertions(+), 39 deletions(-)

Cyril Hrubis (1):
      mm/mmap: check for RLIMIT_AS before unmapping

Dan Carpenter (1):
      watchdog: ts72xx_wdt: locking bug in ioctl

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Dave Jones (1):
      ext4: fix memory leak in xattr

Greg Kroah-Hartman (1):
      Linux 3.4.67

Helge Deller (1):
      parisc: fix interruption handler to respect pagefault_disable()

Linus Torvalds (2):
      vfs: allow O_PATH file descriptors for fstatfs()
      mm: do not grow the stack vma just because of an overrun on preceding=
 vma

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Takashi Iwai (1):
      ALSA: hda - Add fixup for ASUS N56VZ

Theodore Ts'o (1):
      random: run random_int_secret_init() run after all late_initcalls

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZmC3AAoJEDjbvchgkmk+wSkP/2UX9ct3+VOjCab9+eYl+6Jg
OM+gnpQ7Qo5ExJ/yXTQ2FJv31S3afNYRoeTMm5LhQCawPLEOr3DHjior1plvJTAw
WGEBWMEgR4JToXvMFmVcMO4p7wKDD1eOhJ043ffW9pyVegjbTHQIF8x0y9wvSNog
52wkf8DshZdHeoBTor43bgIGzeC7X7yVXczgBOTT911mBMAo/DEd0d6ff2hAdu+A
ZnjWFn196aLRTEvkwe8IJiACJLm5OkkcAAZsv6e1rlW01wxbDaIsCYhbMA1UjThd
8jdYjX/+0bWow/qmNKjfmTd405xGTmruC/s9UR2/kmERWDk9IwmRztTYlnK7eCpM
JY6WpYE35XS/6okTPH8avtXdNgKzd1tqwuL8xZBoST0ssNbG1N8kXF53mbLyoott
WCtatLj5xjV854IlGcOzGumufrzymCsPxISEWsvocSS26pbDd1aklEUL83mEnUMb
sqi33XnpLcO4N/8lLYuNLLM8TNMB6M7z2syeMuHhtrvwrohler/ItyZHYi3kQ5hg
zVBArqMbrKEF4O36EtTSPvJd6YS7XI7lZ9FHZIag30Zs1NqE4O+dBXeZyEwDri8g
O3SGU7Z218+lz0RReWg5dmlvcZG2zgAcaAXgTJAueZ8z5KHVfHHAZGpowkrCdFNc
b5ZBqWmgAXfjpV8w8zSQ
=wt6m
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
