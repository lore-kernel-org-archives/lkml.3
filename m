Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3GCEGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:06:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44128 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3GCEGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:06:04 -0400
Date: Wed, 3 Jul 2013 14:05:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>, NeilBrown <neilb@suse.de>
Subject: linux-next: manual merge of the device-mapper tree with the md tree
Message-Id: <20130703140552.7e8ecf58b0578bfa15d58935@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_14_05_52_+1000_fDvHTzvplm7F531H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_14_05_52_+1000_fDvHTzvplm7F531H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Today's linux-next merge of the device-mapper tree got a conflict in
drivers/md/dm-raid.c between commit 3f6bbd3ffd7b ("dm-raid: silence
compiler warning on rebuilds_per_group") from the md tree and commit
acc946bad465 ("his patch suppresses this warning:") from the
device-mapper tree.

I fixed it up (I just used the md tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_14_05_52_+1000_fDvHTzvplm7F531H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR06MlAAoJEECxmPOUX5FE87kQAJoz1iHcpt7KF3go87egCCyw
w0B2AAYFzgSOPIqarAxoNfj5229xLneJCetFiIpbV6C1ku//3BYQrDY2JK33ouD1
vA46S5iIrbKzfChcW9zmI1y7i/eYqovrraxtXnK7JLCVvswtgqMiFQi1M0hnIzXJ
/qrex8rK6IfvFY0iIIcVb52Lu+NAtZreD59zynRrn/Icm7cVL0xoUST9zpjyAmZ/
a6h8QYyKvIVwc5k8oDERVKgBoMblle4LXFllifHAUu6FKDzfTlgrvictgTIpTbtE
d4HUzBxG69z62KX2P2x4HNqw78TRw896+/gT4c8xV3x3PNMnIQlOX4Rn4/3048gG
ETl/JznvO2sF7/k57Xjyz7U+WqggW/ceEr3K4WqNjWeRxTkxu13g3mGQZ3ac2fDo
nAY3K6GXdR+mOH4eonQaGkNoaCB/Z61cujHUKT31VYO5meudhdYuWkQSX0kpblBi
zpPt70q75QKsSWnvh7gct+kwlkbyxMFUsIOyfmJxAjmwK8Y9UNAVfAIjsr4muHzC
E2wOE9wlQ7BH0iONbbXotZYXPs0SDuCo9HCV8/QU/rxuIUUdyB71XWjlEoOYpUKn
w01RntmpC8txwcr29Y4G8khbo5Iy5Es5Svyv9Wpk+T0yrwqYQsYQrPtKb/61rxTy
LFhzHAmOPyiqqOj09iZo
=tN0e
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_14_05_52_+1000_fDvHTzvplm7F531H--
