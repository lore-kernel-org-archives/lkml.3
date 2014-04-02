Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbaDBTxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:53:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50480 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbaDBTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:53:16 -0400
Date: Wed, 2 Apr 2014 20:52:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140402195258.GN14763@sirena.org.uk>
References: <1395389720.29259.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jdM5ZcN/ZcXXVwZs"
Content-Disposition: inline
In-Reply-To: <1395389720.29259.1.camel@phoenix>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s2mpa01: Don't check enable_shift before
 setting enable ramp rate
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jdM5ZcN/ZcXXVwZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 04:15:20PM +0800, Axel Lin wrote:
> Current code misses updating the register when enable_shift is 0.
> e.g. S2MPA01_BUCK4_RAMP_EN_SHIFT is 0.

Applied, thanks.

--jdM5ZcN/ZcXXVwZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPGqWAAoJELSic+t+oim9gvUP/0EFs+PVrCBQkw0EuiSklrrc
l9zWaXHCjwhFr+Gwsty+NCcuqXU4RwVV35pdgvff7mdz0m+ISemGanSI84u9qS1L
YK9k8YRFN5xrur4JT6KFAB5hHuYFmKQtq452Mq3guhjeZl3kcXQJMc8fe28LhLEN
+gMhFhAC7u39NZByaJO2cHZrwkjTg8bUqj0I4QX9GzE4KMw7oqcUiKIMGxgqDNND
vbD5ZpsobWL7EJ0pFcaCm8W8xJZtguFKEQw3g5kpBhkdk55hd1DyWCkg6uOvsvCo
ErdbfWb4A1Qe9ZCCEn/Uep85/KLUslDokvjGTSSaUPf5WLkvTBCvVJ8NtNeGdVEx
3LyPSMx9tEcAZnlKoudkpnZ3EDnuA3scLdHDatWaEmKnXKo3sPbAuVzN9sjU3G+n
zeKMsEepm+MXGq5zehqPQVXQWjoCLJ3xrry4zlYKArq3peWFvruIkcIx3eofZ61S
tMBoV6KuhJXGEvPJTzSfQp7/hsZmQHkaZTDaKB/ubGJTBqC0FQWdAAyrH4z6KeTU
Bq8EnqfwSYBRy8gqyeZnSu68DBIcOM6kwj+IrwfZnprWWOmmpyiVQWWyvZBb6hfF
OP14PsXHR4VvhnjGLzwwyksOp/LgPj/volcdPg43HXPfgNqVsLkTeI8WP9q03CWM
AL5klUZgg2s43XdxP+tc
=oVh5
-----END PGP SIGNATURE-----

--jdM5ZcN/ZcXXVwZs--
