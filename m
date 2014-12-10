Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbaLJU5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:57:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25135 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053AbaLJU5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:57:35 -0500
Date: Wed, 10 Dec 2014 15:57:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@fb.com, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) for-jens-3.19 for v3.19 Xen blkfront driver updates.
Message-ID: <20141210205726.GA13822@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Jens,

These are two fixes for Xen blkfront. They harden how it deals with
broken backends.

Please git pull the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-jens-3.19

in your for-3.19-drivers branch. This branch is based on:
9af8785 NVMe: Fix command setup on IO retry

Thanks!

The changelog:

drivers/block/xen-blkfront.c | 65 ++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

Vitaly Kuznetsov (2):
      xen/blkfront: improve protection against issuing unsupported REQ_FUA
      xen/blkfront: remove redundant flush_op


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUiLOyAAoJEFjIrFwIi8fJmT8IAIKqaJmH8LJVwddN7wz1LtNS
75WqyXuTsx8yFptqpRlbF80W6oRmDJZ7UWiNhKC8var8/uv6jVY11HdcmU2TZJQh
W+Tl63GYDkgqP42+ahD6CGFD1beB+fVUSVDVf+D4qe9pF+0nBHum9L4F5NMoqE+s
sOhTIhmHaLQ7jYdjPKjW0sigNP3T0pRSCY5dQfboBxFnUgnOkmxPB4SFwB3LFcjj
TNVjCZIc8sjYaOjEY39W+gKyGiukKAUkwGgmy8Klgh+Sp5SbGEH3ErtmHmuYFh/X
CbupR/Mj5xMUSs6QH4jkch/NxUUsqGZrA2goDL23HD0ustqzF5sXEowbui9lNZ0=
=BJFW
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
