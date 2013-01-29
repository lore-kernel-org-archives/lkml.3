Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3A2BjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:39:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51758 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab3A2BjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:39:13 -0500
Date: Tue, 29 Jan 2013 09:39:01 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: spi: Support asynchronous I/O for SPI
Message-ID: <20130129013858.GA4748@opensource.wolfsonmicro.com>
References: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5106D3CA.4030203@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <5106D3CA.4030203@codeaurora.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 28, 2013 at 11:38:50AM -0800, Stephen Boyd wrote:
> On 01/27/13 06:12, Mark Brown wrote:

> > +static int regmap_spi_async_write(void *context,
> > +				  const void *reg, size_t reg_len,
> > +				  const void *val, size_t val_len,
> > +				  struct regmap_async *a)
> > +{
> > +	struct regmap_async_spi *async = (void *)a;

> Can you use container_of() here?

We could but I tend not to if the interface strictly requires that the
pointers be type punnable.

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBygrAAoJELSic+t+oim92KIP+gMNdu0FTBGqJlHilwKTQzC9
xmkW36htcnjGjGUGDY4U2eOgotF+uTnbuK3Z4VSOFhId3L3MrNNHHQi7UeM28LJJ
rp3rScetY18azgs45MWFR3MDg85haDJB5c7GXFu/vvdluYDgGHfTNpV2Xf3/VCLS
mVFi1ImWFpV4FLnFTV+ZGXnGId7wwYrmqDSnq0KoENPo4l8UB8ES3A7yyAUETRCW
6hI0GRu2ZR2VYVNB1sDEaE2RlOE1nmWsZ49bQ8KdLsndjgdSxKtsMLz9/zaoxcDu
LV8twI9dU6gtI7zaEy3Z5bHzt3BoweDI1mNVa5aXZHwlewH+66sq3KgNOLeYhLAf
bKRPYbskBYAo8b6zDvFtMGmcr3yy6rtUIqMYT70nOf5T9gdkb+xCHW95vxAGgd3N
nWVKsKPHPT1TKKXve+4eDrzv05GWKztrCVUsoHM84FSyw1jvHRhQf/5h7AmZXcbM
VKbrHxg0FEhtbdBFfnPieFlBMa2V0nBVciqVK2z1PSCH8PgoXpIJuE2xIk/hrLmp
haz7haQP0JfJHsQH1UrgrjRCRMCbEnDYqBgiL2D13m2Puqwn0CUoOaGMft5ZqOug
IzvcS5l0N/s8/TFjlCFTHSaQN55zwQOV2m5Fu19inzmae6M5d5paXO5TK4gytGbU
L6nSY1Ii4EBaT4ZXDJS4
=Al2i
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
