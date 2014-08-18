Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaHRPZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:25:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47074 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaHRPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:24:59 -0400
Date: Mon, 18 Aug 2014 10:23:24 -0500
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140818152324.GG14537@sirena.org.uk>
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>
 <1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DEfZqDS1MPR2ysog"
Content-Disposition: inline
In-Reply-To: <1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DEfZqDS1MPR2ysog
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 10:32:41AM +0200, Javier Martinez Canillas wrote:
> The MAX77802 PMIC has 10 high-efficiency Buck and 32 Low-dropout
> (LDO) regulators. This patch adds support for all these regulators
> found on the MAX77802 PMIC and is based on a driver added by Simon
> Glass to the Chrome OS kernel 3.8 tree.

Applied, thanks.

--DEfZqDS1MPR2ysog
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8hppAAoJELSic+t+oim96cIP/2zWdpAoNYDihCEHTRBmCpOg
Bbz0LU5y/CpTrtF8fy6ADVf3c39/c0a7JNdxyUF/VKLtMk9TCw+WnNJ16R+eX+zv
vqSF+2Vw5dtiEZK7LpygihvTf9IG/iduJoh/dpDT1abAxfDNNz+rduscH4NEnTPi
IZVk1Hrdyw6MxMEfTp32x5wUSt5QniwpShHphSuGIU9BT1w7YrXw+VzQfJjL1/hw
XxHfLJgBHovTfTKhuo/p4TmSRoo4yjSu2PV11dlLyTFLO2kZL8DzmwgEgr4DhqTT
o9gNB2d93NJ1LXw93Nvw2UpNhoC3pjrbc19yNBpmzfLBtHlqErshpSHoo2ysvzO0
35ob+xaSqDIffCrQCj1go+DGnv0Iba74bH8UyBv25yQ9I1X8eA+CfxTqyjCWB4WU
o6tY9ogZfV51kLIbJtZLuBEiQJxxuwP0ELLfv+jUjPGt0KmIGPL3U4OcsvLerDuC
lWhUZhYI/jmxerOcuKzgIrTD2ouUqzwcALvjrZ1RfGntsARTF4RJQK9bun+rWfFq
Fdzkyx/KmAhpzqIhsZX+fZWwuXzsiK2cKGnxcFEDG8KjIDPgj8QAvU/LJyQ8je6k
JgH7pkoJRxO5mnr9Q/A0av0s7K+kUVf4+8aA56TRZOZSwCQ2UYHR+1HkmNLDny62
rWDrd13LSsiQAykU9cmG
=oKYr
-----END PGP SIGNATURE-----

--DEfZqDS1MPR2ysog--
