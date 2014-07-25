Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbaGYGYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:24:09 -0400
Received: from ozlabs.org ([103.22.144.67]:51560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaGYGYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:24:08 -0400
Date: Fri, 25 Jul 2014 16:23:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the driver-core tree with the renesas
 tree
Message-ID: <20140725162353.04cacc71@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/s0MJ06qQf95EOYE=V4OjEde"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/s0MJ06qQf95EOYE=V4OjEde
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-shmobile/setup-r7s72100.c between commit 9394af431455
("ARM: shmobile: genmai-reference: Enable MTU2 in device tree") from
the renesas tree and commit d2168146c222 ("platform: Remove most
references to platform_bus device") from the driver-core tree.

I fixed it up (the former removed the code that the latter modified)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Sig_/s0MJ06qQf95EOYE=V4OjEde
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0fgFAAoJEMDTa8Ir7ZwV/EAP/RZrO9txBN+uisZEuQP67SIg
xM9fwWAK7YyETrXvsDxLfaTuEGIiAOKkWhD7Yw604gKtbgIj6CEGUnjRX6X6JG2T
3dGNbHgtwUbbbt+xWsmwposXGxCoaJAMKTZD8unaBfPwpJgQpsNiFz1kIELA3U9K
FJjcBWLPIDxOQRgkgfEAuLoP3dDDj33mRxEbPtwTcFpAmGh+yRSx6VHdTJd9ub9M
fW3WTUUAyRN4tCs6WNutlueOwugAGVeV5zqDxbfBPYY1ctHaTMD2yOTyKMyGrItK
/ZJo549JyZra63c9kg9KkRiwZVKgmM+PaWqVZZwnY5NSAAGQRZ0I0MuHeM5AJ8qi
HDGR2ttFMMUMtUiOXwv+zNFsouyyH+GaRGp0qL2wJYtRtd7JuBcfYmzZxqQ+ayCI
h+JYymKt1FMz5xO3MayhnwcDfIMlGMCepQgGyq2zXgQDj53A0Z+Bww/M0SQCNtr3
RQdRryZ5RtMBoS8c6Swzn5zd0RCMPRuBTivTeDP4vP0i2PYluf/erRtZWiY7L6dV
cebzLzTlqkxFrfeEqmWW8gKIa+Z5cSGyfWfxV5rocstT0FIrnQfG+McEpguYU0IM
ql+YZtcSKkw6K7y40n6WKzJH9byGXuyg7Qoxsj68WUP4XlHRZCZSU6f8c789JGDl
D9SaYu9SdBGZSXB5Uc1C
=LU2m
-----END PGP SIGNATURE-----

--Sig_/s0MJ06qQf95EOYE=V4OjEde--
