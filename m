Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaGCNmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:42:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44989 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaGCNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:42:33 -0400
Date: Thu, 3 Jul 2014 14:42:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, dan.j.williams@intel.com,
        lars@metafoo.de, tiwai@suse.de, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org
Message-ID: <20140703134210.GC410@sirena.org.uk>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
 <1404363116-10538-4-git-send-email-peter.ujfalusi@ti.com>
 <20140703120153.GZ410@sirena.org.uk>
 <20140703120256.GO2296@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b0bHyb0BmsSIM7d2"
Content-Disposition: inline
In-Reply-To: <20140703120256.GO2296@intel.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] ASoC: generic-dmaengine-pcm: Prepare formats mask
 for valid physical sample sizes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b0bHyb0BmsSIM7d2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 05:32:56PM +0530, Vinod Koul wrote:
> On Thu, Jul 03, 2014 at 01:01:53PM +0100, Mark Brown wrote:

> > Acked-by: Mark Brown <broonie@linaro.org>

> Do you want this to go thru dmaengine tree??

Well, I was expecting either ASoC or core ALSA.

--b0bHyb0BmsSIM7d2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtV2vAAoJELSic+t+oim9750P/3ZhcDpb/Ow+iXpUUvYb7qcr
pv/DqIAsz8ngjbFkw4aL6zgCgbC82wcl3Qy7OIJVSyFOsKmhaHLr4v3v+a+6Had9
SBiCUUFG3W1QIWaPHbTUFAOFSTSu7ChWFkPdqXW+L69UmI1/4iGzcJpWYDMWv9CI
59j7la5lEiGZ/IHQ6hD79MGf+Epi+CHU8FKcyUQJBk81NbfiszSlRhBjJqosR9kK
dZvVYfEMlX6XevxadLhhwqkuKbTw2WjeS1b84Om9MohPi1L0VFn91NIEgq/JqiYw
Dp7CHspwvECMmW22WX0XSOswcNFhDJaboVnbBv0B3DfSmnnVs47CCvP3JKJdj+uy
SIQm1dqw8xvs/znKclvmqTCCKvv082WhW0iPtuokpLY3WL8JraOtkdo56ZYyBOAB
+9tbwLDlfBZP/1JC1+ZOpi1LFTwYLqOrqR6B7gYYwiaHIxxwxkyXAZw4dPvW4N0H
1bxwqtqVU8lZ1tvOh0Cxzsw4vVHUdvUUS7i70B84qKMu+bg7h7gbkShpFD3/gYwd
Ab8s8Ro+NjO5ESUATQeq4qpHTeadgU2sIXK+lz17RHbhCXDqperW922HU42AjsMK
dyB9H+M0xJx5ddYKqZeZ5AmZzETHOM1G7V2gVz7qE05Ua6gIb16IDSw806+pxIG+
QlIKgvLGDRgKc1Hx9tEZ
=5iUA
-----END PGP SIGNATURE-----

--b0bHyb0BmsSIM7d2--
