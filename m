Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644Ab3IDJtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:49:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35776 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934469Ab3IDJte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:49:34 -0400
Date: Wed, 4 Sep 2013 10:49:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, nm@ti.com, ldewangan@nvidia.com,
        gg@slimlogic.co.uk, yong.shen@linaro.org, s.hauer@pengutronix.de,
        marek.vasut@gmail.com, Nancy.Chen@freescale.com
Message-ID: <20130904094930.GQ3084@sirena.org.uk>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/rMgauiyHIRVABE"
Content-Disposition: inline
In-Reply-To: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/7] regulator: anatop-regulator: Use
 devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/rMgauiyHIRVABE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 12:00:57PM +0530, Sachin Kamat wrote:
> devm_* simplifies the code.

Applied all, thanks.

--J/rMgauiyHIRVABE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJwInAAoJELSic+t+oim9dbQP/0qJ2u698omlsWJPM1bwgMhf
shuounkrzP+IkAPXR5L6ArfPTQjpmZAPirdDLhUYbaje30OvF6ihrzkQ3qzpl+kb
7DpDs/iX1lOmzeZmfxC+qVn4fHzeE/BPyth3PopxovE/Svr9Or1Uxop2RWqdezLL
sFPLnL/tnbbBdBll9SoILgab6P+H1fAygwkiwQ/VDdoUcc1QWcTcDYbdVG3gp2ec
z5dZCAuo8gRDdCUJ5xVU6FCrVL9TNaqEn7OkkyjllzomRDwnUZtf4OQoV8gwe5YK
gyVDICwq4FQU3v6S8tK8C9CPEDn5YLEl7hcUp16wuR3NvQjXywi1PY+nendoWUkl
3A+A8MZu/Xe3buYxfKsGz8i6awTCAo8paY89B3754BHfFkXAN+0IdFcvNOgod4Zp
ViVfuRaSWDxJG2n0lak50MrSXdChZU9Kg7m5pIq/yY6DHmrT6p9dm8M1DBJWEWLS
t2dlfzRaZFvop/W+zojmyUMGeeEmtfrgzGhzGh0Gg6za5Ns5ZeXfRTijLikp7BKs
k73ejf0oIIDsMznAFLOq+zpsPJaXbZtQWOCf7eiHR2L2/m6Ytkg54dhMmG9xl/ZQ
oy+yFTs8d2ZfKyyYn93oNu4AmcecmH8XxFXZ4/wU4eBnAW8ovlmW8gKu9HSYUEm8
XephiuBxI83+Y6gNjFz+
=Bz4P
-----END PGP SIGNATURE-----

--J/rMgauiyHIRVABE--
