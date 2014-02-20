Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaBTCt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:49:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57564 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBTCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:49:28 -0500
Date: Thu, 20 Feb 2014 11:44:32 +0900
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140220024432.GU2669@sirena.org.uk>
References: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
 <1392086825-15737-2-git-send-email-Li.Xiubo@freescale.com>
 <36d9c0a870604fbe87b129e95fea9da1@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lx10O6ETy9X4GV3M"
Content-Disposition: inline
In-Reply-To: <36d9c0a870604fbe87b129e95fea9da1@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.224.205
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be
 visible in Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lx10O6ETy9X4GV3M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:06:20AM +0000, Li.Xiubo@freescale.com wrote:

> I'm not very sure of this patch, maybe should we add one menu
> in Kconfig for all visible CPU DAIs firstly like for code drivers?

Allowing them to be individually selected is definitely useful if people
are trying to minimise their kernel size and/or build time.  However
none of the other Freescale people have commented on this patch (which
I'd have expected) so I was giving them time and IIRC it needs a rebase
against current code.

--Lx10O6ETy9X4GV3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBWwMAAoJELSic+t+oim9BkoP/0T7ZZCT4XARSIQ6LQ0fixy6
vX6kdJF0Jy43oJBLtZNVPQXhAxRUk4cieLG82edCwFRJAp/XowtvhuE+6FCPMhVR
tIPC75vR4v5TN7tll1fc/PL1T15JP9oThidenjivtXfxg27Q0Kd8hl8LOIDgicyO
v/3ZyjFr9q2nBUfKl2d+HXmqkFpQPA9MayF17yH72RBpccwxPxEXUegfgX9wKbWn
adg1iF3Qd6ulHGVx7FQNOnx+5ad+sgbwewpWsO4j0X2RgOd+XB14Lk6bOUfoJe3c
urmQrfkNZGbWMfKg+CPi4YhSvW3Y/ECqgZn1YE9w/9Y3xWHDgRtfudHHTWDoEvin
0Xy305c4tiL4CCA1XtLMOXuqErm6g8PgOIYbhqg8ZPjX9q92+seHjI+NlMyHQHF6
vvigrMzhGVYpD902qRefRbPpibKVemV1GxOHhiStP/TDtU7I+SiZvUgf5fP8Pnmg
eowtPKtP1GmR5uurvKmoah9yaG/kYFMah+zM1e9VXGT4CqmjRGaIrJ0kBCo7kjBb
0oDQSq4YsDe3R9RTuU43JMmI+oRZFPa9qKEIF9LwpKgOXkwmpog5RoU0YAwjO849
96rcj1d4SFatAgKsA5lQlua9g2Q/7GHKpnWkFnRQuVkvHUKIAMpqIcXD0/PNbPKb
JXyKnbWrPUof1+R9lOxu
=AKsj
-----END PGP SIGNATURE-----

--Lx10O6ETy9X4GV3M--
