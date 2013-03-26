Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab3CZFZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 01:25:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47995 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab3CZFZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 01:25:33 -0400
Date: Tue, 26 Mar 2013 16:25:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20130326162523.e3bffe6a6086c107c950879f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_16_25_23_+1100_bbJffsJtZCOKdmB_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_16_25_23_+1100_bbJffsJtZCOKdmB_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
drivers/md/raid1.c and drivers/md/raid10.c between commit 9e882242c619
("block: Add submit_bio_wait(), remove from md") from the block tree and
commit "block: prep work for batch completion" from the akpm tree.

I fixed it up (by removing the functions from the files as in the block
tree patch) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_16_25_23_+1100_bbJffsJtZCOKdmB_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUTFDAAoJEECxmPOUX5FE51oP/2rU3cZp9dHWQs6lch3gY9aR
VKp2AYLsBKlFZdby24rTqRqhx8jiJc5GOtZ9ha31oSg/C+I7agknlD4PZVjLHCRP
wyLegpFmUBYn5f4fD3prHvUQCIac4N1OIEsPAXiVzvjqp/42WumZwVPLJ1PAhPzJ
6DC3zehizHFoBDMP4B85/EKbWfXKLJzVpxiPWztlRamCt1Gc4hXQuA8y5bng2zei
Ixi9fui8E/b1N4BNEuAJLJuXxICX9UwxCrqu5Cr1eOEU00lEI9oHGUAaxhFH5d0x
D0tA4j0Mq+J6chwOEol6yIranSdYgrCrbL8bV6goJmWiRSV4eE4o9LP4E5CEUfi2
aUL2OU5mzMFZtyV0DLAVlQLZFAEQuASNivVXiXBlwOdCGFb3qdumnpPRuGWFWqex
vKIlbiyqdPYd/r/49pno3iZ6IXPf8kWGK4Wpe+S8BIimZU0tyYuKIVFul85b29T+
I4e4Je/+52ikwgpvtw6Tsyehmb/zRPXf30PvTM8bXC3BG/DaEkKM3XMaJ1L4TzE6
qGdLFg92fN5nKh6XGeZKxcA4C5Qtw0dUYV+FUgIoQG53/tdcXAd8pG9aJvGSuNKy
vDrsWAUqsTCXBvGg8kxSqhPEoA0NOk2RdpUvKktvIyrcNoXTYJHPXv99pZYB3HhK
SxeDRqob7TDqPL/fGT+d
=Uo3E
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_16_25_23_+1100_bbJffsJtZCOKdmB_--
