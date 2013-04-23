Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3DWPQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:16:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab3DWPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:16:12 -0400
Date: Tue, 23 Apr 2013 18:15:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        <mian.yousaf.kaukab@stericsson.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 06/10] usb: musb: ux500: add device tree probing support
Message-ID: <20130423151533.GD15177@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-7-git-send-email-lee.jones@linaro.org>
 <201304231714.06326.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DEfZqDS1MPR2ysog"
Content-Disposition: inline
In-Reply-To: <201304231714.06326.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DEfZqDS1MPR2ysog
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 05:14:06PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 April 2013, Lee Jones wrote:
> > +Required properties:
> > + - compatible : Should be "stericsson,db8500-musb"
> > + - reg        : Offset and length of registers
> > + - interrupts : Interrupt; mode, number and trigger
> > + - mode       : One of; "host", "otg", or "peripheral"
>=20
> I think we don't have any precedent for this combination of "mode" proper=
ty
> and contents. You could either try to match ehci-omap.txt and do

there is dr_mode which other folks are using. Let's use the same thing.

--=20
balbi

--DEfZqDS1MPR2ysog
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdqWVAAoJEIaOsuA1yqREj1UP/RyvUPhsKD9ETSJbNCsdLC3K
1dBwmz21zJfrvc/GX0jdpjoE1f3bTG44Nj4vW2PrpScY9DEKzJASda5kMzBOlqNu
eQH8NvKL3cCUWQ2lfuMQhx+uCXwgcmrrwHLoPyldnNctnX8xUaGn5u2BAqlcSMBx
Xv45CF2GG0dSYfnsUsEjFVnGFpUCI9hjm+HR/NWhwPv93UAEOzICcHnwkxofRB7T
GouuRe29SabQPbvlrF/qSL6o5ZPC5aX8stt9a62y6ZtMAIMgYF05a95Z3pfCCxRB
wTEYwXdDCZHWy7aUbDU0CdcdgdWj46iWRmMcHMbCcmpxFyNnHld6FaaKbGTtfHaF
p4OdvMC9nGDZHyIE8fTmwpvPFaBXV50rrWJhOdl1xJIWH0klMaoKMeh/fVAS8lA5
5zhlgte3Xbs5oOUXzyiR/oWXPPygTN0IY+A0h1LAGtbbjmnDTIt+lyBQ0jdpyCPR
EVMeqchmueRBlFr9TyO26jgJxjb9EJI9zpJGMbJUyHTURbo0sK1Cdkcp+ae+UN0B
519slPTEvDOHOpAfjJIoW+UGuohOCFn/HRrqyxkASt9UqrM1ngQqG+4joKqFowTj
jTbd4LfbumdgkCJXLuLu7DDKt46M3pVk2YjAElKdTPxxVtUhNShJP1pUXjS02eFd
REj3QHYZaqMjdrVm0YbA
=Inr+
-----END PGP SIGNATURE-----

--DEfZqDS1MPR2ysog--
