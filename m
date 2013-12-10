Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3LJKrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:47:52 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45297 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3LJKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:47:51 -0500
Date: Tue, 10 Dec 2013 10:47:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Nicolin Chen <b42378@freescale.com>, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, tiwai@suse.de, perex@perex.cz,
        linux-kernel@vger.kernel.org
Message-ID: <20131210104745.GC29268@sirena.org.uk>
References: <cover.1386344000.git.b42378@freescale.com>
 <105d07ac1a77bf99872d75608c97b3342079bfb7.1386344000.git.b42378@freescale.com>
 <20131209175640.GL29268@sirena.org.uk>
 <20131210051740.GA10655@MrMyself>
 <20131210102523.GB12042@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nLy6Cz1zLznoF4Q5"
Content-Disposition: inline
In-Reply-To: <20131210102523.GB12042@MrMyself>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nLy6Cz1zLznoF4Q5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 06:25:24PM +0800, Nicolin Chen wrote:

> Hmm...Sorry for asking a stupid question that how to test bypass path with
> WM8962? I've tried some amixer commands to enable the bypass-path switches.
> But we still need to power the Codec up like using arecord or aplay to call
> wm8962_resume() and DAPM-related, right?

For this sort of question you should follow the DAPM graph...  the
headphone and speaker mixers have IN4 and MIXIN as inputs for analogue
bypass and the STL and STR paths provide digital sidetones through the
ADC and DAC.

--nLy6Cz1zLznoF4Q5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpvFOAAoJELSic+t+oim9qcwQAIVmuHJ+x2gEC4MIaUOOoBkO
eBAVO9MqMuwJStBpJJ+OFXD4aNZXjiBqsLsrlFVKp6VHoqsb9c9Lhb8a9ZhIpyFi
TzNtxXaCyZG25TZY2h4PzNn1J4sIZgY/9o+MxcaWrAbEKLKKjUpC7G/77/9XYQB5
f95wKzryhHV8YFoJ7UBvkcCdnovG7vtKAPzvANtIMwt6ywsJn4MfUefYqjLbFQ4I
0jUaf7ao31o1KSiPDyLFRTj9b5CmYn+W1bGvg07N1HKwBf/hvlFBbMsza1kGpPmR
WD27LEhRkBsNX/MLgaXpCFCm16vbiQEhfF4FmF0rxn+BOx35WM491splB1IVg9JL
89QEfTmxsJ4N5QE0fS1iEHNjsSytLCzATQU80y2b4mK7TGd7RDNaFCNwVDYJmRbx
GYKDX8NA0FOYobIGz/I/gigb41krdzuLluzuRsexGXIaQ23x1hw3vG+8Rm8aoSAk
LLgdTLUHlp9F5sdIhFDgTsRqTkxGDYtp6eXtbam3//UiFLCiCQQBZZPJcogwTfiQ
0AgQJeiplDx8Jp6MMM/+1IJTkwzi3lLvGFy2bl3TiyyWztSBVBOf2WUfrxT4KkEY
qI1Wz2czk0eAQdmuh/jBZbhEDc4pMa3ELiNFoZEB+AtWXdb5A+ttRLjh3OAxv21q
iwFxwRmOsoMtFZ+ZuJVc
=NPIL
-----END PGP SIGNATURE-----

--nLy6Cz1zLznoF4Q5--
