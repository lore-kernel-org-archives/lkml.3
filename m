Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaDWKnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:43:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaDWKnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:43:47 -0400
Date: Wed, 23 Apr 2014 11:43:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, rdunlap@infradead.org, robh+dt@kernel.org
Message-ID: <20140423104333.GN12304@sirena.org.uk>
References: <1398244438-2124-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qPW0hKhZJZq3D5UJ"
Content-Disposition: inline
In-Reply-To: <1398244438-2124-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: max98095: Add an explicit of_match_table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qPW0hKhZJZq3D5UJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 02:43:58PM +0530, Tushar Behera wrote:
> Create an explicit of_match_table entry for MAX98095 codec. Also
> add a binding Documentation for this compatible string.

Applied, thanks.

--qPW0hKhZJZq3D5UJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV5lRAAoJELSic+t+oim9fhEP/A5UBDatDCOnruQM7cVu8ftQ
oya/NEwgMypJkkNLYaEm7HZilLl3XTv3QVYXWe2t43pcRAOP2o8Vqsm1x14QyEvi
95xk6FEWxJ+YJGb5O87zeBPvOP2eIsiYX8n/uFSsqnC16Z3ql4mLI4kGT/5JGYeB
/ymuPJUW0f2iUYBToKo785zQW7aVuyM41eJTGLZ2Ba7f/fy/3HI9edgfViOID4iz
ubopCzxBNC4iHVGMMKU2zE3LRikCYZGoLMe8hlC+2prUNhFghL0MjdM8ptasB6ZY
8clovvjS+HAjS2RyIF5Tk414QbXql1y8eaLLK23rSlAt1yB3aZy+cYLj5D5XsDx7
N7nID6J51kpeWUxe6pX7Y9IaJYHGVOr0GNr6NMe4ji6yLvHm00llG5D+cBCQuO2Z
qakTJst1y0aIZs//mLdVB7RCRo37SP7+WuHiLd8a174TlABVgZ1xItFIPAg+zjxx
Tw5gIiamiRTqJhvWU0vHSZc/mgav2AqmYuU+xdigRH8BF3xj+rk/lx9NAdq0Svf7
nzfn2p9PmJneP0yaiz1bhpLkvpJsVV1KVQk/iqMw95W3Ubk4yOzBJKKjDWzqMYjQ
peDZmz63wvnQo/B6I+wjMtLThV8TaV6yLrxf1eZpaVx3sD3e0REHQ44AxdbuhaF+
1qCmsPg0lK/+P85EGMvE
=usOF
-----END PGP SIGNATURE-----

--qPW0hKhZJZq3D5UJ--
