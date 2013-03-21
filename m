Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3CUUhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:37:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab3CUUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:37:13 -0400
Date: Thu, 21 Mar 2013 21:37:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: max98090: Remove executable bit
Message-ID: <20130321203709.GJ15926@opensource.wolfsonmicro.com>
References: <20130320095758.GD28775@opensource.wolfsonmicro.com>
 <1363792936.16270.30.camel@joe-AO722>
 <20130320163627.GS28775@opensource.wolfsonmicro.com>
 <1363820072.16270.43.camel@joe-AO722>
 <20130321162503.GC14768@opensource.wolfsonmicro.com>
 <1363886175.30275.10.camel@joe-AO722>
 <20130321174440.GG15926@opensource.wolfsonmicro.com>
 <1363888393.30275.31.camel@joe-AO722>
 <20130321184458.GH15926@opensource.wolfsonmicro.com>
 <1363893405.30275.39.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdEQJo40s7ofW8iR"
Content-Disposition: inline
In-Reply-To: <1363893405.30275.39.camel@joe-AO722>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdEQJo40s7ofW8iR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 12:16:45PM -0700, Joe Perches wrote:

> The commit isn't in -next so I have no idea what
> you actually applied. (nor do I really care btw)

The fact that you don't care is kind of the problem here, aside from
the extra effort involved the active resistance to change isn't good
especially given that you are keen on things like get_maintainers and
so on.

> Did you try it?

> It commits:

> ASoC: sound: max98080: Remove executable bit

Which clearly neither makes sense (think about what that means...) nor
is consistent with other commits to either the driver or the subsystem.

> If you're really anal about it and you want
> sound: for sound/soc removed,

Yes, of course.

> perl -p -i -e 's/^(?:ASoC:\s*)?(?:sound:\s*)?(.*)$/ASoC: $1/g if 1 .. 1' =
${1+"$@"}

So that'll work for this particular error but then will fail if someone
mistakenly uses any other prefix and won't do anything about the driver
specific prefix. =20

In any case this is not useful as even if you concoct something that
fixes every possible error it still doesn't help with the incoming patch
queue since searches don't match, the rewrite would need to be done on
incoming mail and that's not a good idea.

> This is a "your taste" issue only, and do keep in mind
> mountains vs molehills.

The reason I'm complaining here is that you routinely send very trivial
patches which don't apply cleanly - sometimes they don't apply at all
since you send them against inappropriate trees as well as requiring
hand editing.  This isn't a good pattern, it should be changed - people
who submit many patches ought to be examples of how to work smoothly.

--sdEQJo40s7ofW8iR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS29RAAoJELSic+t+oim9WB8P/21P4agzAEI1ADgjxTa1/XRF
fWu0MsDKOMSrwYQFCY48kJ6Nuzr5r3vOK6l/c8b7jBbKhgLfj5iG5Q3x9WECG9rf
7l1u229BadxSLsUpQvK6SyhHSvhDznvfFV2xHzWT6EYIaocN1mtwNq+4pfCYDvLg
0BC6bwfoGSXA4PdK/IFVToF7VpfBaik8QTuTDLvH5zS1PAT+F8Ggd5JL1rFc3RmA
F4TKDPrGNqHsiM76xGyZXR7P3KQ6mPvZNKe+6OiZxUCin1j89ADNIBDsEe96/+20
glkv+3IbQnrQZyW2CLgHdl2u0nXEXCBPiUETPGhMm3e+cRtzrSubXzcKPaKnPxHe
ZdOU1K8rOPwA1D3+tpc3XpwkYaTBa8MGHRhA9Q8bNvYFnr/7pmlAcKvTEtfKMccD
/LdwfcQ/IzXDcwbE3laisOtefaJn36YNFitBTTKmblLxyMQ6LbQzmOhJDtYrAlqK
GnF0Vfk8/GmZDjH2DJcGrUzOJcIa2XDuRuRuT5J0nc1Ouf15qfXE/pKQiuDJgWk3
tZJejTLh4366wXp3GwVbvKXCqwQylJo6igyGjDCRMeULOX9wobswUOTpeOTeLgVm
hCanH5Z6yye6TJIyKkeOoJsV/GYWFMOBjw+qtc+bbSoFipvqNUhGBbeXTSJNGWj9
datkgnf4SDe2/RtbZACH
=q+C1
-----END PGP SIGNATURE-----

--sdEQJo40s7ofW8iR--
