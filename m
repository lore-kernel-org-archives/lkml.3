Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbbAOBBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:01:51 -0500
Received: from mail.kernel.org ([198.145.29.136]:46377 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbbAOBBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:01:47 -0500
Date: Thu, 15 Jan 2015 02:01:34 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, lee.jone@linaro.org, broonie@kernel.org,
        dbaryshkov@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 1/3] power: rt5033_battery: Add RT5033 Fuel gauge
 device driver
Message-ID: <20150115010134.GB20141@earth.universe>
References: <1420793114-20586-1-git-send-email-beomho.seo@samsung.com>
 <1420793114-20586-2-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1420793114-20586-2-git-send-email-beomho.seo@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Jan 09, 2015 at 05:45:11PM +0900, Beomho Seo wrote:
> This patch adds device driver of Richtek PMIC.
> The driver support battery fuel gange. Fuel gauge calculates and determines the
> battery state of charge(SOC) according to battery open circuit voltage(OCV).
> Also, this driver provides battery average voltage, voltage and bettery present
> property.

Thanks, applied:

http://git.infradead.org/battery-2.6.git/commit/3cfb56d7ff013762a17b6a1b78bb3b0e4a6a6588

-- Sebastian

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUtxFuAAoJENju1/PIO/qaRsYP/0aeGZE1rBRba2Bknvr8zYLJ
aThRVS21wC+yYdjEAU1gTMvGG+iKjM4hZvVRrWbADXSTrXQkgdxTvcHReLkjoTL4
nsvCZ+5As4NkUVSx2MbeqCvFiW3YXCZBX6Uup8rtMnt5tIhkb434Fu/xKzvj2pUS
b9qbraDGaYd0vNHiH7L2XX2zf5rBT3vwWITwgxsyCJoPkwBVAPFugTJ8aYwTc4ji
xmTN3Gj9MtLacj8TjEhYiSYIs5u917ghdTQjyxVt7cNktvn3TrH/pA9RVOzNsuw+
HHD9S7TZ+s+0FrPoEton1LGYb52UZ1HdSEgBsdaVEkEJ69fDnL4qBX2Duxg22SB0
HCGSKJvFp6zUsNs5BhAm5jQboErJzSB3D8T5IAgaq2qXXbi9AQTeI7B8o7FzovtR
exisPArq9bLjfzptqLU5ZMsuDLy4CCgvILS2N64dpqROYUTtmrIwFmJAqsBMRrjT
H/f2FUc/wz+R9OsiQB/XVjYlsNUt4vahPjO8gVSa0IaBq3ixSK3EKi+rmwy8t9JZ
9alDfcQEhcbcqtD6b6NPwmCpQO1bpY1q/xSJ7god3KUJcI6r7tXcTnE8SLyl53HK
N702P5Gf599AKSxG2AEkkGlkHWGYGnfBkQvRmE7qmQV0npIVdty6lTklnmsZeebE
DjQnmWVh/XVCIAJJr+DJ
=K3c+
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
