Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaL3Qye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:54:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55989 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaL3Qyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:54:33 -0500
Date: Tue, 30 Dec 2014 16:53:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "ckeepax@opensource.wolfsonmicro.com" 
	<ckeepax@opensource.wolfsonmicro.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141230165359.GN17800@sirena.org.uk>
References: <1418103916-31295-1-git-send-email-b50113@freescale.com>
 <20141222181045.GH17800@sirena.org.uk>
 <BN3PR0301MB125132692CD535B9AC1795A98D510@BN3PR0301MB1251.namprd03.prod.outlook.com>
 <20141229160514.GQ17800@sirena.org.uk>
 <20141230022917.GA17807@b50113>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5NVDATmc8A1f9nDP"
Content-Disposition: inline
In-Reply-To: <20141230022917.GA17807@b50113>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5NVDATmc8A1f9nDP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 30, 2014 at 10:29:18AM +0800, Zidan Wang wrote:

> I want put mclk enable to set_bias_level. Do you thinks it make sense?

That should work as well, yes.

--5NVDATmc8A1f9nDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUotimAAoJECTWi3JdVIfQyrMH/1CcjT3TC/aD8X7CGYLuCOXs
Lg0TaPhdh9ll2D7vvq0OnoKgsCTeDJBm9Og2Njp/fGiHaM+9ZPfwLC7F+SwVhuJw
8Osi70kBQdIYS3iqWsFgFNxTRLOnVsc9tVFBMS8d9xZ2LQylCFOrJ2t8NhZydeC6
MWj+Hkk5SP9MH8N1fRUGUGjZdWxPIy2foFKSgTkMBx/CMmYCdbijU+EeUye8cYl1
423JSe1PvqhVJa0BaX39USCFoU7iU1mn5Ec1mvSVH0L6WqSzNTEi9zYotlbIS6Ai
NHvgkd+5SEIr/GbGzBTVYUs0RiYlOCIEAiG7HWulZ3JozmOvar7SulL9b3QPQMk=
=Ubhv
-----END PGP SIGNATURE-----

--5NVDATmc8A1f9nDP--
