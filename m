Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3J1KGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:06:43 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:52421 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3J1KGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:06:41 -0400
Date: Mon, 28 Oct 2013 11:06:38 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: tbergstrom@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] gpu: host1x: Add syncpoint base support
Message-ID: <20131028100637.GA12355@ulmo.nvidia.com>
References: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2013 at 03:21:51PM +0300, Arto Merilainen wrote:
> The host1x driver uses currently syncpoints statically from host1x point =
of
> view. If we do a wait inside a job, it always has a constant value to wai=
t.
> host1x supports also doing relative syncpoint waits with respect to syncp=
oint
> bases. This allows doing multiple operations inside a single submit and
> waiting an operation to complete before moving to next one.
>=20
> This set of patches adds support for syncpoint bases to host1x driver and
> enables the support for gr2d client.
>=20
> I have tested the series using the host1x test application (available at =
[0],
> function test_wait_base() in tests/tegra/host1x/tegra_host1x_test.c) on c=
ardhu.
> I would appreciate help in reviewing the series and testing the patches
> on other boards.
>=20
> Changes in v2:
> - Reordered various code blocks to improve code consistency
> - Functions host1x_syncpt_alloc() and host1x_syncpt_request() take now a =
single
> bitfield argument instead of separate boolean arguments
> - Added a separate ioctl call for querying the base associated with some
> syncpoint
>=20
> [0] https://gitorious.org/linux-host1x/libdrm-host1x
>=20
> Arto Merilainen (4):
>   gpu: host1x: Add 'flags' field to syncpt request
>   gpu: host1x: Add syncpoint base support
>   drm/tegra: Deliver syncpoint base to user space
>   drm/tegra: Reserve base for gr2d
>=20
>  drivers/gpu/host1x/dev.h                   |  2 ++
>  drivers/gpu/host1x/drm/drm.c               | 25 +++++++++++++
>  drivers/gpu/host1x/drm/gr2d.c              |  2 +-
>  drivers/gpu/host1x/hw/channel_hw.c         | 19 ++++++++++
>  drivers/gpu/host1x/hw/hw_host1x01_uclass.h |  6 ++++
>  drivers/gpu/host1x/syncpt.c                | 58 ++++++++++++++++++++++++=
+-----
>  drivers/gpu/host1x/syncpt.h                | 10 +++++-
>  include/uapi/drm/tegra_drm.h               | 26 +++++++++-----
>  8 files changed, 128 insertions(+), 20 deletions(-)

I've applied the series, though I had to rework some of it because
host1x and DRM have significantly changed in the meantime.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbjctAAoJEN0jrNd/PrOhSxAQALctpcYYXbn8b1GUiewfxbdq
QeBPxqUxzk0x41oCdRSFtgf7BF+f3R0gX4UG5IjIcy/9QwgoELhIEJn8E9qKEPM/
Td5tJ3TgOREWcgVq07coavsWXYyZAOOg4ZdvR9O2kzzamOhnePCD0RnV2PvqrT0j
js2NiUawx7zdVkJpH46pJmbIWZxVZwddmSSiYJRiEzw9yzhpOvtMPNaFtLHr0Nm9
8sWnbfzwrB+hlZsxTfU9YkdIqXGC7E42zucqqazNz3xA6CLSlff7kir4wI375siP
a2EoUCGDcjhExonrBbiwDs5NVB5twoNnqmq9xoJk8RMJtAj/ZMLP/vGBfzoEl4bG
PeMwgOxLd6T3OGWIaHUdoJyYaCkkSAKavAsqH4WGFj0T4ZIl+ZzaEwYn8i8TbEMR
8V6WVW1VEXTaQVlxOzwPwDqfrYgYjFsFe9RKM+WHYuu5Ca4xgG0jmEWClFGrzTqy
cPJGn5UF7i2HEan/7YxbbVBFC8sCNRyXSE5qEVr4S1yrdeMPYfbGouvpkC3ORpgs
0GEhEhNXVxGybAY9dI58XhbT5Mhr2qj0SEG/gRApBgK5kiMflPsazy3BFKW14Vlm
bsAOip805grW36wpduL7SLaOINzMUV5UXlogZNB5cbZq6FJPIxuHVaA7/QeyzBU6
EnrkxcI6q9J8Oo2Jjrwg
=ny0z
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
