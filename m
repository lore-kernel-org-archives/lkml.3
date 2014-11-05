Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKES22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:28:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43030 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKES2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:28:25 -0500
Date: Wed, 5 Nov 2014 12:28:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH 0/4] extcon: gpio: add DT support
Message-ID: <20141105182854.GB6548@saruman>
Reply-To: <balbi@ti.com>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <54586E34.6090602@ti.com>
 <20141104144116.GB24983@saruman>
 <545A415D.1070002@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <545A415D.1070002@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 08:55:17PM +0530, George Cherian wrote:
>=20
> On 11/04/2014 08:11 PM, Felipe Balbi wrote:
> >On Tue, Nov 04, 2014 at 11:42:04AM +0530, George Cherian wrote:
> >>Hi Felipe et al.
> >>
> >>Another series was posted by removing the platform support.
> >>https://lkml.org/lkml/2014/10/14/244
> >>
> >>I guess I forgot to copy linux-omap.
> >you do too many things in patch one. I wonder why you decided to combine
> >three patches in one for that series.
> Since there are no platform users for this driver. I am basically removing
> the whole platform data part
> from the driver. That is the reason i squashed 1 to 3 of the previous
> series.
> I will resend the new series copying linux-omap now.

It doesn't make sense, however, to switch over to gpio descs, remove
platform_data and add DT support all in one go.

--=20
balbi

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWmxmAAoJEIaOsuA1yqREySMP/ROKfiewa95pM+cgBUziWm8k
MMbLJQFBKS/gJJHuHnXswHshEY12oQWlMEm+UIYJv++WM5H+CdAwNFga+WS2JnP5
npsZ8A0scybVLrNRlg5QbdNs0vXkHqyxBOd2SgvsR9ffOteRgIlSe+F6p+dPaPyf
ss1BTPjyY8Ksbw0cYaBnf6Rddw7SiGK0MErAI7rpTBwdEmqin9ICdFgWQ0Y+5Qud
IcXFAejitLG4Q1IgtDgHncOtz5x500kCM0MSWiUvPAAxfh0+6fEvmE8ca79kpdBE
AZCGXAxm1dd+JIfIeZXuPBrmvteB3LNDQRYQlypTpeNY/PQzBCMXXxhFkn+83yP7
6t4ZSEQLniy8jrzaUr8+yA7gkW5LmuzncCkPJe2p3+leRQlKL/bgdsMZXCH9mkNN
X1lMUOQZtaVk7nJGj/6oCt6vfgOh2t9JVO3FcfxcaMdU70fDqfOnjPqZVKr6/Wk1
ftxafahSGgW/hEIheo7knf8vtWXA/pnxdC9/Il1kXoWSudJvWKjaYtrwvdRPzEDZ
5OIpKc31hL6Xr9ojBnRjGxpIP4QOWMP36FZfZT9smIo+ATyBZ7E882QKqpOebmeB
vWlTu49DI2rSAXDG8utWx+LYQW7smOheR44G+5dw4OpgzhlY311LZoO4xB/ZOyH2
pPqLHJySuQ2ude7pvNso
=/gSi
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
