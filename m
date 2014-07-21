Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaGUMTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:19:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47830 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaGUMTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:19:46 -0400
Date: Mon, 21 Jul 2014 13:19:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140721121931.GX17528@sirena.org.uk>
References: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvGBTzZYFChjGQji"
Content-Disposition: inline
In-Reply-To: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: tas2552: Fix PM sequencing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvGBTzZYFChjGQji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 12:31:07PM -0500, Dan Murphy wrote:
> In the pm suspend/resume it is better
> to disable the GPIO after the regmap_cache
> setting calls so that if the call is interrupted
> the new reg values will be cached and set on resume.
>=20
> Also add pm_runtime_put in the remove call.

Applied, thanks, but please don't mix multiple changes into one commit
like this especially when there's no textual overlap.

--pvGBTzZYFChjGQji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzQVPAAoJELSic+t+oim9VlwP/A54akg+/GZ9x9YzQeNd7mBy
ijq91Kp3kSY7d21okgGRjo4jb7Vaq7NhH1BxPP/+yDUEV+lKu/DVsWw5S17Pdvxn
txEtDzmi7i/OATwpEY2sX1DQJokQTJR+joDrLHtcspglKGIoji5bF93dXfq5os5x
XQ8Ld0269fLTsiAnqA5MWIjhzdlqmKHe6TGuF9/PsdsVp8Rs7ne1lL+ZsqgBrJ3t
T2Uti+wKisw8GV4bLe1QI0Z2do95cuB/Rf9cPjOH0YAKe7hUcEvj3cTe1Vyc7sAv
eRWu7wJvB3oiBYXOuhM9T+1k49m5uEkr/EMO0su8DFcabr2/lGfcxmHnP4eaCGqZ
5jueNqHO3WPIesMCCduDo422NZicIk4iyPk5l1TTlfgNzxKnYy7IXJ21jkRuUVDq
hm0aa4Gvyvl8Pk5RLlNonDXUkLhMqYMZNjQZLIS6wL7HYFVPtbV6iNnBH8zZqILY
fmcbx+KH5Z7btLZ3ntewfrXh3Nk1sWxqAiZaqE79aK3+leq8XiYLySQOsXCJAMFD
dWkVDOnmbN+vPJmFzFDz/JpZWAytBBm9skIi5br9xHeFgEx4krVMPkLCTMksds5d
eNOygrX8ZbdPn6TreZ6MrsMUkUBV3PGSqsQ3dDP74YzUGDN79HEcTbmz5a7UGP7X
P7p3TlD04axgjEGfetzr
=m2yy
-----END PGP SIGNATURE-----

--pvGBTzZYFChjGQji--
