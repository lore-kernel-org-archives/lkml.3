Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaDCVCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:02:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50923 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaDCVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:02:03 -0400
Date: Thu, 3 Apr 2014 22:01:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, michal.simek@xilinx.com, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, harinik@xilinx.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Message-ID: <20140403210135.GX14763@sirena.org.uk>
References: <ee057d8c-50d9-4d4b-ac86-d7c5fc44b1b0@TX2EHSMHS034.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LvnU4bbuCGLV8PtK"
Content-Disposition: inline
In-Reply-To: <ee057d8c-50d9-4d4b-ac86-d7c5fc44b1b0@TX2EHSMHS034.ehs.local>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] devicetree: Add devicetree bindings documentation
 for Zynq Quad SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LvnU4bbuCGLV8PtK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 10:33:06PM +0530, Punnaiah Choudary Kalluri wrote:

> +Optional properties:
> +- num-cs		: Number of chip selects used.

What does this translate into?

> +		num-cs = /bits/ 16 <1>;

Why the odd specification in the example - why not just specify it as a
number?

--LvnU4bbuCGLV8PtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPcwsAAoJELSic+t+oim93CoP/1PVC5uFm8g2siiedwBT/i6/
bxn9DwUFSjSfKJw17ChAec0HEczUq/VEM4b43aMQmgpOvfHtXaHLOvQQlF6naPp4
nBq7qG2zBEm0EnWnVXKonhVfbEvt1Dlf/SwuIfJNBZFZilFB13hHJaNC9twVaNdq
FxLHYBNvHv4i5gHJWtIue6f31HnVQptamx7KrOr+2eg/DAy2qBUdO4jUzZdOwBWu
o48997SECtfbhZ+FbUsmcNLSK4ClqiaiwCDA5712iNJV41UW3SlHgEsdr1AEnvVH
YPFslDOwE0VUH8ZhTLxRijToYFBhzQU0vk7m6VkrU1pKFIO1f1C59+03IOgEgcfA
AoDjs33c+/PKRuB92n8BckzZL8q3gYO+ugUqvNOQYId+HYKEv90SKlSkE/tkVgMQ
AkY+ke+DxjmfTUOMdpTG0fM+rhnJkTCwpSC5dGtk/STlK+Z8rU6wp43ZH0YFJ++Q
BvVxpwKNzL10ZltYzB8qbQR5cldAs1vyY45JlPDeXRzpFJpu1NcXaRtqMfM8y0ML
ZXBl9ZhHQ4tYsleKVclv3E3JZL2Id7gzJPrIHIPDt0gQAk3HaeLe6sKJndMpvaFE
sb3EEec4Wd4rLOZH3K5oi40WbVNWjC/87i4Vp2MptWoA8UOU9n9b2FYN4l46yTWh
SgqEGvfCx7mS7f+amF1s
=eYZ1
-----END PGP SIGNATURE-----

--LvnU4bbuCGLV8PtK--
