Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaKXJdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:33:04 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11904 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaKXJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:33:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Nov 2014 01:31:14 -0800
Date: Mon, 24 Nov 2014 10:32:38 +0100
From: Thierry Reding <treding@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Joerg Roedel <joro@8bytes.org>, Stephen Warren <swarren@nvidia.com>,
        "Colin Cross" <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Olav Haugan <ohaugan@codeaurora.org>
Subject: Re: linux-next: manual merge of the iommu tree with the tegra tree
Message-ID: <20141124093237.GC19045@ulmo.nvidia.com>
References: <20141124153310.61fc2202@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20141124153310.61fc2202@canb.auug.org.au>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.69.209]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 03:33:10PM +1100, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>=20
> Hi Joerg,
>=20
> Today's linux-next merge of the iommu tree got a conflict in
> drivers/iommu/tegra-smmu.c between commit a2257374a4bd ("memory: Add
> NVIDIA Tegra memory controller support") from the tegra tree and commit
> 315786ebbf4a ("iommu: Add iommu_map_sg() function") from the iommu tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This conflict is uglier than I had anticipated. Perhaps it would make
sense to pull in a stable IOMMU branch into Tegra so that I can resolve
the conflict on top of that?

Joerg, do you have a stable branch containing the above commits that you
could provide for me to pull into the Tegra tree?

Thierry

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUcvs1AAoJEN0jrNd/PrOhvwwQAJ8mFfBZtDxh55KIfE4c3dwX
SsrsZ69BXDg97Q33bGbxM1ZajdSpjulQvKyC/Cfn7+bVEuhN136YV5w8yUCtW81v
yKfzZVhk0mv6khf6whijTbfyTy5ei1uP8Vhq47tbsviZqvS+eo/k+U6egbS+7PCr
bu1C5KXbdMc0nfw52IIhbz+YOXpFaGYmRNPw47xoFTMCvjQMvulemo2GsWlWzB7i
QRduEgHk/W/peLoPaO+/2KJJc3HF3EE/a+7u7Zg4q2LHV1jKj0Hn9CX1JwxaAF68
vrKxBTHC/SEGVlOuZwbt3loN2Upr4PIp6C8TQ9ERX666MOB4FdCV8ozKUPcE8Rsi
AFT66YA9pP5P0vY6cgC8Pe21QxA/nKipxnPhRruXno+j1SSyFWRW9IJe8Jl5Wxdd
UvcRXaoNaGbTU6DDWZ0FOSlNJlLuEB1wY0zKGQ2RqXk8RKlK3fjeFI5CQLKjTDAI
V9kwo89wH1xcwnyz+V7M0yCrwko3uduZRKpoYHHNuNv56jdOZCYMh49Lx64bKyil
kEMxX1Uz7djTtT7Ft4ImabC+i5Ar27LuEqtdyzQm8nNJgHEfN7f9LYnzbPgQWAY9
seWYE4VSDhxWAeYbJKMIdW6i3eCUuvWj7xg2ugk63PhpPGERri6volX3DB7N2gfV
10qOAo7pPjrXpPIT6qqm
=0g0C
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
