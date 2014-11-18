Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaKRIZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:25:21 -0500
Received: from ozlabs.org ([103.22.144.67]:41319 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaKRIZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:25:15 -0500
Date: Tue, 18 Nov 2014 19:25:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Rob Clark <robdclark@gmail.com>
Subject: linux-next: build warning after merge of the arm tree
Message-ID: <20141118192507.39f68bb7@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/z250Xhh0deuc.=t_UBpq/42"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z250Xhh0deuc.=t_UBpq/42
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

After merging the arm tree, today's linux-next build (arm defconfig)
produced this warning:

arch/arm/vfp/vfpmodule.c: In function 'vfp_init':
arch/arm/vfp/vfpmodule.c:725:6: warning: unused variable 'mvfr0' [-Wunused-=
variable]
  u32 mvfr0;
      ^

Introduced by commit 3f4c9f8f0a20 ("ARM: 8197/1: vfp: Fix VFPv3 hwcap
detection on CPUID based cpus").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/z250Xhh0deuc.=t_UBpq/42
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUawJoAAoJEMDTa8Ir7ZwVPBwP/iWkP/dJ/nyl5QDAXP1IsXha
I0WHOHU37sCIOUc9n1p9j3V+OPAc4uZWe5x3Y2N2HzUkjrSlYNFwQut7l5Io+tWW
SW08zNZPX0KKlh4nhvzxKJNDLQF3KQ4+SY6RzNfo7j4HPSo4RNhX6fSDONruOPuU
aNnTAUZmt7Rf+mBmkZZhkDG8MlOL0+Ps+CN9STBwXuP94l2YXpy7sZ59MYMawJLe
NOOOapSffPh5/cpY2xfPqggSF37JPSDiQ0xLl7NzEHzK7B4MzzpWGvRJ7jk65CDs
yztWwHK3tktzpuUjAISO5qjx+XtvFYuKGaLWJOScvQVoTxo2mLIpYuXnh5kFtuEH
jYiTro/aYMx0bwVYYM6MpROMXwPqKqw203A7uwsWtdrehuiVuDxvol9sGtzlMAIq
A/TVzMKWuGLQW3E6SN6nMkJD+O16eQ5+Or15Js9oaWcufdov7HnaBDooTjKimIDd
xtTk3NfASQWW+z9rYDlhTB26CPJbVm4Fy6F16DObohWX4lf4INnm4DJNLFeYdS0N
2pDLAQwGY3WasZHaOoAghKHjj/fEC/GnCf5YIzsBC/SXZglJawlZlMNx2inV0Jfj
qW6TV8kSblz0R2UiXoh5NwdIkqw3ct0bizoanJsZYODXqEksw0c4CqK9PFYiXOPj
fFAB8M8qPBjJl1too4ci
=ydeL
-----END PGP SIGNATURE-----

--Sig_/z250Xhh0deuc.=t_UBpq/42--
