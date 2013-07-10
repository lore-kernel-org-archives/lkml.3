Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3GJBYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 21:24:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43386 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3GJBYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 21:24:21 -0400
Date: Wed, 10 Jul 2013 11:24:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20130710112410.f786035ff9202e773aa052c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Jul_2013_11_24_10_+1000_tPnNSp4hLpCG_7Dw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jul_2013_11_24_10_+1000_tPnNSp4hLpCG_7Dw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got conflicts in
drivers/block/rbd.c and net/ceph/osd_client.c because the ceph tree was
rebased before being sent to Linus and it looks like one patch
was dropped and several more added.

I just used the upstream version of the cpeh tree for today - please
clean up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Jul_2013_11_24_10_+1000_tPnNSp4hLpCG_7Dw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3Le+AAoJEECxmPOUX5FEMnAP/RWupw9nqMIwZYq8ERQkGNwu
O2F8fnHTJLQGbI1LF7wW7FdFOMuWauAvoJfouJ5M3hGybc9MjueLVcSDjvh0/9a/
HIpKS3vJ22S2+O7EmjNlctehm3s5KEgS3pEunzyJ+lkr50BqE6v5+fyN+r4ZaaHZ
msI/vhu2/3A85u1YYgdLiZy/4D7oILgLNtNE7nWncpbPRbWUxF/wbsXDQ2tT9eMN
wdButTA8Dp7Veg+Px4BscT5SsiE221wRTqHS2uPQ0KYMeWNj6o53VgL5vbmZ3YiX
J4YAsl28hTJxVQYmIGf6PWG6imlKwm5n19+lLj+XFyagYJPv3nW13TvoqTJyy4uz
USPRO5cd3rqTdRjoKKZcJgBX5IjcMDG9bw8fLCUCC+IjR8qM/LciNT+eDTx3qW20
cx3O5PMziTCT5Kxo/aMh+5DYiceoXXb/qeNpL+5xcxGoo/g/FgGWLdo5pkY783G2
QAjSr7PWfhCcDmc1lckcgiFOvm0SIMsDGyvuJyft/9CQhY0oxl5ppfPXuIS9pJpO
mZoXJ/e+hRzYf5C31wqCvzQXn1P6JjJNZvRmSsSj00fcY0YYTL/R3xkqjohUNtEr
PggT7mgvoSO2aqm5EB6oQfFVIVcaFkadzVh+bzVr2kUnz5Pal9Vk3aLXbJcgQl9A
ZW0Q+J2iln0GV32EgNd/
=rvz4
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jul_2013_11_24_10_+1000_tPnNSp4hLpCG_7Dw--
