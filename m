Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbaGCKpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:45:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44653 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbaGCKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:45:17 -0400
Date: Thu, 3 Jul 2014 11:44:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <20140703104432.GV410@sirena.org.uk>
References: <20140702183841.7c964832@armhf>
 <20140702165628.GO20799@lunn.ch>
 <20140702195154.47d6f6b4@armhf>
 <20140702194252.GN410@sirena.org.uk>
 <20140703074959.7c489912@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="thwsKKN5whlRGe6j"
Content-Disposition: inline
In-Reply-To: <20140703074959.7c489912@armhf>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--thwsKKN5whlRGe6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 07:49:59AM +0200, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I'd expect this to return an error for the busy DAI rather than just
> > silently ignore it failing to start or (better) implement some control
> > to let the user select which of the DAIs is active.

> This is not an error. If the audio subsystem (DPCM, not the user)
> chooses to activate both I2S and S/PDIF, this means the HDMI audio may
> be taken either from I2S or from S/PDIF: both inputs have the right
> format and rate.

Your board happens to only be able to present the same input on both I2S
and S/PDIF but that might not apply to other boards, they may be able to
route different signals to each which would present a practical problem.

--thwsKKN5whlRGe6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtTQNAAoJELSic+t+oim9kCYP/1PZRjnVbG8twwFDebfaR2P9
l/MsRKR4D68eHTLCkU1BzRNefr42P9v2ZiWmWVwBG/agQvpKp9MltfbR7AbUR4aS
tYZtY+mkJ5DC7vwrNSMoUa2TcQdOJe6coqYk4qFO0SYDq/jXljajA4jYUrvX+LQa
KomDovrCFWNDoliDHTSzinyk3zHYrDRH2t4HrRu0huIXiRBVLD1ipF20+kbTdsJu
a0/2cyntUYOLJVwNBzp+egoEoreET8+4+02bb0SSoSk+XT5jv7EegtTtJEY3DBYN
wP46S4OvtlpR0bI0nB5/UfamKD2GsccGO8gKzVpmeJghUcAgr1Rvkf5pKEZNW+8t
3CoRCZr9ubaWiSAJ8cNT8FnrtIE6c3Tf480q/cfDLF6+bp5kJ0bzv/TRH3ZVrzyN
Tetx3ifdnK9ciwRvESyw4ZdYn6KaZeG9lyiJv+EOVzvCbK1GRP8tdIc9lVf27AL7
W9fYzlpuQ3SZQAJvUMiImIvucGvFSU5UjD0u8z1BuDK5NVDp0GYPphXseZvm1yaP
1mVlBe5vpMESBmkseA08vtwg3zKTj3s3Y6qzeNAfRoRmIWVa8wtFc62eVo23nn+G
NTRrU5YsSJtxG6DgEOXoXtSoIvNmaZxt70TlCI48Rm4JxAkWDyFK5qP17SYtdsG5
lhIhHjGXg0wmUJMAggrk
=r83t
-----END PGP SIGNATURE-----

--thwsKKN5whlRGe6j--
