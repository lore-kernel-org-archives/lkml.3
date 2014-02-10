Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaBJONb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:13:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40060 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaBJON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:13:29 -0500
Date: Mon, 10 Feb 2014 14:12:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140210141255.GI1757@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-15-git-send-email-richard@nod.at>
 <20140210114154.GQ1757@sirena.org.uk>
 <1392039072.3585.15.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fqSO13Wp+IaiYtoI"
Content-Disposition: inline
In-Reply-To: <1392039072.3585.15.camel@x220>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/28] Remove MACH_SMDKC210
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fqSO13Wp+IaiYtoI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 02:31:12PM +0100, Paul Bolle wrote:
> On Mon, 2014-02-10 at 11:41 +0000, Mark Brown wrote:
> > On Sun, Feb 09, 2014 at 07:47:52PM +0100, Richard Weinberger wrote:

> > Please fix whatever script you're using to generate your mails, it's
> > generating corrupt headers.

> I think Richard's mail didn't end up on lkml. But it's pretty clear what
> it must have looked like.

I can see what it looked like from my inbox, but my mail client can't
understand them at all and hence didn't think the mails were sent to me
and just ignored them when hitting reply.

> > >  config SND_SOC_SAMSUNG_SMDK_WM9713
> > >  	tristate "SoC AC97 Audio support for SMDK with WM9713"
> > > -	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MA=
CH_SMDKV210 || MACH_SMDKC110 || MACH_SMDKV310 || MACH_SMDKC210)
> > > +	depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MA=
CH_SMDKV210 || MACH_SMDKC110 || MACH_SMDKV310)
> >=20
> > Like I said to Paul this isn't fixing the actual issue - think about why
> > the symbol was there in the first place and why it was removed.  There
> > is a problem here but this would make it less likely that it would be
> > properly fixed.

> Would you mind going through this one step at a time, just to make sure
> _I_ understand what it is that you'd like to see?

> If so, to be absolutely sure we start from the same point: do you agree
> that the above line now effectively reads
>     depends on SND_SOC_SAMSUNG && (MACH_SMDK6410 || MACH_SMDKC100 || MACH=
_SMDKV210 || MACH_SMDKC110 || false || false)

> because there's neither a Kconfig symbol MACH_SMDKV310 nor a Kconfig
> symbol MACH_SMDKC210?

Yes, that's correct.  Now, like I say think about what the symbol was
there for in the first place.

--fqSO13Wp+IaiYtoI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+N5kAAoJELSic+t+oim90wwP/2oOne9yTniYTptfI7IhQqtI
jWQGwXNQpnaoHisLbF+X7nhkyw9IgsdwrwY3cm+BnXNaXLwkBAJ2X361vddSBQIc
ojjBn5Wsx9iXgL+4fIx44u3jg6zfP8GCPIdsa1Xyahqln2b0+aFwl59jrRCX3yLu
PIkRueRbfkktWJ4bA5pWITu+8y+XKaNOYkhDbQeVLJXRumn9VANlsoYbkWCKUvgE
h33MLYOFdjkr2GxhmTL42Oq0bSrcfZaTzV9xyE4ZE9LCqBKJku7EywSbmI1i3sII
0zkGMHJ912B8Pl/8Ry0+IR4Kfu71wzPvbFYYez1T+swFa2frAdcQsscYWtT1CUaA
pT4KEt1FRe2htUtAEg4Df4xVCvUry8pZ7331Tar803x2olY/1sWWadD0EE8I9rLd
ul0IU5XI8MbG4vdEqXr/t/fw+XiHa72AfiAJrOv7c8m0s6j2RRiOQQqi0CgvIGGS
wYHDG2d8DqIaodYB8zPlj06LWsXjk5Fxd/0CX/Dh3kRCJBYABUH3apwaewl7AqR8
bmK3odcwxYrjoDYQWocvhbnPGX/CuW9Ju2dEGH64zT6+BS1saWJFSyifokKGEZYO
8UxDV7QJgulQfwUsKEhU7zGLHsI8Dwj2RmrQvt4ZBjzilMCeFWy+XXJIeczxDkrA
+X9ShkKEOvtKeocb9mps
=LDwP
-----END PGP SIGNATURE-----

--fqSO13Wp+IaiYtoI--
