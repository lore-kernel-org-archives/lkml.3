Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaLGUKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:10:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaLGUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:10:45 -0500
Date: Sun, 7 Dec 2014 12:10:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.17.6
Message-ID: <20141207201043.GA12806@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.17.6 kernel.

All users of the 3.17 kernel series must upgrade.

The updated 3.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.17.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 net/netfilter/nf_conntrack_core.c |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

Greg Kroah-Hartman (2):
      Revert "netfilter: conntrack: fix race in __nf_conntrack_confirm against get_next_corpse"
      Linux 3.17.6


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhLRDAAoJEDjbvchgkmk+GLkP/3zjv2FVBV2MQm6YGHVG6ZNn
c8D8itEY6FhWIkHXWStctVWI9qKkTowKqHI2/TOlqw+GkWW5PD5qZ87RxaOMc2XR
nO1Pcrq5gcj3hBuZbebGUGzxKsyb9rOh8qU/kaqGmPhsbXWr/9WABfdZ2lfnYD/3
lnBAlBDQUqRmYLwiIOEdZ6giiUpla3DihP2lkV9/lvj2qSSUJp7XqDQHcBFenSpB
GdfD3g3UwrJp2+WdkwLw4s0CzEmmAjLMR4NiUkoI+U7hUuY4PfxucpJFbcWvzv1Q
Qic/Liuze26TXhYSdAXBkjgWyG1nJlOBoD77FzjQcIORfrp9tVeX39balo3GPhZS
B8g4TwzLo/uD5ILY8paJ+Aas0HzStyp4X8yhW7MXTOXqt8jlR9r8N5cGJOOaP5uX
kVuyvd/JsNlA9mkNoTwSvdlW1KieZXmE7Kf2O38jMialObC5vdqpkPVhHs2qSJtp
0RZoiMreCFAVICcsA/pkLvYwRTO0a4XjyKatehqCJR8Ce5nTBfkQ6oGZFG1V/LBl
xEs0KsLZd585C5wAQmpLYfjqRZa9BlnpPJ4Qv1RX155QARKdukDM7xVDbYtZKC4F
u+prYhUAvNsdu5m4cTBOeZrb5mc4Q4bjjk9PKJeovsh55DgXyRGKaOAJQOtj340M
QEJHPFUBxsxdCshQ7cZs
=Sbn2
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
