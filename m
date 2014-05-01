Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaEADbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:31:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53502 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEADbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:31:20 -0400
Date: Wed, 30 Apr 2014 20:30:57 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20140501033057.GO3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-4-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-4-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/15] ASoC: SMDK_WM8580_PCM needs REGMAP_I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--keoAwTxaagou87Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:24PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> This adds a missing dependency for SND_SOC_SMDK_WM8580_PCM to
> require REGMAP_I2C to be enabled, avoiding possible build
> erorrs.

Applied, thanks.  As well as the Cc list thing please try to use subject
lines matching the style for the subsystem.

--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYb/uAAoJELSic+t+oim93dQP/jaG+r4u8Om/bXfJh4Aom1xl
DsW8KK7WeeyQcUs+iE17kNI6StMMmaSYwtwaleSC140ajC0w5wMdUl72w5bGdQGr
KvXcGpfczZbVa7MdghnHGoLJWyndhKuKhoDSnpUnl4hLR77DwoVDjAr1dLgbdjhu
4nyMr09gYUOtUTbdKCYPjIhcYuMcgS/NBTzMOFIZOxJA3Xc2gEGsPkTE5WJ9LSN2
lUPgxrMiWIhEaosbzMg7ldX+cdOUtNzd8sT7djv0dnlZ8CKSaPHJgFcSwl4jbfEf
5seJLwoO5sg8zAMIuM8YHp3LhYpUhaedZZC+siz69RjhHvbRveleL4gbSzttEwE4
8ambjdU9+mkZon0kG5dD6RQjfEOg1uCtsFcr/+ADHS9uktCeNWAk3MCr3qIKSXK5
8Akowpq/Hhq70frkOgIyRpsd1oCIc/vJ3TC5X60gx9WKDUkUj+Jj6RgqyGPd4sqF
L5othwdqRlOrYk+JzLjziBm2uds3KjKcNLuVipIxv99KJelw4Mu8II6vwfMs0SMK
1SRfR0o+72tqqoXDB5t+H0OWFQiadz+z6VudQHCdiYssfVnCKdS63HnzgjWCCwyU
RfI4hedpXeWwcLy+lJTo5l13eYu6pj6i7BXx6ewrQo1IdXGc2UhxkviGBWG+SiSY
HtS9hYYNnIvtJXj6f6Ze
=RfTx
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
