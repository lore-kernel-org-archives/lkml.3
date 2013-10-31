Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3JaPed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:34:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59777 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3JaPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:34:31 -0400
Date: Thu, 31 Oct 2013 08:33:16 -0700
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20131031153316.GB2493@sirena.org.uk>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
 <1382909086-10493-5-git-send-email-sre@debian.org>
 <CACRpkdb1dAiDCeZkOiZ6inbDruaUwLgk3joWwuQmSRNZ9WkDGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q1SX3yAxAkj1z+aD"
Content-Disposition: inline
In-Reply-To: <CACRpkdb1dAiDCeZkOiZ6inbDruaUwLgk3joWwuQmSRNZ9WkDGw@mail.gmail.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 63.239.94.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 4/4] ASoC: RX-51: Add DT support to sound driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q1SX3yAxAkj1z+aD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 31, 2013 at 07:44:22AM -0700, Linus Walleij wrote:
> On Sun, Oct 27, 2013 at 2:24 PM, Sebastian Reichel <sre@debian.org> wrote:

> > +- eci-sw-gpio: GPIO for ECI SW
> > +- speaker-amp-gpio: GPIO for Speaker Amp

> Can you please spell out the acronyms? ECI? SW? Amp?

> I guess SW=switch, Amp=amplifier, but ECI beats me.

ECI is the name of Nokia's accesory interface spec, it should be as
clear as GPIO for anyone working on Nokia hardware (which this is).

--q1SX3yAxAkj1z+aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScng5AAoJELSic+t+oim99U4P/0uhuIkwZWipiyPse0NDxCLX
YlKLJvGPIFjKfsQr0iGArWa4+zW8EnedN9F2Lxj3JgiWEOVGSQMQ6q8SkGdLuTiI
KRnQlClpi5QnN9OylffmKNTcgfoDOEOjxn7gj7JNaWWSuNPY92zUnNZ/ODMrudeV
CbmlZlC+t5UhG/VwIXJpRkXgoE6nfyahcr8S8kU/KPFPgrhtJ1kV2sY+xsUmNe+U
wv6tCAv4lcMMw/DieBI5jGwSZQ/ThVxeWp9dDi9ITZ+SgcfOPc1+OvzOyqphFBzo
bC4V4mYS+brbnqh+PiHbwN11cRZi5Vgro7NI5p9xCdqwxqygt02gdWmperwCvfs/
uTz4Iiq6bXtB5yr726BwpLkwh2dyZUMM7b04S4OwccZCe2btKROKEC+diphzyWWa
gZGFhIBuKw9+aHkyKXmdTRuuImnn0gtBdeBjTyA/cYsBdg+cvNJJ9J7R6jOdzKQL
e+M1PaY0HZWKs4NE34oVaWXqjXr0hTuLZkZz6FZkbey/qnjg17pjU8vfbhei7PM7
m0Wubz1cxHLbcVnLNOuE3mwOyYZfLusPUzRuRzpyCnRlnjvLQ8yAE5a1n/f1qYi+
78nHMBc8gIfYMMQQCpdVtlcChpS/Y4j/EwyX3u3P+yyNaR0JF3KGT1c6VFGCm0Bm
FxZcHnSG+DClvKI83VgH
=D34t
-----END PGP SIGNATURE-----

--q1SX3yAxAkj1z+aD--
