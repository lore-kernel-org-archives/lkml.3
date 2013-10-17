Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab3JQQrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:47:01 -0400
Received: from sauhun.de ([89.238.76.85]:59801 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279Ab3JQQrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:47:00 -0400
Date: Thu, 17 Oct 2013 18:46:14 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] sound/soc/atmel: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20131017164331.GA2896@katana>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
 <20131014131748.GU2443@sirena.org.uk>
 <20131014145629.GA17351@katana>
 <20131014163753.GF2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20131014163753.GF2443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > Applied, thanks.  Please use subject lines appropriate to the subsyst=
em.
>=20
> > That's quite a nut to crack with a generated patch series running over
> > the whole tree. I wonder if it is really worth the effort?
>=20
> I think it's probably worth the effort to add something to put rules for
> these things in MAINTAINERS, it'd cover 90% of cases.  If you're sending
> only one of a big series with a subject line that won't pattern match
> that's a good way to get stuff dropped on the floor.

On the other hand, MAINTAINERS information gets overlooked and/or could
get stale. Thinking about it again, it is probably less work (at least
for me with i2c) to create a git-hook fixing the subject line than to
always nag people.


--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSYBRKAAoJEBQN5MwUoCm2CbAQALUYDpiLZZwKwwuK4S4VPEX/
6LvBZ/QMrk6UiwPqPSnZd4efz4PKzE/f3CYXSTuNqS81WFDDjC2xwDfRDxuoIMEi
E2W3XdSGYuKc9qZwFfUI25yMDfEYJd8OSyx8fzMvDUANDxKvwMqptyKIPZLHy5xa
DmFofoMB75GAdpIQfnBtTalLv+lNvKyOROvk4MUO14s+kcnGNCoibYW0q+KbGE50
kAFjijflyymPXasPOEVRpPW682hJlRdG8H05ZpSDQ4TG6ktS8wKRi/WxOp8dMqlC
Hduqs6t4rJBX5CGgF2xgO5ifK1DPZ6KM8nL0Rgu8oKyYpAz5T5twTs8Gc6hgM/fZ
GFTplPUav2YPVG8XtYmOdzJuqVGXtHjDrQDKMlcvILZ+oSrQHo9qBZBm9BS1yfKd
1ImiaKTOvsPUfqe0VylBZdKafN6v1n8JcyxnJrjTIkFB2imem8N8fDDW6+A8BCvp
1ZB1t9zZVzIAsvHw5sez6lXjmKOQz4oxjRM4s821Dir7txsCParNUBliJmLG9p98
s/f+jqjK1AAP2R350lGhVIIw50YsbKkdsh7Oim1zZ9hcFWcsytCgrgGAu+W5jb0G
EPWTJy3lDHQv41w0sqj2LpWY6r+KQu5FQyucEMikmdE5vUTk1eVtwAT1zvfWJ2OY
6k6jE1hWL1ijgSO0oKig
=J9HR
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
