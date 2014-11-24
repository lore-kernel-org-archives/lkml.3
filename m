Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaKXHZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:25:54 -0500
Received: from ozlabs.org ([103.22.144.67]:33299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaKXHZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:25:52 -0500
Date: Mon, 24 Nov 2014 18:25:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Stephen Warren <swarren@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Thierry Reding <treding@nvidia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the driver-core tree with the tegra
 tree
Message-ID: <20141124182538.5d3f7f29@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/PEi4Z3qj0rRLUbcaFtqE4dR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PEi4Z3qj0rRLUbcaFtqE4dR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/iommu/tegra-smmu.c between commit a2257374a4bd ("memory: Add
NVIDIA Tegra memory controller support") from the tegra tree and commit
98b773cf7b6b ("iommu: drop owner assignment from platform_drivers")
from the driver-core tree.

I fixed it up (the former removed the code modified by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/PEi4Z3qj0rRLUbcaFtqE4dR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUct18AAoJEMDTa8Ir7ZwVNPwP+gOgEjgsZURI/9tzcLGo6xj/
0bA0rNDeo+6op4Lw20LkKHvqtr8/Dykrp+7LHvRz+AA/Qy6qlfZ+reYthLmMXykj
79FfJoiOo3czpJQfuDmRQnN2v9Z9ltZnSLItFg9Nz3c41axbXb40aZPgr7Yg6wqd
nLIWLF05O/s0dhD4Pb8pNXn1cjgGnP9ZUfovtmQS7vP+qOCmjf86THEQw5sgZapA
HS8aBJ8f/kqPnNN10RVJvZIPGDH5+FLpw50yMJ3f/6D1ZngA75IwRqNce5/pdrhB
mByyNYdbzgU2G9xewXyKoWol9/AWODJgN7kaLqnapwoSM+PVS4Ja0XxvI2+HZZHR
4eZNFj46AGggUT0ER8XVOE7tJO5OFAA/GVzlD+fQL+xR8AstXwgJJNA5WJOWgN+x
cnDbMx827WX3fNLkSGzhbN0beo195c+cuZjK1cjpgwHfrZmgmsdarIonlSYUOQRL
XlGxlzMdOF5sJVvC44Tpk5VNMIadFvouKfW96xWq7g8itVPi9OMKm/SOMTjk6lYv
C/pg8xyTInzWuSq/9tqAEUZGmfhjXDoPy4abHpDzz85+CgPmcxYeHgwJTIekFfsN
uJgJD+ZXNPjK3yTRgm40Gr3lCHikmQ+3/Ddi1zJzlwVMy493sePrNrAmrX56tFyx
EKQN23eH4wNCqJjSblAL
=K4aY
-----END PGP SIGNATURE-----

--Sig_/PEi4Z3qj0rRLUbcaFtqE4dR--
