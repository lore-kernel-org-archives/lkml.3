Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbaDBTwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:52:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50468 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbaDBTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:52:28 -0400
Date: Wed, 2 Apr 2014 20:52:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org, rob@landley.net,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org
Message-ID: <20140402195208.GM14763@sirena.org.uk>
References: <1396352049-23554-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L/bWm/e7/ricERqM"
Content-Disposition: inline
In-Reply-To: <1396352049-23554-1-git-send-email-Guangyu.Chen@freescale.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add imx6sx platform support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L/bWm/e7/ricERqM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 01, 2014 at 07:34:09PM +0800, Nicolin Chen wrote:
> The next coming i.MX6 Solo X SoC also contains SAI module while we use
> imp_pcm_init() for i.MX platform.

I've applied this, though obviously it'd be better if we had dmaengine
support for this SoC so that it was just a compatible string update and
didn't require any code.

--L/bWm/e7/ricERqM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPGplAAoJELSic+t+oim9WMoP/jw3mYBYR71+bc4LxmhDmoXB
ZyGam2gLtQ10yNOR/EuH9yKVXS84kw2ixKSC3fUSrlxzpK2KZgei6HvI1jHza2bU
lbJ2UP5/YgxOAqdwBPLhED100mgSkTbqyZN0YwvzimRfI39VQhKip2EmZ9CASFWt
td6DydrruAQTwceiu3gyrbQ+K/2PvwNOjRHR7eRplYyM7BpJXRfYrBuy/5EhbJNJ
X1lZ6tMrIt/ILbHw/3cWS3J+nfKdevY2IUOtipUekj6jO8PeK4VdqT7oXGg1qUvT
A6IlMLiERc0Y5H6zlP6RA2MKShbh/6qfuJqvJ3pvwD4HnKWgmEIMgGpEmrzUtLRV
SwYP+L7j7diZJNkD2T3EtlfSXaJzoEHiVEHZeV1vqgiq6E5YY2D/dJZPl2s5Y7vZ
E5c7s0IOvH0Dr5YbJ9cvU5oQbu13mBTJ/eitqSWzQwR5/rjpi8b27SRBzgovAGzZ
UIbKP0hpTLHU0c1M26twq5OTIPlBBeuNZjjcKeCPC5hg3PuvLvPNSa9d1W1icFl1
/LWv5WYiB3OLFdzhQThZk1RMjjCAdQFusOBS7wUqGlPkolr7GVUz+TGLzFYxnpbM
28o17R2LOjA6CfiQenkuz7kubgSAKI7LKTjyc/aV2xAMAIrO0sbOXWjUczVcrHic
l+yze0UTzoGYtvc3ipr2
=5s9g
-----END PGP SIGNATURE-----

--L/bWm/e7/ricERqM--
