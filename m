Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaKYNXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:23:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38109 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaKYNXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:23:38 -0500
Date: Tue, 25 Nov 2014 13:21:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141125132128.GD7712@sirena.org.uk>
References: <cover.1416918909.git.moinejf@free.fr>
 <d380c3d09646c9dda14639b5aa5f0f2b2dc80e33.1416918909.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDWkrvKzM17iuZge"
Content-Disposition: inline
In-Reply-To: <d380c3d09646c9dda14639b5aa5f0f2b2dc80e33.1416918909.git.moinejf@free.fr>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/4] ASoC: core: add multi-codec support in DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDWkrvKzM17iuZge
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 01:16:12PM +0100, Jean-Francois Moine wrote:
> This patch exports a core function which handles the DT description
> of multi-codec links (as: "sound-dai = <&hdmi 0>, <&spdif_codec>;")
> and creates a CODEC component array in the DAI link.

Applied, thanks.

--dDWkrvKzM17iuZge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdIJXAAoJECTWi3JdVIfQDY8H/jVuQZCRI8Ra81oQENYBS2AZ
kA2VXXS8q+GDwc/1lne9ys6uizVSnaovBJtrwIfjMi8nri5wpdqAkPTMJiCHnuF/
PmZ5b2wKnM7r85v7PB9xg2xJ0ko4+JURETKmiHm89ZRijwnxnbvt1zxYkOJCQij5
hXdSX8xe9mrgZA8UWS7hQaFi5uVLnp/OU3SH8RHSycDGMHSK3FJNtoPkgVrHUmKW
n/SyfHEycN/J60qgStricuN21h0M9ue9F5xbOd17ucJSlRGU+ZocGEGrKPRSVDST
UJE5EqF03cJe7ZLDdoujM9nqWDjeSdY0AnxEoUINZXdj1b5Divei/BKIAWGZ4N4=
=bRME
-----END PGP SIGNATURE-----

--dDWkrvKzM17iuZge--
