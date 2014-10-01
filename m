Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaJACNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:13:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:60834 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaJACNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:13:11 -0400
Date: Wed, 1 Oct 2014 04:13:04 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] bq27x00_battery: Fix flag reading for bq27742
Message-ID: <20141001021303.GB29082@earth.universe>
References: <1412101136-26037-1-git-send-email-puthik@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline
In-Reply-To: <1412101136-26037-1-git-send-email-puthik@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 30, 2014 at 11:18:56AM -0700, Puthikorn Voravootivat wrote:
> This patch fix the following issues.
> - Flag for bq27742 is 2 bytes contracy to 1 byte for older hardware
> - Don't read FLAG_CI as bq27742 does not have it
> - Use Battery full capacity register as last measure discharge
>=20
> Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
> Reviewed-by: Benson Leung <bleung@chromium.org>

http://git.infradead.org/battery-2.6.git/commit/a3c0c3e79066c78b890c078998c=
8c6bd577f1d21

-- Sebastian

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUK2MvAAoJENju1/PIO/qaSlYP+wchEhc+6swMvKhFo/fAQoSe
rDQVaHnh1hq99+WcZ1RTzBExus9VgAvNx4FEVUvK54tAvn11hIMYjreQK0a4x9/a
1FWTkGHDmuwV7xnBcBUhv7hxO7+pjYJHdIrrVxZLVyyXmZmAafE86N+7/gGaLl99
YNKQtVjKEXemvD8FPuOHHVqd7eCl5nzSYVqXvBsFCeDfQN2K2L8erdfZr3+fgIes
fukfAJq+dV8MPLnqEXNGJUetTPl1ybf9vJZ6o35zv5SdVIVoJ6MNDj1AQJgGQbP3
gK2J8btpRwj9YeuRIs3mpR7gTgEowCZrEZ6MoL6vxmmaa30vQ1BC3Jy0qtlQtvek
hCvBr8PSz+PmbfaL3Zf1fPtMr3PavVIZT+UCUy5c8JMg8At4upBj0pUKNdwKUv+Y
ewKILVSHCeIBr8RkhAhtocJaG+1VYptDGLD+9gSt168o5hwb6g2X2jv3y7OXcwa3
ZhDx+yVRgybfDEVrXpK+VjVZquNM2PVviozx7ETZx50zxbrnCG6q2ZiqctgaRiPA
lOwzxK8cck6+KhNgIgLZ8fHHHrchogOvvnEJqaEqJWdycy8PcX/hJ01NtpZrLgq6
4v5BMVyVjxXDLT7huLaKkYLwM3GEDiFtQNVaqxyuO5A6wMNqNeXtLEhbfT+ophKT
y8Q3Z9GXpJI/UuDaX8tO
=47o8
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
