Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaEUROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:14:30 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43228 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaEURO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:14:29 -0400
Date: Wed, 21 May 2014 19:12:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v3 04/16] drm: sti: add I2C client driver for HDMI
Message-ID: <20140521171209.GR2014@ulmo>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
 <1400594186-8956-5-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5xr6Gr0irOxp3+3c"
Content-Disposition: inline
In-Reply-To: <1400594186-8956-5-git-send-email-benjamin.gaignard@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5xr6Gr0irOxp3+3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 03:56:14PM +0200, Benjamin Gaignard wrote:
> Add I2C client driver to retrieve EDID.
>=20
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/gpu/drm/sti/Makefile  |  3 ++-
>  drivers/gpu/drm/sti/sti_ddc.c | 56 +++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 58 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/sti/sti_ddc.c

With my comments about DDC in the previous patch addressed this can be
completely dropped.

Thierry

--5xr6Gr0irOxp3+3c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfN5pAAoJEN0jrNd/PrOhyUkQAIEfBdd2oHqTS1Tnhtx3baaQ
k30nPrf7zrkOyTfa0K4EGvocd5PjRNoxhDosJiF1QO5uSF8IZLiVfqGU6Ua8GFam
iWuAxvqCRzYE2tSUMF/v1Vm4J5U3BlfzNM7r69AqPLcKDxpKS029lYCG0+NvovZ/
A2X8/R8AoS6C7A2cG4N5TOKEo7HX09COvD2sH12s+lS8LOu5mfCBMa2EfRH6jzkh
VO7BVB9CefLM18Ka94ZnZnJZZf+LciCBVzHJgFdm7yzw94k+qqQdZu2ZpFiYDP4S
rY4VifP3lpXawFN5TEyXNB8vYAxZMTYIS6qlZ3mHIxCfZiHOzIQL9ECu+HP1LbZK
8XNa69uW6BJ4cjLdXa02DUoD8QGOWzcvfTdRHa7BOySFN6a+gobgQjPn5VbWY93g
L5dT5ayOi15cqgVAlvfQZBLUS30jTiVe83ac+7gnYixYcsAh/AzQGHfJZ8J63HUi
pdWpHNXaP428oCuKIoHja2fwEhEogXMCsT5Oe/UcYNFXH1xNKHcOC0H4Mc2v0IWF
P1aRXvx4VHPylWpantlwLRw/StNR+J3LGCRUlu+OSeDd3mJACsjMoIxMi+ReZ3O6
GNIFonUXUYKPTlXm/j0kd/zQFN/g1T8a/7Z18YAE2IqqoIQ7RsOrRX8yCGBGxZoP
mg3krCpn7SkFVyD1DPYN
=xxVT
-----END PGP SIGNATURE-----

--5xr6Gr0irOxp3+3c--
