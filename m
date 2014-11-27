Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaK0NDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:03:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40821 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaK0NDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:03:02 -0500
Date: Thu, 27 Nov 2014 13:00:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141127130053.GW7712@sirena.org.uk>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mv22/3EYgOJmG2Gb"
Content-Disposition: inline
In-Reply-To: <1417088636-11994-3-git-send-email-lee.jones@linaro.org>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] spi: st: Provide Device Tree binding documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mv22/3EYgOJmG2Gb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 11:43:54AM +0000, Lee Jones wrote:

> +Required properties:
> +- compatible	: "st,comms-ssc-spi" or "st,comms-ssc4-spi"

What do the two different compatible strings mean (for example, should
ssc4 be used for version 4 and higher or is it just a quirk for that
version)?

--mv22/3EYgOJmG2Gb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdyCFAAoJECTWi3JdVIfQyZkH/jf2ZF5qoC1l32gbd1cJ69YV
k/Gne/q1Idfy43qupB73e5HonqJ4e448EImpxQSJ38TcY7xuaP3KE1zsRCY8c6VF
ai7x4si1ejQ8pzqncY+BpjcP8sR9y8oHPOEHcYPFL+myfUHxJvLFVYRNXH8EM0hK
AAKF1qHqq/sAhyiRDa1lRICW0fcO+8s4DOu451GrqUEdixxUn4Uf/P59FKm1587r
R4IUFfN7RMRd6R0jc+0YxLFC8FH2bc9pz2SVN28W8QaRGzJ9CYGfu9QyOGlxrUJt
8Zd7PV8mVRccAvbVuD/1XfXpIFRexipJKPMpbNz32UasNJM49Bw9U/AwgC9B428=
=gWma
-----END PGP SIGNATURE-----

--mv22/3EYgOJmG2Gb--
