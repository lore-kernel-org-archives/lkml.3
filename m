Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaHFK7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:59:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49298 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaHFK7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:59:48 -0400
Date: Wed, 6 Aug 2014 11:59:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140806105915.GH17528@sirena.org.uk>
References: <1406728440-17837-1-git-send-email-ldewangan@nvidia.com>
 <1406728440-17837-2-git-send-email-ldewangan@nvidia.com>
 <20140730155302.GE20162@leverpostej>
 <20140730164014.GY17528@sirena.org.uk>
 <53E1DA60.9010401@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bri7I4a0+3PvYu+W"
Content-Disposition: inline
In-Reply-To: <53E1DA60.9010401@nvidia.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: userspace-consumer: add DT binding details
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bri7I4a0+3PvYu+W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 01:03:52PM +0530, Laxman Dewangan wrote:
> On Wednesday 30 July 2014 10:10 PM, Mark Brown wrote:

> >Yes, this is test code - it is not intended to be used in production.
> >Any binding should be for the consumer using this, not for this
> >implementation detail.

> We have the GPS module and its driver in the user space. There is no code
> for GPS on kernel. Just power on and open port from user space, get the
> information.

That's an implementation detail of how you've provided this on Linux.

> On this case, how do we power on GPS module if we don't expose it? It need
> two power source for digital section and analog section.

Describe the hardware in the device tree and then bind what's needed to
that.

--bri7I4a0+3PvYu+W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4gqAAAoJELSic+t+oim9GBUP/36qXTTi8U7wxXG6jm5UmmRS
JlxpeOikt/TMs/OJXffB7u8LMMAhdGdb1V01ANBcNAqCfFqVTs5KUE5e7AH8cc5f
donSAVprv2HTpaym3AXljFwVpYkO/OZQEcsZeKVh90rwbTsU/YcFoewMDTuqiDdE
IjPwG7JF0cD9PHXeGNYIk419Mh4xCZZW1LI80v6qyXLXOCP0h5zXUXhcA0EgFxHj
gGOdo3g7w7L7iCWu2X6EUxhk9SEyGbm+62DgpcLLFQRRWyiNLYuyza4eEznUqBe4
yZzp3pFyddMuyBqKf823Lr5AtjNuVDnZd53Ri91j07T4YbyDcrCiU+TZRB7bgNK+
5x1mQDJOtXs3ae6PBmMW1SianfT/fX3dOrcCvyuWMpAZIEkjUP8u7SfFexgckdoC
hjZkkgVcyuxmvm1k2agHHkAbOrv+t1SgpkuPAN3p8HRlUwiRBTD3qmiR/yt5S+6F
kGB4OnRm8GZpLna1FBPgtkFZNd0MEGOekQ675v6wIzvUbwwAbgLeAqaZ7hY7jH2M
8S0J2GdYmUlCI7iefWOjREVNn2cciQDa6pMh2M46mY7HXTHa6iMYrNoYkPdu6WZt
uo36hgp+hb0amFEzMYuPRDdRbesWCZ8Kb7juSElAbpuSWHA1GhkxGryEdaFqd9aR
PDDjDaO1qE/MSO9zGR8t
=Zm+l
-----END PGP SIGNATURE-----

--bri7I4a0+3PvYu+W--
