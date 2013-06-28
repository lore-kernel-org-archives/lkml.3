Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3F1L4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:56:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52258 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3F1L4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:56:24 -0400
Date: Fri, 28 Jun 2013 12:56:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, xiechao.mail@gmail.com,
        Yi Zhang <yizhang@marvell.com>
Message-ID: <20130628115621.GI27646@sirena.org.uk>
References: <1372322764-26070-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Or+E1gVcyGxE6cpa"
Content-Disposition: inline
In-Reply-To: <1372322764-26070-1-git-send-email-chao.xie@marvell.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3] regulator: 88pm800: add regulator driver for 88pm800
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Or+E1gVcyGxE6cpa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 27, 2013 at 04:46:04AM -0400, Chao Xie wrote:
> Add the regulator driver for PMIC 88pm800 including device tree
> support.
> 88pm800 is an I2C-based power-management IC containing voltage
> regulators, a real-time clock, and some general purpose ADC devices,

Applied, thanks.  Your table based list and map voltage functions
actually look very generic so should be added to the core but I'll do
that myself as a refactoring so this can go into v3.11.

--Or+E1gVcyGxE6cpa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzXniAAoJELSic+t+oim9YZcP/jWAJUi/d29/bcojir4RRgCc
smxAly+l/asqqfzOhZlZFcbWQWB7E1sTdi64HnVHBCyxUNrGfICCI5spQ1acA87K
dRJokwJ/NdhKet+HafFD6Pu15f5DrnoMaXNUELcy3QwgWYG8pIkCe9czyxGi2E8U
mLtSr7Jmk/ZOwHC0EcLrEuxcENRsEmcC87ukWfxrgRg+F5066N6c4XAOap0YMxKL
rwTaVBbLWXFciME31yLu7yAmO1o4h5XJdyy6xvHYxoGR5oUcE77K8pyQKpJCpHXf
wQP+TRf4XpwXi96zbNb7qVfH2erdWOkruZ6ZDS9jTJteopdE5OT4qND9CL0vzv/I
JHmGcEG+Eq65bbR0wu0rHTalM53c0lMBrShK0qaD4N5DMoO17ATX4GWb1FAaf8GI
Y+GfcLBF/pvwms9OX5a6EVm6zkCoDaFxhCZqSIPdt0gTLrjuOIl4JtzjdyHAO2AT
k9qeaudfiY+nCIlGHgMjNJ8ZcGxgn4xjKTvAVjqykesu2UvrEJXZClTXDg9JkP0s
jYR4H/Vqw3zaN6ctUDSqaOO5wAioUlT28iIy5Myfmv7uu6c3ZtutQaSnHW1lUt2z
3tpwuEoqVeRaDQlW5Zp7ay8BcYgiMlYe2/pALFLHtYetWxqLnp0hkBbrVc+eQF0W
8Jc4P6X51A0HYeSD/XVb
=xGmG
-----END PGP SIGNATURE-----

--Or+E1gVcyGxE6cpa--
