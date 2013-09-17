Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3IQM6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:58:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47279 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IQM6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:58:53 -0400
Date: Tue, 17 Sep 2013 13:58:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Simon <horms@verge.net.au>, linux-kernel@vger.kernel.org
Message-ID: <20130917125826.GA14323@sirena.org.uk>
References: <87sixrre8r.wl%kuninori.morimoto.gx@renesas.com>
 <87mwnvsy7a.wl%kuninori.morimoto.gx@renesas.com>
 <87ioyjsxvj.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <87ioyjsxvj.wl%kuninori.morimoto.gx@renesas.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/4] ASoC: rsnd: gen: rsnd_gen_ops cares .probe and
 .remove
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 08:31:16PM -0700, Kuninori Morimoto wrote:
> Current rsnd_gen_ops didn't care about .probe and .remove
> functions, but it was not good sense.
> This patch tidyup it

Applied, thanks.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOFHvAAoJELSic+t+oim927oP+wYaBN5BCsDvCPGC0ZweDcW/
YVCSjxo4N/LgM2JGfyFa620WkMzQ+O12DuQo5xB3OmA4wTk3jVpdbYFcM1OdFqrI
7r8Mts+y3t9/v7GpNnJSINflSp6Wt/ny5PgJouNWJFR4xzFMx5TU2cCL2u/7dLj5
BobDkJJTAct8Ztd7GRaAq5pBy54fteIkW+mt6U44eutSveL6XPPz5fV34elbcyOE
52OiBjWCsEeYzb9R66sc6vE0XlP4A5sbtEzL4z5qqQgb7nOiGrKWXdYIYWjHOaxO
s8R+nzr8+pepLiveSLqi9AoZ1Za/fkRGwmWh3Dn9+SVlAtXOVCefKanCFmylPTxi
hdFn1alucNRT83dGKMh4ynpft+K1oCsnGDZNS29fg6n66fNh3jSWOD/HmLI3Y3Ig
Fxxx5rkTXrnNWMEW3xvMTsiThC/DCn0/ohq39p3Y4lB0/hLmF2CBVc1Q+6lMnXy/
HEZtC2+ysjl5M/fUVrASUonJ2QrXgjk2tZGrUl116Q/+sDrSjNlvcKFFJrFrIVkQ
VTeaV1xQAhgV2wWPOYOU56TgBYzaPi9mOMajFt9aKYzboKOOOwf9KPEgx7ghivQF
vU8Vby/jRngekEj851uTKNlWPvc8Vsup7GeHbBu8oL0YJAnNTVMcYz3dHJ/2EQoO
VsIxUbnALJopVFFPi6Gf
=0Ca9
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
