Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbaGBTia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:38:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44015 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbaGBTi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:38:26 -0400
Date: Wed, 2 Jul 2014 20:37:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <20140702193756.GM410@sirena.org.uk>
References: <20140702183841.7c964832@armhf>
 <20140702165628.GO20799@lunn.ch>
 <20140702195154.47d6f6b4@armhf>
 <20140702180212.GS32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4oQnj4jcM03NhqPN"
Content-Disposition: inline
In-Reply-To: <20140702180212.GS32514@n2100.arm.linux.org.uk>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4oQnj4jcM03NhqPN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 07:02:12PM +0100, Russell King - ARM Linux wrote:

> Well, as far as I'm concerned right now, it's for Mark to sort out this
> situation, and tell us what he wants to do with the Kirkwood stuff.  I
> suspect he's keeping quiet because he doesn't care about it.

Well, that and the general level of stress around the support for these
boards in general. =20

> Given that he's the one with the knowledge of DPCM, and he's the maintain=
er
> of ASoC, he has the ultimate responsibility for sorting out this and
> giving direction as to how he wants to proceed.

> As I understand it though, my solution is the full and proper DPCM soluti=
on,
> and I believe that what's currently in mainline is not a DPCM solution.

That's right, from what I remember your last set of patches looked like
it was pretty much there in terms of the code for the CPU.  Liam's
obviously the most in depth expert with DPCM but he's incredibly snowed
under with work right now.

--4oQnj4jcM03NhqPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtF+RAAoJELSic+t+oim9utwP/jak9ChYQvNwMg96s8eXE9+w
FugfXEoApjJcCQnsfkfP3x/6xgAKxBpS6JK8dw7VJqpIX76A8XxwavFOz769fyMD
GcJDRQN8O9tN1q8lX1iP4BWcnb20ITloK7LqZha7C9qkxh3hMprHE3ewHfNATUDC
TolfsY3mKseGkCS1s6t9fNWbZA5/r4P3uIeXCFFinpPyf4ifebnQzVHtVP6MFj+k
dKY73UnKbhnnOIE8eKEjMhEAz3TS1PP6QshUtD70vjW/cn6/5xawC+v9cFgzdgE1
ZvmDup3pTRT91QD0PAxWho52A/na0m/ouKgi4y66gktzJ4+rHy2SIJ2f54Efn6If
SX0kEO8UCaz0Jt5SKm/UwlvmsmlP8BDFRFV2YRc6qC66ewmFJQDCSJt9iCNTq+/W
pKgx/D1KfVjWNT5DiN9Itxz0JP5sZRJYVo0UQEcOJeNy3wsacK3xCk0nrIXLYh85
d84nWmypXdmwbNtL1tka5O0pP9B+SkYDjBhG0LAmDPo7rdbdFi0yUOYBFH1wofXT
FEvzzb4xVFYOmtK8vq9H1rUGQJdW63AnLR0wVowEkmXx4W9P3YTvk9ovFCSLvp9P
gY7/AwUz14Ocsy2FBdrldVcrcdTsoIF3hDHpx663/1ewqnk0JfVwH0Ut9FusFi74
8gUS6slP69bMZLyHguOR
=Qfcs
-----END PGP SIGNATURE-----

--4oQnj4jcM03NhqPN--
