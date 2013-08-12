Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3HLKch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:32:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60323 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3HLKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:32:36 -0400
Date: Mon, 12 Aug 2013 11:32:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lgirdwood@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        J Keerthy <j-keerthy@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Axel Lin <axel.lin@ingics.com>
Message-ID: <20130812103214.GM6427@sirena.org.uk>
References: <1376297474-12242-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m4dDEz192B/qme3Z"
Content-Disposition: inline
In-Reply-To: <1376297474-12242-1-git-send-email-kishon@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] regulator: palmas: model SMPS10 as two regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m4dDEz192B/qme3Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 02:21:14PM +0530, Kishon Vijay Abraham I wrote:
> SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
> SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
> in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2 configures
> it in BOOST mode. For BYPASS mode regulator_allow_bypass() API can be
> used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be enabled using
> regulator_enable().

Applied, thanks.

--m4dDEz192B/qme3Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCLmrAAoJELSic+t+oim9Tp4P/2wzUcsYXHrPYOJu9oaOrga9
wACWMNmf93MIdLEKL5YEZVRGxSPAf4jkjjZsxqtvVz0/huW0SU4pPFJmDy8l+fLb
KiCC0s+PpKyP4a7TxycSouVDlsqc9SDpcu04TMB9b+iGIJY/Hwi6RJIlM4KmR8+/
OgalmRyBfk4Ay+6ddrjXLpWiH1MFsyrIRVUA/wtDjzbXQYxWalOEFW6I64KHgRO+
w/whsTE46YmBQfgaiaWwXQKslUyel4IIXYaSjn0YQfcghhBf2vel+yC8RwACO5wc
w0o3yV1bheTJsQezb0kYnngP9WHEgkWsyuFw1LjrXv1MRve3WHtRLBsX5ad6lWm8
W15WZgW+c2Cro4OnY/YGw7Nez3aZ5MAC2cv7L1E3dx6uYHF9hqIqJNaz6XN2iMBn
U/K84QFDg+lbixAiuOKW07lw1k9GgkwFg0BMbKYSMbV0BXQpWPHnZ8Q8+Srwub8u
PDkIy/6vWhJ+qfkuNbAIb+Pv0vwOcZKugvE7gYE2LU4ffxKgNMusV+6PcRaBaggA
Zfifp81uvqZbhVvnMDrprSJnPjRPWBnC24n2XdBScQ88XwP0GkyrGvZeTD9HW3Id
pClrZv+WCGqiSwG8U1OPGErAsS5dUQasTXea2uZPBvahEtJN67m3dSit+AK/Wjsl
FyyZuaW8D/d3R3K5sRJG
=RlRV
-----END PGP SIGNATURE-----

--m4dDEz192B/qme3Z--
