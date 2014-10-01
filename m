Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaJAUgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:36:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43361 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaJAUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:36:46 -0400
Date: Wed, 1 Oct 2014 16:36:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, axboe@fb.com,
        axboe@kernel.dk
Subject: [GIT PULL] (xen) stable/for-jens-3.18
Message-ID: <20141001203632.GA26119@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jens,

Please pull the following branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-j=
ens-3.18

which is based on your for-3.18/drivers branch (last commit is
e9f05b4 drbd: use RB_DECLARE_CALLBACKS() to define augment callbacks).

This pull has two fixes and one cleanup. Nothing earthshattering.

Please pull!

 drivers/block/xen-blkback/blkback.c |  1 +
 drivers/block/xen-blkback/xenbus.c  |  6 +++---
 drivers/block/xen-blkfront.c        | 12 +++++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

Arianna Avanzini (1):
      xen, blkfront: factor out flush-related checks from do_blkif_request()

Roger Pau Monn=E9 (1):
      xen-blkback: fix leak on grant map error path

Vitaly Kuznetsov (1):
      xen/blkback: unmap all persistent grants when frontend gets disconnec=
ted


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJULGXKAAoJEFjIrFwIi8fJHFoIALS2jcSjdISaOgPuBN13FBuP
lojnMfwLrajPLkHsLCkVP0FP7/9WFQr0tP+v2keQlxAn9mEMkU2MJaF6vDEBWEhA
yAdLkTbnBaa3czQd3fEYT5avRHIHxK4QZLLrcryh+olSzQisNAuv9dBsonyy4I6i
F852mGKMyzose1j6/LbpW72kV5zC8oCYRPjiNXCc/qzi7jWQ67Rl46iHQsXD0SyS
y+TXHABb0z+Gx8eL7Of0ZI3OpufX5YpRDbFf9t6jKiRIKcT8u0U1UpZejuA4cwUV
6afpYl3BKaP/nr2mVdEAHEC6DAj/A4BFWdDkn6jXYJdQA5j9QfEO0TYw231egao=
=INYZ
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
