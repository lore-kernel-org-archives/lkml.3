Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3CZTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:25:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37646 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab3CZTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:25:24 -0400
Date: Tue, 26 Mar 2013 21:24:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roland Stigge <stigge@gnu.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Fix compile error by selecting USB_OTG_UTILS
Message-ID: <20130326192453.GA21915@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364319361-28265-1-git-send-email-stigge@antcom.de>
 <20130326180334.GL20785@arwen.pp.htv.fi>
 <5151F48C.9060308@gnu.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <5151F48C.9060308@gnu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 26, 2013 at 08:18:36PM +0100, Roland Stigge wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: RIPEMD160
>=20
> On 03/26/2013 07:03 PM, Felipe Balbi wrote:
> > On Tue, Mar 26, 2013 at 06:36:01PM +0100, Roland Stigge wrote:
> >> The current lpc32xx_defconfig breaks like this, caused by recent
> >> phy restructuring:
> >=20
> > which commit actually caused this ? I need to know to make sure if
> > this should be sent to stable or not.
>=20
> The issue definitely surfaced after v3.8, so no need for patching
> stable, I guess.

are you sure ? I don't see any commits under drivers/usb/gadget/Kconfig
which could've caused what you described. Can you blame a commit ?

--=20
balbi

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUfYFAAoJEIaOsuA1yqRE16cQAJ+Gwy32/H9ljRHCqJ7z2abU
9jYkw5UhutMYE6fB++PggiwrhjfKrICu5h/swtt+A7ar4XlvCosPZyPfQxbicm7n
Mnb8gpV0p92HfyvTPFKo8VX4eKgxez8pnKWPduylnaq+oKG9aGVJozzs08qdKtoz
y2BcxufTdXicAsasoUSjDRpXekmiYOJ8C52e0j1yhEuMWC9Q09sW5ST2+34+tn+d
3sOF6GXXdpv0uJ44V4IsqHmFwU/fezY0Kq1UULDkv+E3fixpKUC6/ImjVTRN0BzQ
H73gzyc3p8UmbtRaMAnWbcfmnK81GxFMH6uodd2Mh7zig9+iMCRq3hl7f3R3wQmA
OeIV8yknBjM5YvruL1PotTI4VQRfR6KpTxBSKVs4KESOctNr1FZBtM7WlCLEJp15
DSRPG8kQB8QvcZVBvXjrO0BcbGojNubPAjJ1urgEgzUWohsph4yfKrbJwcctvk4h
Vhmkmo8eVnbf/yPTkoz5NvHDnNX9HBegofPc/Qk31bfJqfc1dGCefKFoO8rTI5cD
bqdQtUGZf900KFnNoqkaxOFb3vE82Jx1tzCygQc9qYCgpQ7ElB9d4meTlQNV0DfX
VwG70BBR2Mjd37zMm5micbRCtf1uNE7rkeNvWtMDFz/lsjmbvyPB6p5pdRoxEduC
ugg4dBhpA8rVKu0KxdVl
=J3sJ
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
