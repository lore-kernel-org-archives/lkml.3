Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaDOMRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:17:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33867 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaDOMPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:15:00 -0400
Date: Tue, 15 Apr 2014 13:14:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Pavel Machek <pavel@ucw.cz>
Message-ID: <20140415121432.GY12304@sirena.org.uk>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
 <1396733753-9820-3-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apSYfA7d5AHMku3c"
Content-Disposition: inline
In-Reply-To: <1396733753-9820-3-git-send-email-sre@kernel.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] ASoC: Allow Aux Codecs to be specified using DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--apSYfA7d5AHMku3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2014 at 11:35:50PM +0200, Sebastian Reichel wrote:
> This patch adds support for specifying auxiliary codecs and
> codec configuration via device tree phandles.
>=20
> This change adds new fields to snd_soc_aux_dev and snd_soc_codec_conf
> and adds support for the changes to SoC core methods.

What binding is supposed to be implemented by this?

--apSYfA7d5AHMku3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSKkAAoJELSic+t+oim9/WsQAJbb5rAEXw99PNcgkQGDmK6p
OepYpcpMf8RO85qL3no2x8C+YjW7w44sljpozlFf8px/SDuee8FCjKUm9HN26htl
bcSX9DN80S/zMOcO3h74sdTLZrNYIrAgiEPzNs/IbMH67lLTHm23BjTlfUdFlldz
3H/FlXvJ86Hux5fwMcrhz5JSgCngQ8tnDAAA5C5/mbPLVchKpsm4/l4eiAf35YQe
bf33rMxLqDH9l97aTrjguDSRefnqI4PZmyMxg0VQONnLb5vadDo93ucYQyITbU7W
Rxf8HJvrJte41xbcZovltF9xtmGZ+yE+MMrruwaqLKUrIAz6tKUQXm+NHO27irUL
Jq+nZr0vyHg03uRTdJBrRWVq3yOmmQUCCjHlAQJ0CfZeK/sASbzouNXyK5JuL8SU
IRbANr4GqXBOEM3Tnmvoq/pktQgdVcNL2pJsJ/R8D6Y+nZTiqHCCT/djRQblQe5n
SOh8ExBeRVSoyyNGOs4+OEYZiYYol01dgU0cm7S5fJ3/IlvyuxZXnLBvf1v5NEC1
eX/fKR7/CVK3dz4/1bihW/2QYgX7XkUq+UmwIsaaYPTGZVAPPIJJWfq4N0DYdQ3J
NupACShR9v+iq8YPQAgZvb9JzzXhucQvXm21xQVdQtF5VFen18/t893q7IbpNsIO
FrdPDQeJAspFbSZd1nS5
=tQs2
-----END PGP SIGNATURE-----

--apSYfA7d5AHMku3c--
