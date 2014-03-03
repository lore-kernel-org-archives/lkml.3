Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaCCIqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:46:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41185 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaCCIqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:46:12 -0500
Message-ID: <5314412B.6060502@ti.com>
Date: Mon, 3 Mar 2014 10:45:31 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/3] Reorder drivers/video directory
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="1aFiO4jTbmCkgm22nURIn6eAU01ROLBcX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1aFiO4jTbmCkgm22nURIn6eAU01ROLBcX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27/02/14 13:54, Tomi Valkeinen wrote:
> Hi,
>=20
> This is a re-send of the series, with RFC removed from the subject, and=
 a bunch
> of acks added.
>=20
> I'm cc'ing more people, to make sure this doesn't come as a surprise, a=
nd to
> make sure this is not a bad idea, doomed to fail horribly.
>=20
> So this series creates a new directory, drivers/video/fbdev/, to which =
all
> fbdev related files are moved. Also, a new directory, drivers/video/fbd=
ev/core/
> is created, to which the core fbdev framework files are moved. This mak=
es the
> drivers/video hierarchy much more clear.
>=20
> Presuming no one has objections to this as such, I wonder what's the le=
ast
> painful way to merge this? Normally, like any other fbdev change? As a =
separate
> pull request, maybe at -rc2 time frame, based on -rc1? Something else?
>=20
>  Tomi
>=20
> Tomi Valkeinen (3):
>   video: move fbdev to drivers/video/fbdev
>   fbdev: move fbdev core files to separate directory
>   video: Kconfig: move drm and fb into separate menus

I have pushed this to my for-next branch. Let's see what happens... At
least I'm able to merge the current linux-next without any conflicts.

 Tomi



--1aFiO4jTbmCkgm22nURIn6eAU01ROLBcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFEErAAoJEPo9qoy8lh711sUQAKbKxrgYYGjMvBkiHVpn6//g
9A+lWHWRsvSrzyLlayvR96xEsUwxszoIB6xwZH+UiR/IAwpnXJvwXoKEhSicSku+
22SUJVYtRqorhexgZ/eAF9g0XGBtNHPaMhWaUm1qW6d4aqN+in28ncgCIdmcafl2
mTLs2YJYxy3Kq33CVK01fedQtE55Jrio7t9aYNY+x6I3iFIoTG3eDJ6oM2iKpJb9
LNx2WhpO3Vam1qqbpmzVCKuMU78gcHyzKtm9w5YtlfkDn9GlZPzwf2MKRKdUL4Qj
H8L75QPo6Dnt514MDX2ELiuvbFzct4qeYviEiaTAEQOqvmF4y4/lvh4Ml3hOD3cp
9X48Bg1TQ6vz5OrcXc5OD0uHGvPtm4xlR1WvWazWZrwiVGbnUUutd4bcPaOjAQ6I
LDO4BNCDiNe9mhBNX8iebBo0reXRM2fCW6BmAwmWTvoA10ChuFSy7ukl6Wr/vG35
XNg0+W3g5F6P+t/+Hghx3NCHvLLTE/ZCDkgL0hUVfXBt+diFWq+5jmDMEBM7LzLT
esbAXqmXtABfU3je7RM3r8WDT+WZDZS8ZnmAmYaiT21ISpE07hjsnBQdu7YOq8QR
ARHfNsTPP/rYcxTlPeTN8dOnE6eiuc1D4RPftWAxm9Wj0PCIz1x8dv7xmtZDHykf
hZAiUdK31Ewfj0yYJp6g
=CqFR
-----END PGP SIGNATURE-----

--1aFiO4jTbmCkgm22nURIn6eAU01ROLBcX--
