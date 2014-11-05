Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaKESpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:45:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42290 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaKESp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:45:28 -0500
Date: Wed, 5 Nov 2014 18:44:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20141105184438.GI8509@sirena.org.uk>
References: <1415205892-5553-1-git-send-email-afaerber@suse.de>
 <20141105170957.GE8509@sirena.org.uk>
 <545A683A.9010301@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a7XSrSxqzVsaECgU"
Content-Disposition: inline
In-Reply-To: <545A683A.9010301@suse.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 85.210.170.115
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a7XSrSxqzVsaECgU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 07:11:06PM +0100, Andreas F=E4rber wrote:
> Am 05.11.2014 um 18:09 schrieb Mark Brown:
> > On Wed, Nov 05, 2014 at 05:44:52PM +0100, Andreas F=E4rber wrote:
> >> This enables the snd_soc_snow module to be auto-loaded.

> > Applied, thanks.

> Thanks. I notice you dropped my Fixes: line that SubmittingPatches asks
> for. When do I need it and when should I leave it out? I thought it
> tells GregKH more precisely which stable branches are affected for
> backports than just a CC.

It's not really adding anything if it's just identifying the patch that
created the file in the first place and what actually happened here is
that I applied it without the tag then later went back and decided to
add a stable Cc since it was probably worth that.

--a7XSrSxqzVsaECgU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWnAVAAoJECTWi3JdVIfQzDcH/iyWEAs3xvkRXU8qDtNuEgPr
kay9p+HJ/dRc20hw7bqjxnjCzEefu0kgLMjzSwqIX7QcUiTn9XmqoNfkEEz+DvLO
lGgpPai53oHZPSjSwC0AQmYeTnZzDw8xJJW64K4CbKj+8pTSK3rUyToCyGh962C+
kJE5iRqIUaiVmzutEw5oIcQYNbXOQ6rKltb8VDK1SF/YKfum7wPkBmmktB7SkfPZ
3qaFq0PEsn2SbzYFqaJU7r4HhPp8WsO+l91PWnole2Gc6t40t1vgEHQikip6T8RW
TGr5JsCXcRgKMRbv+UXvAU67BKQ/dDSX4kHFybzEy2XwYf9L3iJHDz0vOwPJRhY=
=xYy6
-----END PGP SIGNATURE-----

--a7XSrSxqzVsaECgU--
