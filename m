Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946315Ab3BHLfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:35:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946244Ab3BHLfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:35:02 -0500
Date: Fri, 8 Feb 2013 11:35:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: debugfs: Optimize seeking within blocks of
 registers
Message-ID: <20130208113500.GP8879@opensource.wolfsonmicro.com>
References: <1360237232-2220-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FbmEh7Ek6NM6xKh/"
Content-Disposition: inline
In-Reply-To: <1360237232-2220-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FbmEh7Ek6NM6xKh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 07, 2013 at 11:40:32AM +0000, Dimitris Papastamos wrote:
> Optimize this so that we can better guess where to start scanning
> from.  We know the length of the register field format, therefore
> given the file pointer position align to the nearest register
> field and scan from there onwards.  We round down in this calculation
> and we let the rest of the code figure out where to start scanning
> from.

This doesn't apply against -next.

--FbmEh7Ek6NM6xKh/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOLWAAoJELSic+t+oim9X6MP/ij0WxrsuHSFm0OF5xvNJZUY
VTQuCeinarxgkzsAuo2Yso0kWW2aka2oQTcsVwwI32rZe12Ik3pWA+ReevtLxSdt
fv32UlRpSecCkiM/cJHBXcrjPnw5g9Lpcz0BAkHLzvRsxnZaX1rKxlmWBY2eCqVz
At5Kh4u0geqlqWn9NZvHeksaJUtzIhavi3K2qBuWDy4dO+Jjeu85iZRPwyt3QnMD
NE8H4jvpQ54pVe4iB5oKPW+s62/zBG4SPh/BP0W557JSIj7loT1yEsL7bIdQzGTE
K9qj0eoZy2etL0lvu1N2FNIhjiFBbOmpypWT9nAPz26NfSD5tlrr+eqlqtC8p0jd
bftKD5Lck3n7paOmB3fMH9WKPLcyocKTtcKYRsw0Yx3ZGert2xDi8qCN6kvZUEZZ
V3LuHQuyMfxBIJjognxpPIJ37Y64TCwVpoTf3SCKhbyZLhmNnaxuZRVSToosH0DT
Vjn/PhyFoNL6RiO8W6SUJSF8/ls1GXufAtOzfa9LtElT/C1kwqTTWFe0KqkqDMa9
iG43FLgaHYsjKL06bPNL4oS6E3dVmHmP8//ucFVF8AqndOBtu/5ndC5T5isRc5Ga
uo7cX26IuNvyQwGPLxE8XSF3dP/CAVUP1ZFAOLljhx6q7KfF3hAxdZontPGzPR+E
aXtUIotjOvB6rMNU3lQd
=F6Fl
-----END PGP SIGNATURE-----

--FbmEh7Ek6NM6xKh/--
