Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3BVCgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:36:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57172 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab3BVCgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:36:46 -0500
Date: Fri, 22 Feb 2013 13:36:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: linux-next: manual merge of the writeback tree with the btrfs tree
Message-Id: <20130222133631.1441b0e703faeb40e29eb6c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Feb_2013_13_36_31_+1100_.ueqiJcrkOI1Trc9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2013_13_36_31_+1100_.ueqiJcrkOI1Trc9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wu,

Today's linux-next merge of the writeback tree got a conflict in
fs/btrfs/extent-tree.c between commit da633a421701 ("Btrfs: flush all
dirty inodes if writeback can not start") from the btrfs tree and commit
10ee27a06cc8 ("vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and
rename them") from the writeback tree.

I fixed it up (I assumed that the former supercedes the latter and used
that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Feb_2013_13_36_31_+1100_.ueqiJcrkOI1Trc9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJtmvAAoJEECxmPOUX5FEowQP/iFUnrDOnqfSUH+TGQzuRqS4
4zsGb6HifQL9oP1av9/8gI1O6SxYYlMT6wrsxBlR5Dk9hIL/aiiX8/+DXpWHR+St
HdJhJYOJ6Y1+PIMSt7mXNWm/nwjZLDw4wely5MYNVdCZeHV879EM5PvsZFWZZgi3
MKOfqFzyElvD2qU77fpekwG1YLLb+St8EFlPE+8ZR9WPPfGAZaR0+d31TQ08SwML
OJHstu0m1t8vhGmmrJreRCj1xJ7/ZF+BIpT9m2R0Wn4/RaoDBQMSPn+Pd27/UiHR
P3/H+0Keo8G7XweotPUgCAPyGWPtihpdKvM/2W0ow7vBmr2lCXyEYWDhqDl1N5vl
o+Sc4pah8bGi0/nt5fnFEauj04uA+EeidU+LscjYkfOF/+lsU7volPaIzfIoteZY
SfISJ1deR6vRTPmOnwl7TXtmfWneaeirm0/PDDqFFwGzZRBZ2tJhTapoZ7R5CF3i
IC8RWCMF2YHd5YyQ6pfUqAavPJG0UNSsEzKrYLZGhaZWYsNDqJibf1QVgOJs+4u5
2PSVCsJsDlfxpYt2SHVWUwrbQ2w6rhMcx7vdwyjBNvNjvrevbuQfBZ/Cn0B7D+uG
FjMyi4XyJN1mfKh+XcufZNYmKEO2Y+EUUeIDT2lVjd+/1cFZ6yLCCXrU2uZNdcZK
PPMH9hlqmMZvlrF+aTiz
=dcir
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2013_13_36_31_+1100_.ueqiJcrkOI1Trc9--
