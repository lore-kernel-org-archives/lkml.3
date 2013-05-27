Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3E0PKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:10:14 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:58822 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3E0PKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:10:12 -0400
Date: Mon, 27 May 2013 17:10:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: mturquette@linaro.org, swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] clk: tegra: Use common of_clk_init function
Message-ID: <20130527151006.GC9460@mithrandir>
References: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <1369640409-1981-1-git-send-email-pgaikwad@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2013 at 01:10:09PM +0530, Prashant Gaikwad wrote:
> Use common of_clk_init() function for clocks initialization.
>=20
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Reviewed-by: Thierry Reding <thierry.reding@gmail.com>

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRo3dOAAoJEN0jrNd/PrOh/kkQAK8cfw1xwygR8sCEn8MvaB0G
3hM6SlNRPfEcWVsQgDdat5PK3sX81xFHLezDaNCVmefOHo6DDaqG7nOCRK5UCcY0
Kf0tl6PPqVHtAskgGdUPuzNCkRFJSqJia5nivI/CofwabQbtgIHIXVi2CY6ihYoO
z1NgsbmH5wLkJygvVKz5v/ybZaVnRWNUILQBNnyXMsMvp0QMfXVQeDP2OovLoucK
WVHZtRdNHgwLghXjJEZW3EgXY0bu9yy38cpiZWtI9wXymk0YB/OrqQNmLKAY1/qn
792yGRlo8pGkhx49dcGJXJN4P0PKZS7u+H57Vr0rWuH41DOh7BaE/kgnY6LVCjow
k5ZYblPg4Z+DBUAmy9zym/EgIwpqb8uPsfMa82csH5AciU/8OuSTFVbuaRMrS75i
fLZIxovHcKdAqvXDeO8FxlWmWo0twnRrPBlk79eIoAkvPNZfS5DV0vIFdQX/N6ze
zPZT3/Z6lYAr64JhVuJkrIq/HZYIlxKaHp9zeMUDAmr8IW+7HB3e7O5kSmj3yHf8
w8QnH+6EAeh6yqKAIr6/ga8OVD3lA8xmzvIiCN2g55CeQbrtHKFiVLulW86M82OW
xXINdcE3UaibCZAeK43GRa9yaIOvO6ctaDUFszEl13BPM61RSEaVFaFC9xtA46Cj
nHbN124qU4Tsu112h4wq
=koMe
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
