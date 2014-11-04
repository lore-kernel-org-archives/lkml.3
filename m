Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaKDA5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:57:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36387 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaKDA5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:57:34 -0500
Date: Tue, 4 Nov 2014 00:56:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Message-ID: <20141104005605.GC3815@sirena.org.uk>
References: <1415038079-6490-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TMTfqzsZeEKgETVO"
Content-Disposition: inline
In-Reply-To: <1415038079-6490-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tlv320aic23: depends on SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TMTfqzsZeEKgETVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 11:37:59PM +0530, Sudip Mukherjee wrote:
> Fix build errors when CONFIG_SPI is not enabled by making the
> driver depend on SPI.

A version of this patch has already been applied.

--TMTfqzsZeEKgETVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWCQkAAoJECTWi3JdVIfQXC8H/1e4acrJt2++wC/IS6f6xxAb
rBGW4KEou5YZOT6kkMeJE9WO/WkiaL/QTdwPELveqSQEWqR7cku6myooXqlaCaU1
GoQCCjHrPjttLZ0Hkfj6Gutu8pTBbF2/EB1KnyDWnuf3hdzgj03IsG1QcxEOS7qU
NnJ+jquAXcMUc/rt/d0u2Zxc8L4Mcirhvxjsu5B88BUEZtr3T9sUGmGfx0sIWwdk
L3VIfAYLOsRsgErDWq03fxwBeZBNjudQ/UODfVH+XKGudRKvQL194xoiiwOQlZzb
IL0uTf93r36ISBjvk+Yl64VvTrEkud6XRberayiDU5pA13vlcSCOTjDHtUu/ujg=
=iV62
-----END PGP SIGNATURE-----

--TMTfqzsZeEKgETVO--
