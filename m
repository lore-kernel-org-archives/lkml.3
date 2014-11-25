Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKYWSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:18:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38725 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaKYWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:18:20 -0500
Date: Tue, 25 Nov 2014 22:15:59 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141125221559.GZ7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <2580837.YI0IvfXqRR@vostro.rjw.lan>
 <20141125202722.GA25261@sirena.org.uk>
 <1926483.B4ieFnCBlM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vz0bOunXd3DTcUF1"
Content-Disposition: inline
In-Reply-To: <1926483.B4ieFnCBlM@vostro.rjw.lan>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vz0bOunXd3DTcUF1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 10:40:53PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 25, 2014 08:27:22 PM Mark Brown wrote:

> > My initial thought would be to require that we send any DT properties
> > defined for devices with ACPI identifiers registered there and hope the
> > volume doesn't DoS them.

> We absolutely need to start registering the existing bindings in there, but
> that needs to be rate limited somehow, because the process may not be very
> efficient to start with.

Well, my upstream connection is 20Mbit or something, that's a limit :P

More seriously there's not that many devices and not much use of the
properties API yet so no concrete users; it's three audio CODECs that
I'm aware of which should use it and are in tree now so probably
actually a reasonable thing to throw out there for people to have a look
at.  Liam, do you think some of the Intel audio people could look into
the code side?  I'm tempted to send at least one document myself for
pipe cleaning purposes.

> > A more defined format for DT documentation that we can script into the
> > ASWG format (or vice versa) might be helpful here, and we should add
> > notes to the DT documentation if this is how we want to proceed.

> That's a good point.

> Unfortunately, the timing is pretty bad (Thanksgiving) and the closest
> ASWG meeting is next Thursday, but that one's likely to be busy for other
> reasons.  I presume, then, that the earliest we can seriously get back to
> that in the ASWG is mid-December.

OK, not the most pressing matter I guess.

--Vz0bOunXd3DTcUF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdP+eAAoJECTWi3JdVIfQUDUH/AhBd7aYiWR217dtr0jYMqEL
5qNaFVArcjD/iG1j7NC2uYQEjc1sprtIcNXEPBMCs3uWfNCqGvvDhBHUKFOLfWXv
87/0aEGbi42S4YjnFn3+7Wl1iXFol+94fzIzdwiCdRa2NzIzaYusvZphxpxxuZ4B
HGiyU7LgzuHrexWAWLmz97iVMR5tJbrLTBhYCalI6/V0ufVZrhsLwwWo2DY2s12E
PCAe87sfLVvXrVbexJ/U/fsF5fJunrYVY5eK6At5KKgFxzZDEtKWvQv6lOPBJa0i
k9PqaX0OzWHc+YZE7u4pmRud1fOvN0xgg9Vr/1SDYEe8H7m0xEWTVb25CjGm/kw=
=f0nf
-----END PGP SIGNATURE-----

--Vz0bOunXd3DTcUF1--
