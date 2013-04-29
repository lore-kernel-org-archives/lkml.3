Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3D2B3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:29:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56504 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3D2B3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:29:49 -0400
Date: Mon, 29 Apr 2013 11:29:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the xfs tree
Message-Id: <20130429112943.afdd088c7bb8d80046bdfd2f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: "xfs_dquot_buf_ops" [fs/xfs/xfs.ko] undefined!

Probably caused by commit 3fe58f30b4fc ("xfs: add CRC checks for quota
blocks").

I have used the xfs tree from next-20130426 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfc0HAAoJEECxmPOUX5FEHjgP/0TBlVxlC2wyZ+Blha5ODu/C
vUJumRVXIl75EOJ2EsEXs9XwiP1/Tkv7LSKanWveahtwQx16LVGbuSbK8zQTxrGT
ZYTN8MCML8nD7P659EDa/KOyo0dOx7kiqPX0MV0XIjsdTqnggOqIbeqjZemjmLlX
/dZhwCbeIj8sFGj5jW14itstm0DpzpgLnilESZe1EZEKGuZVyj7TteI5qjxUH4wo
4qtOWN4KEDStc9Ye9SEl+p2N/S3duSs42+IA4G3XEeib+PSOamgKGZXCqhmZ5Kq4
L6HmcuYsYHUNpbQ5SqGtEN8KWSC4ri89AhbXWr+qnwVqYIsOOjtJAnhHMXgtbXkN
tIg67qWdtYPuyp69I29gZE3scKtkUUfub8aOMmNPZaTSang6I9hwtKeMf53fsPKk
mLX9fCv1wYYX9ygeUnQxUWJu3a6nuP9pl2m3XB3Xc2uu8C/20zvH/PC5g9csBnwM
4xPjwedqm9ThKHXrfuNDHf9FdJngc+LD2b+POOb8L3WAT5nSjXG6GM5BbplGDjh5
BTM5rwYptwGb1SzUYEC31xRJPN6erzaH67uWSlA3tG9035WlxQhC/CAq9ukDSFmi
c0cZf9+dfuCIo6sUaW7LeeHv3FOwB36gowykobvos415jVhTgeLSor07V2vPgHGB
Tm4sADvntX2DxQX1YvO0
=shlP
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_11_29_43_+1000_9uakL3EUbfUXjLcr--
