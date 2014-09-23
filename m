Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaIWBFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:05:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58067 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIWBFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:05:17 -0400
Date: Mon, 22 Sep 2014 18:04:18 -0700
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140923010418.GI7960@sirena.org.uk>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <53C675E4.4020502@samsung.com>
 <1409825105.5546.91.camel@x220>
 <201409041802.36466.arnd@arndb.de>
 <1411033409.2017.15.camel@x220>
 <20140918175752.GC7960@sirena.org.uk>
 <1411077427.2012.6.camel@x41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yTlutJeUbbRRO0QT"
Content-Disposition: inline
In-Reply-To: <1411077427.2012.6.camel@x41>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 166.170.38.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung: Remove goni or aquila with the WM8994
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yTlutJeUbbRRO0QT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 18, 2014 at 11:57:07PM +0200, Paul Bolle wrote:
> Mark Brown schreef op do 18-09-2014 om 10:57 [-0700]:
> > On Thu, Sep 18, 2014 at 11:43:29AM +0200, Paul Bolle wrote:

> > > Done on top of next-20140918. Untested.
> > > --------->8---------
> > > From: Paul Bolle <pebolle@tiscali.nl>

> > Please follow the patch submission process in SubmittingPatches.

> Could you please be more specific? What part of SubmittingPatches have I
> skipped?

> Is it the perhaps the use of scissors? Or the superfluous From: line?
> "git am -c" appears to handle this message (and the very similar message
> I also sent today) just fine.

It's the fact that you've included the patch in the middle of the reply
to another mail in the middle of a thread after some other stuff; you
can tell this isn't the normal process by observing that your mail
doesn't look visually close to a normal patch submission - if that's the
case then people aren't likely to sit around and try to figure out some
magic set of git options needed, manually edit or otherwise special case
to special case it unless it's *really* important.

--yTlutJeUbbRRO0QT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIMcSAAoJECTWi3JdVIfQ64cH/2/QUk0EuKSNmD7qjgFbn3FV
ewc5aJlqwgBcYcd5LnubLp61YHeALIVfM7b++JjtNSwQsBLlOqTWp6F7Y1IHRwhk
tOpf8xlJ6ADbqfGlHUYwuvozZHepO9bMcemNc4CpTE68xcBMGrlRWEyYi1vwYW9p
JDS10eF1MhoVOaDEkjoVwIMAXBiUbPBfLh/WfGoFPyqsKzoy0U2lQ3eIPLwQrYxm
wbdiCFRmAAOQUJhYMvHGXXzJfHNf5AP6Px8B6ZBTzTXHMxZoCh4gVCxQEssHaBH1
7I7nVsK+XX5dgF2pOM+zlRFIgd9XcfOW+HZWH7av0u1nrnLe0sgfrIevARMI53E=
=1HDE
-----END PGP SIGNATURE-----

--yTlutJeUbbRRO0QT--
