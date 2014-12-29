Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaL2Qxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:53:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54470 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaL2Qxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:53:33 -0500
Date: Mon, 29 Dec 2014 16:52:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <20141229165246.GZ17800@sirena.org.uk>
References: <cover.1414053169.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cqgibCT2eNae4+Dl"
Content-Disposition: inline
In-Reply-To: <cover.1414053169.git.moinejf@free.fr>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 0/2] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cqgibCT2eNae4+Dl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 23, 2014 at 10:32:49AM +0200, Jean-Francois Moine wrote:
> The NXP TDA998x HDMI transmitter may transmit audio to the HDMI link
> from 2 different sources, I2S and S/PDIF.

So, I'm not seeing *any* interest here from any other HDMI users.  This
is a continuing theme with HDMI patches and is really very concerning,
everyone appears to be working in their own bubbles coming up with their
own things and ignoring everyone else's work - what little review I'm
seeing seems to be happening only after I explicitly prompt it.  I'm
following up to Jean-Francois' patches here but this isn't specific to
them, it seems like a general thing with HDMI code.

This in turn makes me think there's some abstraction problems with
what's going on and we're going to have to go through yet more
refactorings to fix things up as we do manage to come up with better
abstractions.  What I'd really like to see as a bare minimum is some
visible conversation about what we're doing and sign that people are
at least keeping in mind generic solutions when working on HDMI code.
Some commentary on the similarities and differences between hardware
and which abstractions work with which devices would also be really
helpful in working out if we're going in the right direction.

Basically at the minute I'm worried that we may be making the problems
we've got here worse not better, I've not personally had the time to sit
down and study the hardware sufficiently to form a firm impression
myself which isn't helping.

--cqgibCT2eNae4+Dl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoYbZAAoJECTWi3JdVIfQkIEH/2fiNrgDHQawYRxNQhcbJwSy
ITPRwYBq4D3kay1+XiR7FfxVtHaOJO7sRRQmjeB41tBzMjuir5b238ZaIfYKJK3k
YEPB46yaSXAbW4DbjDaLO5ul+4ZlW6rZRAiungYq3QAROrvfS2kjM5tM1fDSyd/a
NHRYB0NxvWCd9tfZFChGWIIsupHeHtNF7lFfwgrR0ve02ACbgLpN0Su7DScu0NJ2
csTwwcdNWT5lP5Op67GO5igshLBuZF/3Z4olTwTsguhWji1KuIeP5Sac49pbpdm4
qayMSgWnb2FRJx5EZHhdnvnpfa2+Bwka0n5dFmsvXwHfmMx8t3id3KqMGMlX0vE=
=3ShM
-----END PGP SIGNATURE-----

--cqgibCT2eNae4+Dl--
