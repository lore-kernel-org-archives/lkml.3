Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbbAIL5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:57:12 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44248 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbAIL5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:57:10 -0500
Date: Fri, 9 Jan 2015 12:57:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <markz@nvidia.com>
Cc: gnurou@gmail.com, hdoyu@nvidia.com, joro@8bytes.org, swarren@wwwdotorg.org,
        olof@lixom.net, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] memory: Add NVIDIA SMMU suspend/resume support
Message-ID: <20150109115706.GH16465@ulmo>
References: <1419383441-18242-1-git-send-email-markz@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FLPM4o+7JoHGki3m"
Content-Disposition: inline
In-Reply-To: <1419383441-18242-1-git-send-email-markz@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FLPM4o+7JoHGki3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2014 at 09:10:41AM +0800, Mark Zhang wrote:
> This patch adds suspend/resume support for NVIDIA SMMU.
>=20
> Signed-off-by: Mark Zhang <markz@nvidia.com>
> ---
> Hi Alex/Olof/Thierry/Hiroshi,
>=20
> This patch is created on top of Thierry Reding's patch set:
> "[PATCH v7 00/12] NVIDIA Tegra memory controller and IOMMU support"
>=20
> Changes since v1:
> - Remove the list which saves "tegra_smmu_swgroup_asid" instances
> - Save all ASID registers when suspend then restore them when resume
>=20
>  drivers/iommu/tegra-smmu.c | 71 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/memory/tegra/mc.c  | 24 ++++++++++++++++
>  drivers/memory/tegra/mc.h  |  8 ++++++
>  3 files changed, 103 insertions(+)

We only need this for LP0, right? As such I'm reluctant to apply this
since we can't test it upstream.

Thierry

--FLPM4o+7JoHGki3m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr8ISAAoJEN0jrNd/PrOhUNkQALuuRoHzgAV8zFYpErc9hbzV
7BmtHAZ3UAlhYJEPL/wp/XgbYiJorGuCJafnX38mepxayiC/U9/tAnAQ4rrVMUWW
1PwSGA4PdO9cyUVQiGPJjxKkB+Fb+K9Da/azlF+jT9e4I9yBrOeNYuhUgHZgGdkJ
2wmhMGm50YsEThqeX1519VCotWGjyw2BTkv3O/TT0Y6hWnGz+Nu/wrbyKvTH3ola
GbrDunOIzlqpszfIas3bHSiuXiYDAJGjAUgFv9uR5ObQc4xJJv32xJ+9+II71pG+
kmxpRmZfAnXfPlPjKMGfHBkhzPR1tjke0kDOz/lwQNtlKFxhUYaBdlBoSyUhIiDD
NSmc76Agg2p4cgED3SWg0yGTUjZsGo/k6tUVyYYQU/wJur4sPr++LK4PKhvzeufC
VSyNHdEPjmtTsLOZNZx59vla52zhmA+dR9IoAmzychdsRB3fknzEB3x9KUdqkDo2
GpafEwtRzvM0eIckzORNqhkWAJENKSk1Ap39bcfhOn1WzvgsVhjpOxRoH2H2MgN7
uiC8w+ziL/lEQeY5wdTsV6KRFX5JsJJMg+avpyWI09XdO17NJs3/iEHd+UV7pdli
jNvmXRL6v+kwI5BHwOulj6qAYiStL0CT2eEPwW2NYBQ3XoZrHFqUrl/7lzNpAEUt
9FBisJfO2PYYPJGXyvLX
=4ze6
-----END PGP SIGNATURE-----

--FLPM4o+7JoHGki3m--
