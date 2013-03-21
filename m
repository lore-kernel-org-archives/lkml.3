Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3CUSpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:45:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57259 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab3CUSpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:45:05 -0400
Date: Thu, 21 Mar 2013 19:44:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: max98090: Remove executable bit
Message-ID: <20130321184458.GH15926@opensource.wolfsonmicro.com>
References: <1363730323.16270.11.camel@joe-AO722>
 <20130320095758.GD28775@opensource.wolfsonmicro.com>
 <1363792936.16270.30.camel@joe-AO722>
 <20130320163627.GS28775@opensource.wolfsonmicro.com>
 <1363820072.16270.43.camel@joe-AO722>
 <20130321162503.GC14768@opensource.wolfsonmicro.com>
 <1363886175.30275.10.camel@joe-AO722>
 <20130321174440.GG15926@opensource.wolfsonmicro.com>
 <1363888393.30275.31.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="itqfrb9Qq3wY07cp"
Content-Disposition: inline
In-Reply-To: <1363888393.30275.31.camel@joe-AO722>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--itqfrb9Qq3wY07cp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 10:53:13AM -0700, Joe Perches wrote:
> On Thu, 2013-03-21 at 18:44 +0100, Mark Brown wrote:

> > That one needs a bit more taste and thought to work out what's
> > appropraite than can be guaranteed easily with a script, things like
> > working out drive level prefixes for example.

> [perfectly useful git applypatch-msg hook script removed]

No, it really isn't.  Have you tried looking at the output?  It's not
going to do the right thing for the subject line here for example, never
mind any other cases.

> > No, that's going to leave essentially every commit that needs fixing up
> > still needing manual fixup.

> Then I'm sure that's your job as a maintainer
> to modify whatever patches you get to suit your
> taste.

One of the things I'd really expect that a frequent submitter of trivial
patches would be doing is to make an effort to improve the quality of
what is being sent.  If it's at the point where you're sending a lot of
patches and it's more effort to apply them than to review them there's a
problem.

This is something that generally causes no problems for submitters...

--itqfrb9Qq3wY07cp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS1UhAAoJELSic+t+oim9qy8P+gKkW6aPcgmcIB0oEYuy1tRV
QnKaB53y0s24rFLlIS4TgX/P9tDRGHFV0KRZ3WqJ+raD8gUrdH4LuMS/jfPJLh+3
CwqWk3fV2DPxV/m1xFAGwrmcZY5/nXSXj9ZU1RmGAMp+Sqj6NKNOAJK5g9TciAYj
/PuZyST0fypmMEQSg4bf9izhEpdxoDL6u/dE+ePXAepGamZYzOE7vg8OqUcV4u32
c9v48lMTY+GtFN2EWK8FoG/fb5rE8zdkTFCvZTpOL7JLsusOBStdzmDzTwzBwQB3
s5lz4SBy1WzeKhTfWsgQO5r+YCUq0ytshJmTe6+QLDYRCC4RYEfgKL3daSBiSMBU
4Kd2Dy5due2yh7lM0uD5cW5CzyjeB8PaVtNKPtpqyjXB9xkDO5Q0I+n7rgPFPxNR
tieywgDpM54Bl7eKXRDJ88OJpJ3NFRR4RhIEybgpOhTFAAo7IYspfYaM2E9BQOAP
aNAkCuWPnpcG3nk8e3qxzge5e4wmgmnpGGj4zva/O9bzVhxpLLmcQZk665cth+so
qbDHbdiEZ3Fx5/Wefz+IEVnSvUuMt00N0nMWoj9P3rfApalJzcjCGnJE4mtaIA40
NcPtTwmAxpyeO8aNgXI7ujFvtk+OWjBBPLXo4SaVS8pBIxYfJIZ4sZSXcQrvzcy+
OPtPMZ3tDAYnLK6qk/MC
=4mVX
-----END PGP SIGNATURE-----

--itqfrb9Qq3wY07cp--
