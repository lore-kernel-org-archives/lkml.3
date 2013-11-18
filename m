Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3KRPF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:05:56 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50211 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KRPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:05:48 -0500
Date: Mon, 18 Nov 2013 16:05:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashwini Ghuge <aghuge@nvidia.com>
Subject: Re: [PATCH] ARM: tegra: add port FF to GPIO ID's
Message-ID: <20131118150521.GI26046@ulmo.nvidia.com>
References: <1384780241-31639-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JIpyCmsTxyPLrmrM"
Content-Disposition: inline
In-Reply-To: <1384780241-31639-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JIpyCmsTxyPLrmrM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2013 at 06:40:41PM +0530, Laxman Dewangan wrote:
> From: Ashwini Ghuge <aghuge@nvidia.com>
>=20
> NVIDIA Tegra124 supports has the new gpio port as GPIO_FF.
> Add the macro for this port name.
>=20
> Signed-off-by: Ashwini Ghuge <aghuge@nvidia.com>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  include/dt-bindings/gpio/tegra-gpio.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

I've had the same patch in my local tree for a week, but was holding
back on sending it until the merge window closes. Anyway:

	Reviewed-by: Thierry Reding <treding@nvidia.com>

And I suppose I could add:

	Acked-by: Thierry Reding <treding@nvidia.com>

depending on who wants to take this patch. Traditionally I think
Stephen's taken them through the Tegra tree, since these files are
highly Tegra-specific.

Thierry

--JIpyCmsTxyPLrmrM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSiiyxAAoJEN0jrNd/PrOhV70P/1fS47YpErAt6HqmNVCQTZfK
OS1rFOQtSSatgboJC8tuMO7TczZQPBvk0EL6Em1/VWUk3W9Udw8e7V7BhElMueir
Wu5XBm2EKqmRxlJauztXyM7aw6yGC6NxnypbhKwD/96u3jc36M/w+vI1eHoGYFtg
SnmzujCCYnt1wnKpyi0q44svq8Xf9EWRj4y2d1BUf3ZyV8/fAsnjDiEcz4y1IazG
P7RPqhr0rXt3oHQiRMWXgX4cSdmxc4SZJtM/Idp8p6MQByT4gI6SkbYF90Qrnd2N
kIJtl1J8nN45dAR896KD+2TEs54zi9hEFtNyG5oDVmwcXL9iSsGDXx/mXLGGHvwU
veTo2GhBVco7iGhxD3JQEdDgbhixOTgKlSb3W4bRCgwPuq1uvy/0U61pleoHG896
3TgNdTiGHlMici2HHvGSzFEJuaCy08m9lylULhSacWkv8sfbCrwb25AmMazIoJpx
DB3Vj6XgJpEqZMTWvHF0RTB3Y6hloLx04uHxftya90znP06WyteE01yOgreXmm0y
3ssnd/Iu1LHoEYdSiCK+IDTu9RWtoo2u19nlusT3sM7wcc88moTACZSNk6vJtXgO
R/UeoHdyX3KIJOJS/YddtcFYLu0uKGXtEQZ6HtxhtHZrAyQSgixTIMjKLTcncbPI
xIHgpwMx5W4HNvHNnABi
=CzCy
-----END PGP SIGNATURE-----

--JIpyCmsTxyPLrmrM--
