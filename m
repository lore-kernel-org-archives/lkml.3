Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab3CHH3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:29:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3CHH3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:29:43 -0500
Date: Fri, 8 Mar 2013 08:29:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Chew <achew@nvidia.com>
Cc: acourbot@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v5] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130308072934.GC5772@avionic-0098.mockup.avionic-design.de>
References: <1362690968-24854-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1362690968-24854-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:H3Nkj/v4l1HLLFyLm3r9n2vyC1g2JSAsgl40yGpFVbW
 0OtErsx1ouFYfBbyDRcCG9ORBtRH+oF9gfBEqlpwU9hWgbIl4H
 /B2911EbYMJyAFMlHV8Kf/yuV7uSfi1edJfngfJm/7ozqO1O1J
 ODp6oZGPg4h+1XnXDzXAOfZLCU9ySQhGgU3+GKQ3wYI0f656tD
 BMGJvGDqoawuDUIQdRVfRfg/eRBuBl8aeXWYmaVawayiSqljak
 wcez090FM1SH1FEJzDPmfbdHkMi6t/jCFrTxTkL/BKvqqeUe+Y
 rE1yy4w4UK+WnOywpcYhdLk9Hie+0dCJlF2JYGfeANuoUArFKn
 IL0CEK9tWgSaRnDRzjOrCpKdLBn527foCWa/hi6dBGbHtEayLQ
 5zEUjKGxLYV9gy7etqDpg1+qDHF3gRtxeY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2013 at 01:16:08PM -0800, Andrew Chew wrote:
> The backlight enable regulator is specified in the device tree node for
> backlight.
>=20
> Signed-off-by: Andrew Chew <achew@nvidia.com>

This looks good in general. I'd like to see Alex' comment addressed and
perhaps the commit message shouldn't be device tree specific, since the
same can be done with legacy board setup code. It would be nice if it'd
mention something about why the regulator is added.

Thierry

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJROZNeAAoJEN0jrNd/PrOhxOwP/3AQL/s5gB1Ea/EapbAr5nnI
uX9v+uzbyFjRp5OTVwwum1XNBh3LHfRg2A/r2PUudzO6sTqVfww3gbayf8kujYLX
plnEPrwdIKDruu4v0Y29y+FIz8R5EoyZwMMGb/ZKjlwMJPmdgU54yyzGdrGKcasf
ZmOA4YLXQzXCt62dupDr3sphIeNS2N215rGGwSEPR0tbOAabHsi1p3Du7jz/Dr9L
pVrRcy5IwoiOHF3N9csYtOToCsy8E5p1uplfFdRCtRMtRMmvNo9kon46nvz3WJaR
qRZfG+5qTA8pPDgKtBpjHZCIjDbqGc0h3VAgtxvvkYn07AGdGVQq4wJ/mQk3xAAU
gbExlJyRwgEQflMhYYDKSQO4996Hb7i+X/cKiFEInqaEcfGSZ1fDWvt4SaJ9Bz5N
L6FT9FpU6Ac5elGGtkdic7pKISUy7rX2MdPvBVQRYN9ZuLWhMS2iqyM2IOC4T/ek
BBumKkJ5e/GP4Uwxepa8VO0rmD9eJYqc20MFLRxaDtXUZvbsXkiMf9o0/63ggbfn
QKpFNjY0N1vzsyArhiFKNNprpdy01X3JYa4uL4I0ppo5EMHbp3l94TEQbILz0RHU
PjjliGjJRbG1sziP7Mf3+8LKOMW96rhjG3pnqwxdtbAlYis+J1XkUei/2nYD2DGh
zfwKyI4XG+BEFfe1IYu9
=J1w3
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
