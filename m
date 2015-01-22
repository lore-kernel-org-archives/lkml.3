Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbbAVTBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:01:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57329 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbAVTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:01:12 -0500
Date: Thu, 22 Jan 2015 19:00:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Message-ID: <20150122190052.GS21293@sirena.org.uk>
References: <cover.1421868426.git.moinejf@free.fr>
 <d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
 <54C0088F.9070609@metafoo.de>
 <20150122090723.50ac0156@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5Dr6Wqe9hdyl7LAI"
Content-Disposition: inline
In-Reply-To: <20150122090723.50ac0156@armhf>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: add generic dt-card support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5Dr6Wqe9hdyl7LAI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 22, 2015 at 09:07:23AM +0100, Jean-Francois Moine wrote:

> I was also wondering about some of these properties, as widgets and
> routing. They seem to be software information and Linux specific.
> Must these properties appear in the DTs?

What's Linux specific about them?  The widgets should all represent
physical things that can be pointed at on the board and the routing
reflects how the components are hooked up.

--5Dr6Wqe9hdyl7LAI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUwUjjAAoJECTWi3JdVIfQWfcH/RdclJDHsnRFv1ttPnJaYvb4
TpN8LmEhogNFYAOYAXaVBA5q/XGuM4pmsrPkQB7XiUnFPhJpx63OHirBp/fk8qPm
oVIALgyQxKZC/XPT6MEe+LJojSTlG2FawswT7j2qEv019kTeZOVrhiAXWD2gmmrG
feByG7OO0TQXg8YKnCcpvT3630u8mXti/E97cBnAvzw2azUm9xHLUa/mcO0yx/yZ
Tr6XSoc/+624vqqrUNZqTs5l8+mGkU51haXoH/Ci27Tb45O2QWr8eovoX41RUEka
ryDwT79mG4aYbtelsmMNIDfB46t5xv+u2nJ0wmdcDLoV0O52bXyRHIP9zVMg044=
=37D/
-----END PGP SIGNATURE-----

--5Dr6Wqe9hdyl7LAI--
