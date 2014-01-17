Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaAQMWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:22:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55973 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaAQMWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:22:31 -0500
Date: Fri, 17 Jan 2014 12:22:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Matuschek <daniel@matuschek.net>
Cc: alsa-devel@alsa-project.org, Dimitris.Papastamos@wolfsonmicro.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140117122204.GR17314@sirena.org.uk>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSu31lw3TgkWXnjh"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in
 PLL generation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xSu31lw3TgkWXnjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2014 at 08:34:10PM +0100, Daniel Matuschek wrote:

> WM8804 can run with PLL frequencies of 256xfs and 128xfs for
> most sample rates. At 192kHz only 128xfs is supported. The
> existing driver selects 128xfs automatically for some lower

This patch doesn't apply against current code.  Please check and resend,
=66rom MAINTAINERS:

SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
M:      Liam Girdwood <lgirdwood@gmail.com>
M:      Mark Brown <broonie@kernel.org>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
L:      alsa-devel@alsa-project.org (moderated for non-subscribers)
W:      http://alsa-project.org/main/index.php/ASoC
S:      Supported
F:      Documentation/sound/alsa/soc/
F:      sound/soc/
F:      include/sound/soc*

specifically the for-next branch (or ideally topic/wm8804 for wm8804
when it exists).

--xSu31lw3TgkWXnjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2SBpAAoJELSic+t+oim9G2kQAIZ11cX/PTvle0LQg6YOPsx9
ola/4o1I4JEWwvRYcIQ8I4o0XjDXgNM3z7Jy/9+h1r+jqm0tyhsQ24IaDLGI95ZN
EFOTOfVIEaG0nNvLFokMFbJTugl9qWa1vYcxijtQJi7k59Lc/X2aM6XRE57IeGNN
k1RZNxpmR95CIGP+GtzVYjWyWS4UcD12MWg4c5wF1qvsvGd1B2F4glPOHstCxrD1
bUn+pZf79ACZCvtaV8Pes89qe0IM8fWK7pU+4ih43JN+FZXGPmZ9eyzB2OimF13q
FGVppMvJdOmUwIhFKNvGhdGAnRkK4C7XJ559jwH2KX1nFzwOboA/OplLzRBCa7/4
pHCK1Ag2MAGfNmTokI5O9V8ZDajoLkEkUH5fSGhbJsIMO9xvvsKelUb1xSE56FHu
kQdLaJx6WZFaFbYT6clXkF8jOqU3+otmi7QSt44kp+d047NsDmPbSAq9REx0k8os
0cObIR16WoWwbKy1Gc6OCLewmABsDQczropNDrAShtWk4MxIZlOycn6GMemtBF7L
q6avqsK6fByC0CnZi1HYHEKSEL9ZD1iSBpDDsjMhYnqYrhKHq/Llm2Ofdjz7/OLE
yOpbdJVjeeRtSeUswyapWkYg2IV383Q2DJ8Bbx1S6w07/7lt1eTBMcrxXyN/kyUY
SV2K693fKrVpg2RVNsvj
=L/wp
-----END PGP SIGNATURE-----

--xSu31lw3TgkWXnjh--
