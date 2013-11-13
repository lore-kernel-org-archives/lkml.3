Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab3KMOC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:02:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45345 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3KMOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:02:53 -0500
Date: Wed, 13 Nov 2013 14:02:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20131113140216.GP878@sirena.org.uk>
References: <Pine.LNX.4.64.1311131228030.18879@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nLMor0SRtNCuLS/8"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1311131228030.18879@axis700.grange>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fixed: fix regulator_list_voltage() for
 regression
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nLMor0SRtNCuLS/8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 12:33:00PM +0100, Guennadi Liakhovetski wrote:
> Commit c368e5fc2a190923b786f2de3e79430ea3566a25 "regulator: fixed:
> get rid of {get|list}_voltage()" broke regulator_list_voltage() for
> the fixed regulator, because an earlier commit

Applied, thanks.

--nLMor0SRtNCuLS/8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg4ZlAAoJELSic+t+oim9/w0P/jAtBdya8Luyx/xUDL9uBEF8
5TCGkdpHEsTmOU9KQB+VF7B4mPcM3as8GwgNClQVGDR0yLrbT6OxQPrZh6/cvOZs
621Dp4Bfdl7VxUihGUx1k6W9k2NNlWRY1llxYqVoKWK0IH3CicnJeTJLbBO7mliy
NT0FKZF7pFXyMztRdIEn1M9yflzL04jrAOiHaE3CXG6HqQVOO5xhOT0Msqj6vYRO
y6P2uPsjLXcYHtHo557MpKXQLiWM3wy1u6ctkmlf03rPs0gFrPORIeuQGrnEQk08
WWAsMgTRiaWci6wQnNaGxyp38EYAnFhOvWTXco31FOdxn7Gfthq1WzQu/0En2Jra
tVxAT1QvLnVvGlDXw2Y6612d8ccfCx7ZnJbi8uhK1+z+xmRW6PaHiPcsPK0BF22+
H4KbJnqr1Qfu47CsBoeinWGixvMHpCKOWm4AJ8rb29L2wlOTQjNvSF0As5r+fuC5
25hEW4wvoX3phJu3x5P3whjdKjzJfuJQYYHYLyaP5O2Ko81FYyNlLih7HjDCt3Uc
i26eJk/xZeBL3hfMYkOMO1E25hoNfwj17PFgH3AWuWeL0PDrupLLYLsbQRzsX7qI
vhhIU8lrhD6RVH1J2g4LLK0OGQllch8+RZW1GoAtvj1cGbuicCFqsJscjWnY/jBG
O4YtsRaNt7Wi4ljrm7R+
=aD3b
-----END PGP SIGNATURE-----

--nLMor0SRtNCuLS/8--
