Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaLVQi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:38:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33651 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbaLVQiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:38:54 -0500
Date: Mon, 22 Dec 2014 10:38:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Bo Shen <voice.shen@atmel.com>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: gadget: udc: atmel: change setting for DMA
Message-ID: <20141222163813.GI12815@saruman>
Reply-To: <balbi@ti.com>
References: <1418807929-31952-1-git-send-email-voice.shen@atmel.com>
 <54930CE7.50008@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Content-Disposition: inline
In-Reply-To: <54930CE7.50008@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 06:20:39PM +0100, Nicolas Ferre wrote:
> Le 17/12/2014 10:18, Bo Shen a =E9crit :
> > According to the datasheet, when transfer using DMA, the control
> > setting for IN packet only need END_BUF_EN, END_BUF_IE, CH_EN,
> > while for OUT packet, need more two bits END_TR_EN and END_TR_IE
> > to be configured.
> >=20
> > Signed-off-by: Bo Shen <voice.shen@atmel.com>
>=20
> Seems okay, even if I am not used to these aspects:
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> I would also add a "stable" tag to these patches, something like this:
>=20
> Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
> Cc: stable@vger.kernel.org # always been there...
>=20
>=20
> Felipe,
>=20
> Can you take both of these patches as fixes?

I'll get back to them... Still other patches to go through.

--=20
balbi

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmEj1AAoJEIaOsuA1yqRE/e4QAJGni1O6sHI5BtgKRsoDike3
e6C4LGycV0cHs/rsY6wU46cKKhUGAcQ59XhLtBKKA65fAHHK2+VxtJTdCbf169aP
kS6113qTelj9bwK/kjVWu8KTlATr+PO369xPen+S43zPE21bgSQ2qNmCmSquMioW
PEjOdIKf+fBVYRcnKLYlTmvtzWU+mX6jgbnmAK1bmeHf4k69AjVGmOgA+LC7EQ7A
iqSSQcJyH46zRB9pG+sKPbXw/5KL7J6SH0TXH6eKumth6NtvtVQlgX483O4IPGFL
It2Im/05MkwBio1x0YEYMbA0NCEH83eAOm7Jhy+PIDnnLPV4rc/wM5ErEay1z4dk
fM14PTzdkcjWT+NQF9faQzuxuH2AOSVurPT5YLRsLUrNg6hBG9THjZ0G4KU/YmwH
Cmm/dcYBWVQJ665cuAfwS7tNFwmz3IpeoElujMLsl+yNP62HO+E6O5gxpz506Rjc
S5/7uISrgpuyAmb1cQV4ZOtk19JlNu/bFBqe8bO7mfhetmKFp5UcvCpcp6zr/wdf
rFZaemf1w1E7o/yTsJwkKCc4ANgJvrk14uwYY4R8ajXT42O/Z0tlw6KQrB/7pe7D
IT9VAjQYNiViqphU1I+4QE63yhr5H9oOgXSyAciVfelEGDUc92DafKJpB8UxbJ4t
OQ47kP2jhxyx89uFTRh2
=OTUg
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
