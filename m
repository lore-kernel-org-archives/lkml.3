Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3KZQcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:32:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20634 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab3KZQcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:32:09 -0500
Date: Tue, 26 Nov 2013 11:31:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.13-take-two (bug-fixes to
 xen-blkfront)
Message-ID: <20131126163157.GB2959@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.13-take-two

which has bug-fixes. It is based on todays on your 'for-3.13/drivers'
(f7cb20f03dc6dff1b19942cf3dda6d154c86f29b "floppy: Correct documentation of driver
options when used as a module.").

Fixes are to fix a compiler warning and a issue discovered by Coverity.
Please pull!

Thank you!

Felipe Pena (1):
      block: xen-blkfront: Fix possible NULL ptr dereference

Tim Gardner (1):
      xen-blkfront: Silence pfn maybe-uninitialized warning

 drivers/block/xen-blkfront.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSlMzyAAoJEFjIrFwIi8fJpygH/RtDAnILkvhIrn/s9puVJFe/
f5KNW2lRy/kmdw1PeoUwgmWMPDcr0AZyKk5stlzxPtgWZqYrMxT7+jK5Lq1hPtFl
hGvjwHehs1xZ1SAnhMEOmBRCgP/HLaHJrIjWoN1Gxf8A1rJxGfL/snC9oi5M/lPh
YfKv3btEjWk2kFyQc9P1PXm6k1BGIThmpCBYV93ybtmic33Gg9jLWI0hs6Beh3Xj
DcU2h8VfmEYtRa3/shLDHCuR2LjwIF1lfdZCU7RFYxHVyx8aYRRuQoKZbdXue7JX
UfMDDsg+WSz9rPqkj9D+1AXe3hal1QkZtD5GvcWig21mlmWMDnoFA0dLdRnbHKk=
=zUrD
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
