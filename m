Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaA3D1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 22:27:17 -0500
Received: from ozlabs.org ([203.10.76.45]:45304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaA3D1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 22:27:16 -0500
Date: Thu, 30 Jan 2014 14:27:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Subject: linux-next: manual merge of the init tree with the kvm/kvm-ppc
 trees
Message-Id: <20140130142708.6d47d4d63683e32b7ae16c80@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_Jan_2014_14_27_08_+1100_X6hgh+8i1AKT8JM/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jan_2014_14_27_08_+1100_X6hgh+8i1AKT8JM/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the init tree got conflicts in
arch/powerpc/kvm/44x.c, arch/powerpc/kvm/e500.c,
arch/powerpc/kvm/e500mc.c between commit 398a76c677a2 ("KVM: PPC: Add
devname:kvm aliases for modules") from the kvm/kvm-ppc trees and commit
"powerpc: kvm e500/44x is not modular, so don't use module_init" from the
init tree.

It sounds like there may be some intent to allow these to be built as
modules in the future, so for now I have just reverted the init tree
patch to these files and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__30_Jan_2014_14_27_08_+1100_X6hgh+8i1AKT8JM/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6caQAAoJEMDTa8Ir7ZwVWA0P/jttaIn8UyNc7U8b3ePRTjGC
PXxZR6PaWCmeMzRnnjSUCdY7DGSWCs6/MJJGjrfXHSRaGbLMwt4H2pcL73W2hOko
z4668XyIhKtvHn42gxrNS3YGWE14oRsvKYckhCG03ZiBvHuNPWhdpW/e54jRukMU
xOlqyLWJcKNlO+ABYEMP+OWmFeXJUjAx6iUkRV2XFlDl0iAN/QK/GbaFYlDD7Nfq
17F9x9NnaGlz4HPAi48oBiQpgK3D/fQvgySUpYEqJwuibP2+Jt+VIEumiZgbD0CY
fIyzUwY1pHdk2LfJhw+pMg8Cd9c+kHPTX4U7AV/oTWyURT+Qx6dPjzThURvIDuUn
lLbAFECNvIIohXkPCGeY5/bao/8WbDNiw+Wm9cGDsjV2ZOWbJlEWWlBz99Brtagn
wt9T8EyioujmXSVH45eYzoVPNXlAOxggXSBND2DuogjOOXRdaAPpTl9QRH3HFpXT
2GdOxdlDYOM1s5U4O9R94NVbkBER53NWEx3wuZGNsn5+C8j8AXB21zQRmtbGWMlu
vQNAA3ksgJmbu4+zP8e+sfLNGPwwKk7dOsJbKDRQ8A0hQwEKm4pxrHRLSZ4YK6Ps
RvS2Cd3bMbdMqlRXaSPIKO0k9jrWBIx/lMV3mZ4+z7qFb1lK+2RiJRrg7/9Ig/x/
u5CST0um8hhdn7WXruH3
=0dpb
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jan_2014_14_27_08_+1100_X6hgh+8i1AKT8JM/--
