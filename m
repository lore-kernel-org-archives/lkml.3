Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3FCKvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:51:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43729 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3FCKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:51:33 -0400
Date: Mon, 3 Jun 2013 11:51:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Maarten ter Huurne <maarten@treewalker.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Message-ID: <20130603105129.GE31367@sirena.org.uk>
References: <20130601190850.GN16790@sirena.org.uk>
 <1370211326-32115-1-git-send-email-maarten@treewalker.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Content-Disposition: inline
In-Reply-To: <1370211326-32115-1-git-send-email-maarten@treewalker.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Implemented default cache sync operation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2013 at 12:15:26AM +0200, Maarten ter Huurne wrote:
> This can be used for cache types for which syncing values one by one is
> equally efficient as syncing a range, such as the flat cache.

Applied, thanks.

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrHUtAAoJELSic+t+oim9b18QAI2XQCFTUIcbSPO/syVvRn0o
O5hWrBkjYEF+/3lDAy+duc8ZODWOnIE2YWwNMjTGVLkh1/j9UNBjOs+w65MZkzwT
3J95TEkdCqmypK+eHylVIFmpgD1fkjd8ke35HgAnovMG8icsa+/Ac4sIarMnPEhV
xpsQ/W7qnc7Fsi08nTI34jUuK570wB/1F8Utpx0szOVdpW7N6VBu2ztBecvPGKvg
nvYfJJP0k0BkQoBBcfPi+27rrJ+R4EQY76wYGv9m5Y+YcOCm0/dgr+FR3VX1dPNx
wg+DSAM/EUr3pG9IoURtW1da9jHTwH5qgURD2TbNGeR/P8/NZohU0DuKtQPw2MMs
mQvplS2vKKAJOtCqalmm7DMPM34p0SLvlGcgN1RxbyUs0qoyFexbHNoIA0g6cKzT
K/z2O+oJv+oyiP7KkB3XiwHpRq0NTcR21DRwyyZau9nep2EoDAlEM09ef2h6dhLV
ymBLxtX0Ymygnsrnpu24Y3yNvU9hFM8AUu0I5SPHHzu3YaVWitaQYBbVosEarrdS
/3V4D7wDEydah4tB4oAMeOkOJ6Ynap74ae34TFAYkelH4S7+vjUoWobQCJh0Geuf
hxs31ku3e30jVMPuscS7fDWn4riJBL1wFydsf6c/Yy9UpvHoLWSQSd3YszzUN13M
VrhOODLMm1Sl2fdRd6yn
=S/bb
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
