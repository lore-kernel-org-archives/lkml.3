Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3L3MRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:17:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50282 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3L3MRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:17:44 -0500
Date: Mon, 30 Dec 2013 12:17:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: shawn.guo@linaro.org, timur@tabi.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        b47053@freescale.com
Message-ID: <20131230121719.GS31886@sirena.org.uk>
References: <1387946404-24029-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hrnpeiJmytOBrElT"
Content-Disposition: inline
In-Reply-To: <1387946404-24029-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add disable operation for the
 corresponding data channel.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hrnpeiJmytOBrElT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 12:40:04PM +0800, Xiubo Li wrote:
> Enables/Disables the corresponding data channel for tx/rx operation.
> A channel must be enabled before its FIFO is accessed, and then disable
> it when tx/rx is stopped or idle.

Applied, thanks.

--hrnpeiJmytOBrElT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWRLAAoJELSic+t+oim9NzQQAJpEERFX5Z3sFpwFOVOrKEod
cCJ1SIGqsgSvp5ENbyyx4ujl2jJQBFbMD4chbFa7UbWjXvjrxbkPrwG+uk7jQlCo
f1ECZDZR8+ajt6aWmY9dnXX6nca+XUDVnYetfIvBJWUqeSpjQ31DAiEe0GKXf3gL
BNFZmT/jOXYu2aV34amlSWp/IfZ25UTCbx19YjW9DqoJdijtXV/k42gqqd5jPjlN
nHnh/FUwnr9k+Jg0CnJR3/QBErd5NU55JVAu++0XF/7jtfcLeiTHyFQBH50fXS8+
qtV+KyGRlhudDZngx/Qj04V686Mf6PDKl/LYslBwqNXI7ode5xIBgjy5nRih7htL
V68OE7sPxIHPw+ISFqznhFPCWd2Egj1fzOfBRGfbxdq9vxYkgGpxA5kW3H/VvRlK
CbhOeEM+QygOycH8iAn60wzM6VvmgPZapBunLP5PelQVHkLsKOCqWPAf0OFKJoLN
DNXE80FALerXiHmFZ/+DSBAwsLZjz+QCE7NL0F48Z8E0eVQZNbwHin6ILwx9dLZJ
iFZb8SM7UwX0XnpO9LHfO2ECdspRjpESONZbEJxEW4FJrF+c2mQiRsvGykGMH+fG
dma6QSlrQQ5YrbiwijWVQw3UYvfblXliOQapYniGeXFJ/rBAkadyAi18IguzexvK
QV5XaaKc/kEYfAn4VgJ/
=AgdD
-----END PGP SIGNATURE-----

--hrnpeiJmytOBrElT--
