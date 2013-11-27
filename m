Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3K0L1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:27:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43139 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3K0L1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:27:37 -0500
Date: Wed, 27 Nov 2013 11:27:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Li Xiubo <Li.Xiubo@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Fabio Estevam <Fabio.Estevam@freescale.com>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "oskar@scara.com" <oskar@scara.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131127112725.GT14725@sirena.org.uk>
References: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
 <20131126134411.GQ14725@sirena.org.uk>
 <1DD289F6464F0949A2FCA5AA6DC23F828CE2A8@039-SN2MPN1-012.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LXsBfGm2MIDJcXyT"
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F828CE2A8@039-SN2MPN1-012.039d.mgd.msft.net>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LXsBfGm2MIDJcXyT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 08:13:03AM +0000, Li Xiubo wrote:

Please fix your mailer to word wrap within paragraphs, it makes your
mail much more legible.

> There is one dependency patch: "regulator: core: Provide a dummy regulato=
r with full constraints".

> From the dependency patch, we can see that using regulator_get_optional()=
 instead can resovle the problem you descripted above.

> When or will this dependency patch be merged into the -next tree ?

That patch is already in mainline.

> > I'd expect to see a commit description that describes how the driver
> > currently tries to handle this, why it doesn't work and how the patch
> > fixes it. =20

> The SGTL5000 requires 2 external power supplies: VDDA and VDDIO. An
> optional third external power supply VDDD may be provided externally

You need to put your working through of this stuff in the commit
message.

--LXsBfGm2MIDJcXyT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSldcaAAoJELSic+t+oim9E2EQAI7AD+oeSU7Pn36guJfIdYx5
hMe6zX/4xZBPjGBrypWJhHKE8fNVTJB2SgNG0/VuIecAZvzHgFNMFEm75WEROxuC
DD6qhCZEKdVWq4/2k5kMLKvFfaAirVa8+WKsECGnGPPJpkjPsY63ebdE+Ew5WE6z
Zewm3J+SiZlpOku3T19Bd/dnKfhWJ9Mxj4bwWDL/PBXnQTr2f10vIMBwJQ9TXnO3
REAF5Te6x5owib2BOa0jwGySTooZfMK77unrgaKkZ7dJSWcHxVPp47XmiiafxS1v
mS8Bpt+qIwYXH/iXoWCtRKAolaqCYJ+nDZmet4UNhN2h6HJp9bN/F4kNTBSH3lsc
N68Prxxa0T1Xmg99cvPs+fUz2lkgXYxJxGnyG/gMWNTLJsc3NGP0oVbyhZsivNNP
oAfVcoNmKcRb9qq+om5xROjUu/T5np676RnGk0fJ/NYNxscov/9MOzs8bpejjwAw
m9F3sSYXzZT6DyAUo39GKVyuhV9autABfxx+1swjiUN/qTleRV2Ly4b+GiBBKa+t
M4g5Upv0pPz9OoU+YfWGb22aYLSLt8vr1nbpC2AurI5lcpr+zkqT/n8ZtB2uVXWD
+X0e/Wu/qlLLUbCjMzCsC5MT+32O3mDDyjj9guVKImxVo1CxVSlEqyGtuApzb9QD
JU3I1JzgLLE5ubDkbhLi
=Tbuk
-----END PGP SIGNATURE-----

--LXsBfGm2MIDJcXyT--
