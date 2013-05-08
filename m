Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3EHLbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:31:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48626 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EHLbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:31:41 -0400
Date: Wed, 8 May 2013 12:31:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508113124.GH7478@sirena.org.uk>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
 <20130508110451.GC3459@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x7gJcYyRf5ZnuMVj"
Content-Disposition: inline
In-Reply-To: <20130508110451.GC3459@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x7gJcYyRf5ZnuMVj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 12:04:51PM +0100, Lee Jones wrote:
> On Wed, 08 May 2013, Mark Brown wrote:

> > Ugh, please don't do stuff like this - you're posting an individual
> > revision of a patch buried in the middle of a thread.  This just makes
> > things hard to follow and error prone.  Repost the patch series

> It's so much more convenient to do it this way. Re-sending entire
> patch-sets for small fixups is clumsy and annoying at best. Creating
> even more prone to error.

Then consider what happens as soon as you get more than one update to
the patch, or there's any meaningful discussion on the patches - picking
out which of many versions in bifurcating threads.  You shouldn't even
assume that followups to the patches are being read, for example if it's
clear that there's revision required and it's all device specific
discussion rather than framework stuff I'll often just stop reading the
thread and wait for the respost.

> much more churn than is actually required. Sending patches again
> signally i.e. not as a reply to the original [PATCH x/x], would be

Of course, yes - that's a bad idea.

> Surely most people have their mail setup as threaded? Then the
> time-line and subsequent patch versions are very easy to follow aren't
> they? I get a nice trace like this:

> > <date> Fabio Baltieri    (  0) =E2=94=9C>[PATCH 2/6] ASoC: ux500: <snip>
> > <date> To Fabio Baltieri (  0) =E2=94=82=E2=94=94>
> > <date> Fabio Baltieri    (  0) =E2=94=82 =E2=94=94>[PATCH v2 2/6] ASoC:=
   <snip>

> ... or even better would be to reply to the original one, then
> subsequent versions won't be "buried in the thread" per say:

> > <date> Fabio Baltieri    (  0) =E2=94=9C>[PATCH 2/6] ASoC: ux500: <snip>
> > <date> Fabio Baltieri    (  0) =E2=94=82 =E2=94=94>[PATCH v2 2/6] ASoC:=
   <snip>
> > <date> To Fabio Baltieri (  0) =E2=94=82->

This doesn't work nearly so well once you start getting meaningful
discussion, multiple branches on the thread and indentation can make it
hard to spot where the latest patch is and it's still more effort to
find the latest version.

> > or wait until what can be applied is applied then repost.

> Taking patches out-of-order, or 'willy-nilly', is asking for trouble.

We've been through this repeatedly.  If your early patches won't work
without the later patches then you need to improve your early patches so
they stand alone.  Asking people to re-review an enormous patch series
because of a change at the end isn't helpful

--x7gJcYyRf5ZnuMVj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRijeJAAoJELSic+t+oim95qwP/R6KDkxDU+VHpRZC6MamFUtH
t9Q+XDZr/5tdwxPEfGxBaJPLzuqJLESHGZLua7BnJxYhqbQyAWkU9NJLLZIG7Jdv
egs5eqzpRPT4hJ2URu0Dd3F0yLIejtCxVOXnACzP25oVpZMSwwMUkEF1AtM7Qfmf
5JX78s3A3U7Vv0fkRCTqCBE5d/Nw7tSFfPFA4MJ8DVLHUBwdiP4S3pyzcA9EHrXJ
s0RVjOawdPKUqnG34ozvH5FASXeTO9pZa7wlmKWQ3x2D4hhp2OeMkVJTGzK2GhoV
Dgb/niFZHdVopTzkRafoU1o04JOT6cWefzJiTa5a2tlGa46bjwbOqARtjM8vl5er
3uJu/upzErELGqrEYG30PvT+9YEWMTqf5LVR4g85P1Ol7g+qITpP793fc6WDx+vu
djv2oyHKbmeQMPHv5EoR2gi6hQhXJKUDWOJSGgR3CNN6xTMvuwNglcTWtXuMP3Je
xr8ssinAhb6CCJL3Z4vJqEh1KyspU+EOzl7BwFmilZOPNNDFvhLWtE+DIyG/kF3s
n/I2gJXo7Fj1oCm1LlExcsmAWZkvP4/FMu38gE7KLiclLxxUWKrpoz2AUEypPNRG
veKPX2oBqYqn+A/DWl3LyHpjkaZjzkZIyXdSu7dAReKnEiNHv5iBVZD/7ZHHsTjC
dfp4xVtF3GrfOyzprUTb
=AOnY
-----END PGP SIGNATURE-----

--x7gJcYyRf5ZnuMVj--
