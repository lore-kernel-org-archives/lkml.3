Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaBTLyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:54:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47296 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaBTLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:54:18 -0500
Date: Thu, 20 Feb 2014 20:54:10 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Message-ID: <20140220115410.GI2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-15-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nd2gbL3QXjeJX4Fh"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-15-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 15/23] regulator: tps65090: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nd2gbL3QXjeJX4Fh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:15PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--Nd2gbL3QXjeJX4Fh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBezfAAoJELSic+t+oim9NiwP/iZLoKwk4ydWA3dOoMchrcZg
dCmnn4WAJXrwMaoH2HgQTHvAfkkCrE+s32CEJAGJxMawIVW8yVPQX881MpbP080g
PE6dliJDG+y/MWbbPQ/OAq7BbL5PE769bSqRnIquLjU6ey61VXzYuh1cpHol1hzy
kgrm6SpehEKJj2fELQ4KEBd7Srg/rbaorh63KwedvlCpMRF/2IUI718tQwf2/o1d
4gbrguq7fA3yr5yLbXzQEqYeUN8P3XN6IA6VJfxOQ+rF61QlUuuWvXp2HJ4MflcC
wsLcJX6iu3zYXrf48UHHXx3YsQ2lp4UX8Zk3LCrgccvV/DJvsxX7FiafyREtsydI
Oab0WPmPocmJgY49qa0Uyk1iwsxcoEu6oRrbXd4UYpYvnhCiD2Id2mRSDfRR32Of
itpEzIBRzXgkNQgClfMkZ+mTOr2ZWDrxF22GXUxmV7/j9RQoZliZtegwAuSzUDMB
Y6KfOaNSy8tgmcDHdWgcF5DgDOAZEAp7clnmyZ46M0F37Vqe6MZNp+OGrxxl0nTq
HNQOIX9Jo9SFmGbdHPwxZY1bS8+o3wPb5BOiriDWWeEMdkPVoAuxPwekLkx3zBSM
5tyFYJzqMJIg6T5UoCvMJ5LsIREkL95gfkGiQm9u2M6WFdrgEZH8eVnfy0QEfRft
ryldteRjKDazFonqxd8S
=vvmA
-----END PGP SIGNATURE-----

--Nd2gbL3QXjeJX4Fh--
