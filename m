Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3JVL2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:28:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3JVL2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:28:51 -0400
Date: Tue, 22 Oct 2013 12:30:16 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.101
Message-ID: <20131022113016.GA5911@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.101 kernel.

All users of the 3.0 kernel series must upgrade.

This is the LAST 3.0.x longterm kernel release.

It is now end-of-life.

I will NOT be doing any more 3.0.x kernel releases.  If you rely on the
3.0.x kernel series, you should now move to the 3.10.x kernel series,
or, at the worse case, 3.4.x.  Note, 3.4.x will only be maintained for
one more year, so your time is limited on that as well.

For more information about the longterm kernel releases, and what their
lifetime is, please see:
	https://www.kernel.org/category/releases.html

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    4 ++--
 arch/parisc/kernel/traps.c         |    6 +++---
 drivers/char/random.c              |    3 +--
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 drivers/watchdog/ts72xx_wdt.c      |    3 ++-
 fs/ext4/xattr.c                    |    2 ++
 fs/statfs.c                        |    2 +-
 include/linux/random.h             |    1 +
 init/main.c                        |    2 ++
 net/ipv6/inet6_connection_sock.c   |    2 +-
 10 files changed, 16 insertions(+), 11 deletions(-)

Dan Carpenter (1):
      watchdog: ts72xx_wdt: locking bug in ioctl

Dave Jones (1):
      ext4: fix memory leak in xattr

Eric Dumazet (1):
      ipv6: tcp: fix panic in SYN processing

Greg Kroah-Hartman (1):
      Linux 3.0.101

Helge Deller (1):
      parisc: fix interruption handler to respect pagefault_disable()

Linus Torvalds (1):
      vfs: allow O_PATH file descriptors for fstatfs()

Theodore Ts'o (1):
      random: run random_int_secret_init() run after all late_initcalls

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZmHIAAoJEDjbvchgkmk+mMUP/1OiKeOggXoi8BfidUi3/gpg
YDrOgBUcxhuDlHk8sck2erUH1AE6gVOOjVw45iy4/K6mu4GmBZuX56XEbLgcgMdt
yTdXFrXt3nypWHRsWj1B69F250xU34ghnaflZTSN7zy3lS9anKtD7xQonrwbRJm5
JF6jFj/k5scxYtYuZERQzurbvM9Mpwdd9AvqOHfN/itQgj4GOTGlyFqUhcKB427T
csGDDIlWGydBw9CzAhY3DO77UixvGndbfKUFV0t7vjdb01BnoyzyoCibi4fyxa/4
aweGfSbDpCSf0UGnY+OInDlcs9lLqkVVVyVOh27w2uaXPaKcCqNhwPxFrKYJ0i3h
btZTmmUbekIInrBWY0o6HzlpzVuRYtAgf6F3x1HvL7eXxbh+t9OhjlqmVikUBX+i
hN15ZvU/SZzoqCiFdeUg4Af091hhzIh4/iu2hXYuEs73QrV5W3qPdVIR56ZBRm+j
YOuqRt0oROaTe/hr/z5SObU8U7xZm83z/3UdVgrMxaWMbAsGHWq31TnCzW1hRfop
uc4TMQq1FiTOBIxI1yTbSfnVzdSTNsLQpDAmCQYmBNissmLnmHoKrNkcwGJH8gLj
0jnxQlnXLTa62vTAhM/yevfleIbhpfiGhbDy3jb/6v8gAeOKRk1vc5IFj/Xyf58o
yLWHoANnv0KQIfCWrMI1
=kGMG
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
