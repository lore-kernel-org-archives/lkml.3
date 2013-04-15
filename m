Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3DOLQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:16:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43399 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab3DOLQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:16:01 -0400
Date: Mon, 15 Apr 2013 12:15:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Vasut <marex@denx.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] UCB1400: Pass ucb1400-gpio data through ac97 bus
Message-ID: <20130415111533.GB15837@opensource.wolfsonmicro.com>
References: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com>
 <1365964548-4193-1-git-send-email-marex@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <1365964548-4193-1-git-send-email-marex@denx.de>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 14, 2013 at 08:35:48PM +0200, Marek Vasut wrote:
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

it may be a bit ugly but it's still an improvement :)

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRa+FLAAoJELSic+t+oim97vcP/17nSYfTG5zxsF8KVMDXpbEo
XkCpLS1UKqmSPLaUkAcE3yhtDQ3CJnbQwDvz3+lYSsDqrBjyGd3AYiX+FjeVjk9L
zFrPhMo0szDYKfA04e7psy9UX8X36v891wMJZTNwp6qD4DcjxV2iz9brM5T3Pzil
dMxPJCCrJSewVDDrqKbGgWE2wNJU1zXfeUgkRp/v7TS8IKJ10k0uGroZ9QI48zqY
m0km8M7D6iswah4gjhAM38SdUed8nXaJ1/YJA2QDKZz+uk75n8NpuQee8VSz+qOY
FWIbh1RLRP4h6rrankKnf64sHOiLG76fwF9MRGUtIFvDPKheu7XkGMkEZW4kwj+p
s8/TFsluGugHLAfLGYBWPm8aoMbBOK8aXN8frgLLHKU1Ky/KT9H55MtbVlEtVpno
uXG+5AOIhlUJpNYUksZF0KL+agr0kYUfhZzMZHhynxOM6gLaUAjKpcXeMMKdLewF
An3B+Ek827aYOGinOpYmn4jsVQ9JC27PlT5yIUGTNfi6Tgz2CMDEpIQGQqYAmogw
iW6vNMzS8RCE2nv2eOQZaooG+kPc8JcMmEK4C7E205GEQwoPF+E0eGXmuaF+8sdB
kpQEfaKBpoS2ZUbEorhCB4IvUAb5wvvjfhSn+nC6n6chGETWDYt9Hy988lRHTUyi
cHxw0j4n/USjoKl8obmh
=XMk/
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
