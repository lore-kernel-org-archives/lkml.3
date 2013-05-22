Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3EVEV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:21:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46685 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3EVEV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:21:28 -0400
Date: Wed, 22 May 2013 14:21:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the vhost tree with the rr-fixes tree
Message-Id: <20130522142118.d4d7145822496b54819bb97b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_May_2013_14_21_18_+1000_XiggnM1EzXvNcHoW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_May_2013_14_21_18_+1000_XiggnM1EzXvNcHoW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got conflicts in
include/linux/uio.h and lib/iovec.c between commit d2f83e9078b8 ("Hoist
memcpy_fromiovec/memcpy_toiovec into lib/") from the rr-fixes tree and
commit 48f0d22c9a46 ("Hoist memcpy_fromiovec into lib/") from the vhost
tree.

The latter was an older version of the former, so I just use the former
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_May_2013_14_21_18_+1000_XiggnM1EzXvNcHoW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRnEfCAAoJEECxmPOUX5FEKgAQAJYxfPc+eicwvLlYJgTKepHH
YYNCuAusXqb6d96sbQF4qbqeZnZe8lT1P6v71XHXtUlBujPUdbeZK6Oz91lWw3Ac
HlqMyE7jKhJgk6OkEcxPSEEhB9HiZpspH1KKhID8CkJ+ycTWf2sf8FHUQ4B7+7b3
gpvrRH1ljP4AvuZQdpnND+fOgX2/NqX8rh2Kk5e+6c/Z1iha70avyoEYkBz3ZzCG
SqKHlieE/Qg1kFiAdviJ1bEBRqYqYrkR+2SFNC29tzqEAJKHSpn9CYU8swThVVBo
V6pHccNtMHqa93wcT43PQFH9MKkm6NCK/Yckg6yLU8UOOdCb9eRxjrHeGpAycxrO
nOvIZd6d7IAnDpRNse2d22k2iFzQGZcK3hV+dezM5cJhXK6YHjKpZxrynYC9/Ez7
IiceTXPZka4/tqvfBvRpjt2YY19ZxwpiFcv38NBbYuccmUDJQPEMs2WwnxRGwlqB
P7Qb8pxJ31ssTJHCtInmkh4bd4OO7TtTY/c98iuR2GAOTY7EGTf499fvMWbjw4dk
pJmY7u6/viyXr6BFTQRUNFcEDxax+qRjYOWz6QFvqNmRmFd62lnuY9cjrwRebBzd
KmBxEQOWXHpQx8QbHwsMHeZV1ntNqXNHNQMLNtEiZX2y2X8L6xSdf+xqlSL/tQEf
iJkG0WpmzF2SfoNbpy9r
=8oh6
-----END PGP SIGNATURE-----

--Signature=_Wed__22_May_2013_14_21_18_+1000_XiggnM1EzXvNcHoW--
