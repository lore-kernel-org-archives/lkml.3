Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaF0OXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:23:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39398 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaF0OXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:23:02 -0400
Date: Wed, 25 Jun 2014 10:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (swiotlb) stable/for-linus-3.16-rc1-tag
Message-ID: <20140625145305.GA4464@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git stable/for-linus-3.16-rc1-tag

which has one bug-fix that had been in tree for quite some time.
We had assumed that the physical address zero was invalid and
would fail it. But that is not true and on some architectures
it is not reserved and valid. This fixes it.

Please pull!


 lib/swiotlb.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

Jan Beulich (1):
      swiotlb: don't assume PA 0 is invalid


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTquJNAAoJEFjIrFwIi8fJKdwIAKFrDUVN3B5Hw4w+KN+ZsYnc
Umv9p5wV8ZJp5IkcgKNBHzKq66PUKLdoPPUidVBBnQuIt2KmgI9XreyQQi+BBNJi
lFwv/173GRjnkXjTtx5oxO04POX2pB59P2JZbUCKR3a76MSqggTpifJm3Eu/QsB2
N8EW3BvonPIvvnEMHx4MIzFM3l5Gft4m4a+C9YiUpIuJiR+Prab3r60hIyRYZg32
Hd1nw3ZXVFPrBr3ju8spNDINnSzTLc/LXlevKRcd2McgZb4qzbmWyBRGzb3+/I5h
BACI9fRI1p1+InTf14BdkyaEhQH24wdwRlbgdTLCEQ0vUhH36HjnRiP0YG3/oD0=
=vcWF
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
