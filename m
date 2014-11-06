Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaKFIvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:51:48 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47337 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaKFIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:51:47 -0500
Date: Thu, 6 Nov 2014 09:51:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] drm/panel: s6e8aa0: Update calls to gpiod_get*()
Message-ID: <20141106085143.GB26297@ulmo>
References: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 05:16:57PM +0900, Alexandre Courbot wrote:
> Add the new flags argument to calls of (devm_)gpiod_get*() and
> remove any direction setting code afterwards.
>=20
> Currently both forms (with or without the flags argument)
> are valid thanks to transitional macros in
> <linux/gpio/consumer.h>. These macros will be removed once
> all consumers are updated and the flags argument will become
> compulsary.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-s6e8aa0.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Applied, thanks.

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWzafAAoJEN0jrNd/PrOhwXMP/A9eqzThGTe6yn6wbSuCdR0S
F+abMyTUL1SP6teL6H5c09K1VIzvoO7v72fyt7kIkq60PhUdDnBt1rMNd/i4j8pa
q1am5oXC/jnhbMnDk3lTP/Posl2nCBzI03kd3yL11ZOGESWyXdyP99AUwt/wGRd7
oM4anu780lWkhTmvNfitEtc1VmQZC42MuIRa9kl5svx4xLgnMIWhzhf6KuGluBeH
6jMGbYam+xk3xmXvLwRSB3dVZJu0UIF9w0jO3cAha/7Jc2MZEzVqrA+ERgqDcrJ0
NNiqJzs1kgd8VL0AWN4d6UhXJLUclQOjy8FUPtZHlyHS8AKLRG8RUzitvlMbTB4B
0tqeBZqJpkkrWvFxRpatcdY3lixAUOn3Sw92lChNw0IF4JcfajZC7zZOAMvVBKIw
ZvabWr+uw5wdSMt+zLp1KBZIhbXrR1tUoJK8Yvys5FUJp0z7MIZpLZS2hpHXh9Ry
cvvroXEHYD0W6pO/dM2TCpo658JbiBWU6osOCHwiXBs7xlW+qux/X1qpmYrx4sWE
WR50zlPH3ka3xfNFe5mYn3+xZ6Nn1Agx8T8iuAwWXkflxtTEx5StJZBlZXBFykGI
ckWooMXPZY/XPkuLo3W5et5rY4aDIT7cdT8qPFFErmXBrySPxIn++7K5y4ENkFhl
SPnkUO4qy0a/j8/KyZQs
=8jJy
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
