Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3F0GhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:37:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59206 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3F0GhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:37:09 -0400
Date: Thu, 27 Jun 2013 16:36:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <balbi@ti.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: regression caused by commit
 8357b48549e17b3e4e402c7f977b65708922e60f
Message-Id: <20130627163655.239cea102ba0eb968a434593@canb.auug.org.au>
In-Reply-To: <20130627061419.GE15455@arwen.pp.htv.fi>
References: <20130627061419.GE15455@arwen.pp.htv.fi>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_16_36_55_+1000_QZGLmCS5rz9frsBx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_16_36_55_+1000_QZGLmCS5rz9frsBx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 27 Jun 2013 09:14:19 +0300 Felipe Balbi <balbi@ti.com> wrote:
>
> after commit 8357b48549e17b3e4e402c7f977b65708922e60f,
> omap2plus_defconfig doesn't 'hold' the answer to USB Gadget Drivers
> anymore. Everytime I run oldconfig, it asks me again and again what USB
> Gadget Drivers should be (M/y/?).
>=20
> That's certainly not expected considering it wasn't like that before.

That commit has been reverted in today's kbuild tree and thus in today's
linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Jun_2013_16_36_55_+1000_QZGLmCS5rz9frsBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy92LAAoJEECxmPOUX5FEqzkP/3vkmnp780Y09d8gLRpCweKL
CFR0tt4qRvMTDGxpjHwF889VFQ57n5qqJSHXNowig7XP9AP8x+9lwu9a32eJVLGr
aPvzo0bKf8Iowyw58r+arUEdfNyCBH7Ld2SLWZ0qC5OhJXpnQTwI1W73gPqRkRw7
klmFE+f0k8T3Lg0QjqjmwZXrVahoc/LwMU4JipLYV9VtDJH7ONwTP0ls25dnZHL9
Unto/68Cl1Kc2nzOqW0EIgoNdDubZI9Fcgh95flIslTRNU8CVPAiWHjEvy6HBh8q
bIC5gePSlSu6V/lE+1X/hbQnN6pJ6vO+FGBSJS7sf9OKYDJqU4E20qQfwqalVqJr
uDGqeYkcFoBzuShhTFlLhf6Q4LNmhBeLdSgbKw/Oxo1Z/88anfsi8kdrGITicKfl
l2KnAATBxUXy2ff6/pr2Rkq5SvIbJgGMjaA0tbKdVU3NRey7KUD42S+VPDN13KlC
Rf3lsnICmgzn4+cgBld8W4s1MoUPO0ormQJbNssa+pJCM9qozdsWVwCjQZdJV0YC
knuab+wVWzq84T7kpodWffch8J+YRt1U4pdJAkbL5uchR0RE1BhV97blBed3iaVz
KaONJ80uG3xFTB5uU8URbbqiHb66FZiiY2+7mQ5uvUxImyrm5wC/4vVVeb0VhICn
MDuQDj6g7wgFMEli9eyA
=mx26
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_16_36_55_+1000_QZGLmCS5rz9frsBx--
