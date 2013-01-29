Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3A2D6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:58:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53042 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3A2D6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:58:43 -0500
Date: Tue, 29 Jan 2013 11:58:33 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: spi: Support asynchronous I/O for SPI
Message-ID: <20130129035830.GD6878@opensource.wolfsonmicro.com>
References: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5106D3CA.4030203@codeaurora.org>
 <20130129013858.GA4748@opensource.wolfsonmicro.com>
 <51072A38.6090505@codeaurora.org>
 <20130129015411.GD4748@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
Content-Disposition: inline
In-Reply-To: <20130129015411.GD4748@opensource.wolfsonmicro.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 29, 2013 at 09:54:11AM +0800, Mark Brown wrote:

> It would break anyway, like I say the interface relies on it currently.
> The other option is to do a callback into the bus code and return the
> contained structure but it seemed more involved and this is fairly
> idiomatic.

Actually I'll just do that, we have to provide the size to the core
anyway.  Thanks.

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB0jfAAoJELSic+t+oim9AX0P/Aztbl3I40uyjT0JTaYb7s47
P3M/1XO+nFqP8toDVBWLKbH5hZ0wtqubQU8Kwybfo2/tMl1yGKv2QZvH2FvtaMbz
rp62o0x7+yCaOVvw2YnucXdv7PtvwLrF9if3wcFOmRpNbGNqeLYQxQDJUm22lzpj
enQVcw8Jlr4cYLfJbllMa218+8+Igysfyc/H8T5QAGSAniXVvPPVc3zvpyeMc203
aRFktXz1//rSzsmsY4Yx5Sd4tGzpPceEW5Eh94NkHRiUtxIsYG5Cp5ppOYI4lb8h
xeg36YMkvdjVjafBat4n30Ycqb9uc9jp7UEQAUC9U6fZXPtKqe91W1rS+HxFwB9P
5EaspuSpW77UkBXjfzpBFPaj+EagCnb1+buEh7fakkk/uIm474jDKq9NY4CFdc6t
oxt2uz5WnLcEfFjggk+7o5DgsZQiR0E1JEgFWF1BFYUev5mHDofbUNuXxDGCwvLd
93RZ7c6V9eiZDjUcCBkvEzaZVf+aWgfpmBFh/GF1Ra5KP3VJXP5ZJDKIWm82hMoF
FcBk/td7nKwBuhFO9ssoBt6eJGavwMfaBs2ZDo8i9ed/dD58Bn8ObG+6Wz0xJLIA
UGC3DQ620ynlBSJC+XZp/LzE5mVmSfHMX7VC9jGhtP5O7W6y1hGts/MovL1LzBMx
88E9M4VnK1BDJaCSVsrC
=dy/u
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
