Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862AbaFUKWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:22:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51793 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343AbaFUKWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:22:46 -0400
Date: Sat, 21 Jun 2014 11:22:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, acourbot@nvidia.com, gnurou@gmail.com,
        j-keerthy@ti.com, linux-tegra@vger.kernel.org
Message-ID: <20140621102229.GO5099@sirena.org.uk>
References: <1403285183-15926-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v8qIemIc9aARI1kK"
Content-Disposition: inline
In-Reply-To: <1403285183-15926-1-git-send-email-nm@ti.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: Fix SMPS enable/disable/is_enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v8qIemIc9aARI1kK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 20, 2014 at 12:26:23PM -0500, Nishanth Menon wrote:
> We use regmap regulator ops to enable/disable and check if regulator
> is enabled for various SMPS. However, these depend on valid
> enable_reg, enable_mask and enable_value in regulator descriptor.

Applied, thanks.

--v8qIemIc9aARI1kK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVziAAoJELSic+t+oim9sX0P/R0RluukDF7FH7LD5M7wlFAk
v50GMWpJD3cvOlxLOdCA/qV3Q/3O6o0ekfF6b6Lfg9xhrYdmskNOFtYctT6LxYMZ
9oPWPP9W9ij1Szw7B0h+AvTxyPzsREH4AnKaVhM91rStAOku6KlZ6R6n+DOLHpVK
6bkLFW+LU0uYgWNVsD9SyFe3zvJwYIR76oevJK+t8tbQoXjMHvxppaXntd7pEts5
JA4Qu7KL5LMNV7iAO+cu5j4lu/AnsUAk+cto5rfvBYJ/r2fc1flqzs85hF/aDyG+
U6OB7p8YeRz7Jy6AZYpSSHOghNeKeW2DBbmwZqXnTRsLTWzxpUBaQWJ3WxXp3dTR
pjS/ecivOhok7cXSsmJkSk9EpZKYc6eM1YU4Svqsa9p6MhKsI7jNkEUC1IQoTNfB
GVEZQChtNWdlETSexspjAZKCoUiqpphqvPW+S9ZvbKYjyEEGJknyJ6Hr8V9bi5zI
ny79LBvfvsSl5M5A2Xb8EC+XIrXttZ69zb/ilM5KNu1E4nTkB5CV1knORHw1W+yS
frc3+GP3cFD4dkUsFaH/VpdwBiDEbaR/0ODGEJ26Mr3FdewynJsiV4zhY2nht3zo
rhJUTQZKFbFD2jD7dtvMmHM1hDzgtT88uSrA4x91tuJag0DToqKrBy0mJn2rmfsK
AcAeIcxxw0IJfweYZy09
=x59U
-----END PGP SIGNATURE-----

--v8qIemIc9aARI1kK--
