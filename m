Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3KTLe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:34:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35336 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTLe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:34:26 -0500
Date: Wed, 20 Nov 2013 11:34:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131120113400.GY2674@sirena.org.uk>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131120091636.GA30012@lee--X1>
 <20131120102045.GW2674@sirena.org.uk>
 <20131120104526.GA30524@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWPcrH1o85ekjD8l"
Content-Disposition: inline
In-Reply-To: <20131120104526.GA30524@lee--X1>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoC: wm5110: Expose input high pass filter controls
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uWPcrH1o85ekjD8l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 10:45:26AM +0000, Lee Jones wrote:
> On Wed, 20 Nov 2013, Mark Brown wrote:

> > I expect this to collide with future changes from Wolfson so it'll need
> > to go via ASoC.

> Okay, what if I make you a branch to pull from? Or visa-versa?

Sure, add my ack and give me a signed tag to pull from please.

--uWPcrH1o85ekjD8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjJ4lAAoJELSic+t+oim9owQP/ROLEWbvU2gGNzz5GyF+G/c9
pAlFc3vH7j6++PekmgDltbY+fjWzctpB1l4AlWzS8D14r7j4gv7xBkNyUHKxlv7p
IJk+fV24U5nPMKibOApyRqyvJ1gJEUsL13Ic5UiWZw8DtV/yCZxWYBSiPPs5K2EK
g4IPj0Ogv/NQtPVWh9+h9STEVHhOYuZBuRwG3OydYhmW7jEVMyV5ZUj/9gj01xvV
+NfPowTOY0Mz3wR/ipCXxBJEGjK+GiZxHvrfHogE9fSrBAt3Rks//hfQA9Gon1VJ
4O7jeCTyC6xGpZY0995KvRzDgUZQG2vKF8jGwAR5U2IW1azp7pwrnNevhoLZncpb
I8Wt+vjIGqOK5vHF7SNZd3/pKoFpa1HmjqhLQxfuKbP/Q4aYLq5vSo8pCC4bAm96
NMQb7+M7gPVpCEPS7jMhG3vMhYIo20rSYoG7O7XXFCT87+7M/PBARwoeYQEJOF4F
KrjWa0yF1mKbTcvQFK29V+C1iEz4/OX317Wnu/FZtWToHm17bI7J/aPXnI6R68YT
Bgw6jbo3PpAF6rkkOkqwA1OjrVsIuqugRn3MUJRILJLaF11vHN8NW4zQ6iNc8VXU
JlbIGhzIjaWXReeBY3tlog6CkmGwTQFYYTCt5zkcyb/sWTfL/gE8yt4sFPuej8FP
AXVKf6SSn01WQUaccoP2
=NvGZ
-----END PGP SIGNATURE-----

--uWPcrH1o85ekjD8l--
