Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbaICMxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:53:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48058 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794AbaICMxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:53:04 -0400
Date: Wed, 3 Sep 2014 13:52:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lgirdwood@gmail.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, Robin Gong <b38343@freescale.com>
Message-ID: <20140903125248.GK29327@sirena.org.uk>
References: <CAL8zT=hNnRU3gbprVXOMt6FC9veRvQKRmS9gSeCm5-DNfGv-xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HHj6mHPeUinss9N+"
Content-Disposition: inline
In-Reply-To: <CAL8zT=hNnRU3gbprVXOMt6FC9veRvQKRmS9gSeCm5-DNfGv-xg@mail.gmail.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: PFUZE100 regulator not going off when PWRON is 0
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HHj6mHPeUinss9N+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 11:44:22AM +0200, Jean-Michel Hautbois wrote:

> I have a custom i.MX6 based board, but PMIC part is exactly the same
> as the Freescale SabreSD board.
> I have a reset button, which makes the PWRON signal on PFUZE100 go from 1=
 to 0.
> I thought this would reset the chip, and thus all voltages would go to
> 0, but this is not the case. It seems that SWxOMODE registers are
> involved in this process, accorgind to the datasheet, but I don't
> think this is implemented right now.
>=20
> I also removed regulator-always-on for my SW2 pin in order to get it
> off, but this has no effect.

You should really contact someone who worked on the driver or Freescale
about this - I don't think anyone on the CC list knows anything about
the part.  In general if you're asking about a specific driver this is a
good approach.  I've CCed Robin Gong who was the original author.

--HHj6mHPeUinss9N+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBw8dAAoJELSic+t+oim9RqIQAIxH5/Ee3sAAZHFwp3TsvdoM
0ocRbFMvdXIkJmToBPoo/GCLsCBgVFkOMNKEmeS+f7AKh5yF0zTkJQfydyK7B53u
wibLQqQ7SKNMdsv7gZqqqCSal6Vf/VcHnLZIZ2iwtqLGUw2tato3g08vzGg42DkY
d0bYqIg0pS5jKgqIgLHIcs/kEX0ZKF9+GY0dv6AVtQ1FVDtrbq0TMM8XVVWJ80mX
iALR3AZYLk8xj8jBFIltikMpg5IjtmpU1mfG0HqjJlI4Ms7qgDWpzbwgdhdATVtx
GhGkHX1WThIcKKNJiL9xg7zZaGdWgjiSARQJXgFe9yjTvdCB1sSbcB0xRlKxuPMO
BXKjl+/bdmTZYkKemlrul7+V1EELCojM0ObcoT2w7XlAmFyTv3HbKHUxwq2qlCK0
55hmgz65DVmjq3aDyGCFod0VBnPJJZoEaqfWLc8m3Svz9QycxUl9WO+oSga/y+pl
tZ2ozzS/f/csbkVStWDNn/Qyu0y28PAPGXqRF4jt4n1TdtZNl+KyOzfSU7W1Fb8B
T1zZzi6cI+xXwx1Wof0BusJH/eo3o9Ob9Z+UzwDrOxQVuFlYU1h+OKo2vmd8+VhR
QhrqtfLD+j10B5+TkLI1RW2dlRmxP9hLeUAWcD0MwCEu7L3HPDpSyuSxhv5ZrI3m
qQjvH0h2NEBHZ3H4XiRV
=/7pG
-----END PGP SIGNATURE-----

--HHj6mHPeUinss9N+--
