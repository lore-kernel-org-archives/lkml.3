Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3EVQmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:42:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51911 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3EVQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:42:36 -0400
Date: Wed, 22 May 2013 11:42:10 -0500
From: Mark Brown <broonie@kernel.org>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Message-ID: <20130522164210.GS1627@sirena.org.uk>
References: <519CD1CC.8070507@koalo.de>
 <519CE2B7.8080704@wwwdotorg.org>
 <519CED72.40406@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ewIlFbbLnYFKahON"
Content-Disposition: inline
In-Reply-To: <519CED72.40406@koalo.de>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add support for BCM2708
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ewIlFbbLnYFKahON
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 06:08:18PM +0200, Florian Meier wrote:
> On 22.05.2013 17:22, Stephen Warren wrote:

> > I assume you're planning on sending the DMA driver upstream too? I guess
> > this driver isn't useful without it.

> I would like to, but it only supports cyclic DMA. Should I send it
> upstream anyway? In case you are interested:

It seems better to send something partially featured upstream so that
people can work on enhancing it rather than having nothing all upstream.

--ewIlFbbLnYFKahON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnPVfAAoJELSic+t+oim9dzAP/0j8kZVrmvDvA/7HVUFr7qti
aHUjpMWnGcX7bo1KXABS8JDHHBPXWXlc2RP8DbMkl2Vc6TfLB9DFBlVgiAWQoqp7
29h52mnXFlYpwHD03rGZC/DGMH3HTCglfr+0O6ebNBo4xaegrbYXUIcaZlw5JyMV
PtHkMCpLjg4C4DpFk5mc7p1IZxCY/33e3ZIGkFNlrW3rXKqqw8Z/l+3TZQv4Foal
o2jaOePIaVwUVL3uBZB/GZVVV1pcF2imuxkkTn8Fqow4bcAM38mF/Ae2H458uMZb
FoVR8nqXCVoIyQQdkwMb8G90WbRSlTCz/WwrhitBjsuWg4LWZkSm7jNpTIhy0ZXZ
vzS7XDmqVuSih0EWWcpZnIgrSS9qgpvmzsV5GczBJ5Ib2qwwAo1vXqF5Yo3vSLZX
Rkf7AeVMZm/WI/F9Yr6dd6ZmtrBNQyWtgwFJwK4qu96jTJnehFN2XBBjGhkFDzOr
odj/TSD5xCklBGaUVxYQ1QQnywB4JtMc62RHCWkyEZOELEImO+fKVhCNToHOcgvP
QVO+uNQ83msKZhjf5vVfjDoDLJEqrqQ/gIK88KD+x6PQuGSB6UNcmVgRgxqcxCtR
5jLMh4/o6+cknPlMDyw/IU1rGwDlij/WPfm3YX0R9kF3zI7ZcvkCeLbXFCgPGmAl
T/9jEaEVG7iSabpD3q2l
=xa9A
-----END PGP SIGNATURE-----

--ewIlFbbLnYFKahON--
