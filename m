Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3BOW3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:29:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3BOW3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:29:02 -0500
Date: Fri, 15 Feb 2013 23:28:58 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pwm: tegra: assume CONFIG_OF
Message-ID: <20130215222858.GA14441@avionic-0098.mockup.avionic-design.de>
References: <1360965742-19744-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <1360965742-19744-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:je4wLKxqjYqAkuhqb6dDcssR3L69OH1vY128IAHCqqx
 FFu5UKs7zdqbVoIQHzbMFyqMHh6O72t4SNtGmMCaPOPdnG8bBS
 kCWXSdVF1rXkg27KvrOPaVrdFptEOdGA7tNWVZvoKFMRhMWKgi
 pfTGARao9rWLn7UFSXm0aNEc5/SCIUQS7Y8ilqYkG+Gpav3s7A
 lLWy+ht+HRiP75QETmaue4J2+INV+xCCKOqePk2Cy5ExOMfMs3
 EELwoO4fWkftenTxbSKQUZJ896hZwrKNqsQ4fOiM4m0MIcF5nY
 uJr+za0noR7xeez4zLBzd2NJ+uQuDsU8Ys8lr0qOVi4Dp8LBcQ
 w3BP5/Tt2zSGaUTJwzyuOuQjXLE1eF6VXwHNgsFeFyv1JyD1Wi
 a+49qVzxU48G0PHiSMQSwqbKE5aFix/cK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 15, 2013 at 03:02:22PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Tegra only supports, and always enables, device tree. Remove all ifdefs
> for DT support from the driver.
>=20
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/pwm/pwm-tegra.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Applied, thanks.

Thierry

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHraqAAoJEN0jrNd/PrOhbGwP/Rq5azRbDk0dKiZzp6Cf/Gbr
V/qhhRsHNDmK0+ffmvqIulKmBrUNsU5u0RANnU580CfD4vEespm23mFOQx2RjriE
lfkpE8pxCBvIDxjZWFyrV/ZCARuX5YbWkKw2hFqZi8eB7RC83GIXUYXP+dxseBcN
yNKYBuWoNYHHjmqjdLX9+9pVGN7um821XFRb7Z8sbPH0D+O/1aG51D6j4Vkrukav
LxFZubyqQrxj5x9Shr9PKT+r6pbUe/NJbMvy2v2qSkMiOd2FS/gDXwyhLurqn1Vh
288lvMwpsdYpq27vMEeIez2af/cdi4ZAy7VK8uaLUYDeccOkX7SR8fqFoRyq30Zh
NdlFCsbiyznNPS9LCRO+weNxNUkmeu/O2OFixoVqT9PEYVeE6Hi5cM06a4GcXDB4
VkLAbCy7FYkdONj0Jv+CoB4tKtVeMKgJ+yyT1+L/EQLHBDvT6nUyp9rVF7oe6Idj
zmHc57nEKL4aD/bvXHFNvoEz5REoIyCsG7gCNFtMwaifJbtnXH8WX6VMbOpdn0HG
hjvaUcNkS5HOPkyIRM1d1jE6r7jAJQ5LRAvLHrFIeXUYFf0wdo3c1UKQbbEc0mVR
ScvlucIdsoDslLe3Ui51i/3nDSy5u9fH2wAjafSaG03jGwOEG0iq7hjtW4Dx1l2B
GhybQaoHEyHmaupTiJ9V
=01kc
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
