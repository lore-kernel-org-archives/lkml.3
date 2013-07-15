Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3GOLZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:25:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57826 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab3GOLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:25:15 -0400
Date: Mon, 15 Jul 2013 12:25:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130715112503.GB11538@sirena.org.uk>
References: <1373804812.1370.23.camel@x61.thuisdomein>
 <20130714124538.GA11538@sirena.org.uk>
 <1373807896.1370.43.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <1373807896.1370.43.camel@x61.thuisdomein>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: EXYNOS: remove references to non-DT SoCs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 14, 2013 at 03:18:16PM +0200, Paul Bolle wrote:
> On Sun, 2013-07-14 at 13:45 +0100, Mark Brown wrote:

> > Simply removing the dependencies is not going to give the clearly
> > intended effect here.  The dependency on the DT only machine needs to be
> > replaced with something, not just deleted, otherwise the driver can't be
> > enabled in Kconfig.

> I interpreted commit 383ffda2fa as a commit that just removed a lot of

Always provide human readable descriptions of commits in email.

> stuff: see its commit explanation and its diffstat (it adds one line and
> deletes over 900 lines). Moreover, after that commit the references to
> MACH_SMDKV310 and MACH_SMDKC210 both are nops. Deleting them can't
> possibly change anything.

This still doesn't have much to do with your commit message or indicate
much understanding of what the change is actually doing or why it might
be a problem.

> But, anyhow, what would be the symbols to use here?

Well, let's think about this for a minute - what is going on when
someone does a device tree conversion on a platform?  What is replacing
the board files?  What would an equivalent change be for the audio
driver?

> Besides, this patch was intended as a follow up to commit 383ffda2fa, to
> clean up two references it apparently forgot to remove, and therefor
> basically copied the subject line used in that commit.

That doesn't really help - putting in a completely irrelevant subject
line is a really good way to get your patch ignored.

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJR49wMAAoJELSic+t+oim9Wg4P90u6ZwB9wtBBV0kO8DY4xmTy
l5CtbU7W+vdv/7EX6rVwfjHU9u+KUh+JH7+B0NpuFjSmdSYkYYt64nE8kUF5c7dy
yn7NiHsCgpkmGhCCIUBK0DAHjhJWGWeiQAWFPuUNS5ObvGATPcdftikEnlr9x1cn
KCsRB5DpRsTU5tDjWz6BEPaK5BskPrD0Vt/9otxsbzU6RpZ60IUUjhePY8uH0Ry5
TUSXJYyt+QBW50Is1xQbIdepHnDNa/ruZFpHtaBJU3RLq7k9+n5aWfFOnV2FA5Ie
Db0dLW38E/fnIiuRrfSZjNlIrmmCXyysp2/3JWl6mZCb4r5OdVQDbFxl/vR/gOQR
QsslRFWGo0uqd+DofkDzvUMz/o2/VVnbrp2jeWstFSOiEEkOb3RKsfvqxFRw8bUv
f5/toDuYXz+OtTGOo0jiPKFep6RnIaeMGFBQUREgzrX071yzLNmrqENzTPmZTVwG
D3ULj+VvJVrxKRUKnVD3iRs0xqhrLdqttnX7IHUvI3GFtnEMYsTQJHZAccU2pIFD
whgfi30qZ77Ugnex3exFKztfgItc90wbg6uOSMMXAJbGwd/EQNnoxutPBMohf25P
i+KbW+MTp7oqTyxR0DV9dukOVDF0Zkra0FrdwV1mHNyP1xPjIYWY3wkxp6H6UpYi
7722I36asRmVY9FgZD4=
=L/lZ
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
