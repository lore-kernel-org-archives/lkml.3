Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3EJK4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:56:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39857 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3EJK4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:56:41 -0400
Date: Fri, 10 May 2013 11:55:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Barry Song <baohua.song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Message-ID: <20130510105545.GO3200@sirena.org.uk>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0UhZIN3Sa23/ILEd"
Content-Disposition: inline
In-Reply-To: <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 23/42] drivers/spi: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0UhZIN3Sa23/ILEd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 10, 2013 at 10:17:08AM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--0UhZIN3Sa23/ILEd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjNIuAAoJELSic+t+oim9EeAP/3F5K6xUKoR1bkGZRU/CHceB
yG7qHKrgOSNrzkSa7HR/KlahfszLl8BQ9dCo2CzAEWhpxmbzDtX7Ift3CDG+sI9W
WxKNxOib39VRHYE2CkbXHAabX/cUWA498zxfMAfkRJzPnLDakkqhq8Vnk8JDDwzq
cjedISrRRtwIzQLea/dr0l3Ad2ipkI55GJScwv7BGunglTLg4mhoT+w32WqPXC4u
yTo5r79o2qfF2UkU6o3XJkoWG8Kblr26HAEPRMPwmeVzqjLrNiFT6BhdRVW6nvEq
KEobD06ZQ6AKrcs4/GZoVN2aAz288vRZLSEOiFVMPA0nQyNa6sEW88DBhhke3LVj
zzfTiy+0AU0yaJd8Qxxgg8H2Ps4N0C9f+o9YFABWyt0SHKXPldSg6mfIoYyvcKEj
fRa/k1l2cHaYaFdwPRm8MjjKgRO5Pcrsl4kp/idIwLTQHxr3VztDyeDpwzeeRMZ3
X2VsjlBlkw+kmlD1BR2FffsaXaJ6QM/YREju97Zzw5A/WrwY5w1AXJo7gTy+R7Vt
9x79t/3Vr6yujHwfKSnj3pvfbch5Do8RTjXocji3vTxP8KyYvC+sFGYKLTDxwhaB
pXSC6DIgWxr+uUmiqYJ/UkS16WfgTPrGNNsPQ4MXGL7B8J29D9agEtoqNXDGa82X
BUEfIfHkMPsyK/ct6wDs
=kFrz
-----END PGP SIGNATURE-----

--0UhZIN3Sa23/ILEd--
