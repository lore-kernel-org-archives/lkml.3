Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaKJTFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:05:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57626 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaKJTFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:05:17 -0500
Date: Mon, 10 Nov 2014 19:04:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, cw00.choi@samsung.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141110190403.GH3815@sirena.org.uk>
References: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
 <1415603987-32475-3-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="inJ2Z4oiSrNaWWYu"
Content-Disposition: inline
In-Reply-To: <1415603987-32475-3-git-send-email-beomho.seo@samsung.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] regulator: rt5033: Add RT5033 Regulator device
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--inJ2Z4oiSrNaWWYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 04:19:44PM +0900, Beomho Seo wrote:
> This patch add device driver of Richtek RT5033 PMIC.
> The driver support multiple regulator like LDO and synchronous Buck.
> The integrated synchronous buck converter is designed to provide 0.6 A
> application with high efficiency. Two LDOs are integrated. One safe LDO is
> for 60mA and the other one LDO is for 150 mA.

I'm missing all the other patches in this series...

--inJ2Z4oiSrNaWWYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYQwiAAoJECTWi3JdVIfQSlgH/AqqlkSGfWEO1tS+I28W9i/Y
HN/zL6+FjNHA/qNeNyvjxGuezLKymEnwiFpKWatvYWOu+7N+7SJSgY8CU72NsqR/
/I9ZwxCb9anwANFANdh0oLzSBubKWYx359MSgYGPW6ume35J2ZVwgjndjSmbQjQv
8cWH6gyQukU4+7NXizz9UwTk+GZRTJOZKffwUsQQOlCQjqo2b+x2oAk+OOr8hdFm
kaJ23hqezfTlK4m7qAigcr+cxYFVqtX3qAMRbKGbBNWt7uQB1+AmhrDtxThiq7cz
qg5iJxKraiGd67SxlGb1w4wQQHZUqMY9AFKpWhEBaOgZwqCe6KAxpQTpsWkTtfw=
=9fdp
-----END PGP SIGNATURE-----

--inJ2Z4oiSrNaWWYu--
