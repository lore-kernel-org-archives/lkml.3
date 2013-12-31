Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3LaTGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:06:23 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58667 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3LaTGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:06:21 -0500
Date: Tue, 31 Dec 2013 11:06:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.13-rc6
Message-ID: <20131231190618.GE6897@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Happy New Year!

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a fix for panic
in gpio-keys driver when set up with absolute events, a fixup to the new
zforce driver and a new keycode definition.

Changelog:
---------

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Heiko St=C3=BCbner (1):
      Input: zforce - fix possible driver hang during suspend

Rafa=C5=82 Mi=C5=82ecki (1):
      Input: define KEY_WWAN for Wireless WAN


Diffstat:
--------

 drivers/input/input.c                 |  4 ++++
 drivers/input/touchscreen/zforce_ts.c | 21 +++++++++++++++------
 include/uapi/linux/input.h            |  3 ++-
 3 files changed, 21 insertions(+), 7 deletions(-)

--=20
Dmitry


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSwxWqAAoJEH70+W8r6ZYqXuQQAMFNGyxj063r1bGoWigx0ire
dfpQNCJrmNIiTeDk6VCOJriDE0AVLP+zlh7aLM2jbS9Zp5i+iIOYmmJ2J4xd0Evc
jLK7oPgb/HDDojeXN4/1aP2jXWqxwPjFE28u16HR22aXrDJRw8zKrgjmTKHki6f5
SG7nQ/15RTU9ZO0aOIXNrEDXbFE7sKdnKFmHy8WWdaK2bujhOR61yqqENzMQV8/8
HZ8x8IY5Ok6YxGJgCkUkRHjEpdXoZgEfLdRuXHN5/VguIjeevbpPOH+czwUF0aei
pp/AOFFajzs/pPJdiwq9ClGJpVTpdz87TuHLlL1g8XTsThdaudUPZwqlxk1nAwXe
+ZYkvam+x6mZbZeSQzZnfgfNb6Ec6RBdAuUQCwOFC89rKQ9D1XzvPvSipdnoNvz2
pPOwG1ENCRU8pMMEqknUmcAPdoTNnP3MWEVfH/SwmzvsPItMRx2Mw2iDUplk0+XN
eJNiJUxWqyeNA45RjrtGUfVpaeekMQm2xoKC4SETMHvAy4ZOmKUztgiY4vBFujp9
PNDs9k20CGDS9+deTJmZ6YWy3ilVHvjid1MCo84s+t3NBaaQl0nRF9MKhIJRJgLD
6YkOloTFPOX7dzerZh5498YWyqbjHDRLXP7PMmOEuzxTiTiv9l3P1YSrKZaiuZyS
L/8jA4s+Dt9bCHjNEBU5
=srDb
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
