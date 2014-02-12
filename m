Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaBLPud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:50:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40880 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaBLPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:50:30 -0500
Date: Wed, 12 Feb 2014 15:32:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, Guangyu.Chen@freescale.com, perex@perex.cz,
        tiwai@suse.de, shawn.guo@linaro.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140212153202.GU28112@sirena.org.uk>
References: <1392104569-27792-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AonAANj1daC6QcQu"
Content-Disposition: inline
In-Reply-To: <1392104569-27792-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: fsl-spdif: big-endian support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AonAANj1daC6QcQu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2014 at 03:42:48PM +0800, Xiubo Li wrote:
> For most platforms, the CPU and SPDIF device is in the same endianess
> mode. While for the LS1 platform, the CPU is in LE mode and the SPDIF
> is in BE mode.

Applied, thanks.

--AonAANj1daC6QcQu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5PuAAoJELSic+t+oim908oQAIYbd2MZWgXVaE4iF63RaROu
z0iNBNUrGecXgKD4lixfUvvJmgkMxV4+J4HmtFvELnszwRyIILI9h2UtGOQFZg7r
6FzGlxUhzEHqDdtVI7V2oShKfUrRf7SFX6Xw3lDLjUx9keZnbCWqCKS/Yt8HI6N8
4cn2eO2hbNCx3uCjDqDMsfV6+N39hkhaAO9bL14D3oHHduq4fQGb+OCAV2vS+9OZ
/0aSF8Ze4f+F94SLHtkn42Yyw7S7rxyJMvr0p4GVjYtTzInWHG4BogaplxgHLdNj
Rls/ZekvQcctT39pOiJSGOfOora9VQStINhZgVe6q0Rdavr2WoR2CS7OI8Rdnppy
Ec76v8c7aeWBnCj1DyfMkr+5ZvPMgn3yXSTPSh+KPHbl7o10edLjKrPdshtYidRu
ONp1RBVp2Y147APL7S3pjTl0VADFUPBNbD0kMIGKzAsUTbpRvAu2vD4+if4L+2HP
qh0d5e2HMtboi/LbxB3lJMfShuif31roSehXkf2NZ2zlo7rnenonGVGsV85jRc+g
7ctWWjopz9L74jsvCJiGN/mv+PdNXp8fFgJ1t9/CjTAP7YPXWzprmgikoVlSAW2a
r8uWVXt6r5vvVzqxKNnfUdWUHNBfeRN2hAOd/UxjW9SnN8lqb7J4UrxWYfoquaNN
bSopPqdxnRoMQzHlp+7R
=183T
-----END PGP SIGNATURE-----

--AonAANj1daC6QcQu--
