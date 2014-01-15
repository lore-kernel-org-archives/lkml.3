Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaAODxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:53:09 -0500
Received: from ozlabs.org ([203.10.76.45]:38188 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAODxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:53:07 -0500
Date: Wed, 15 Jan 2014 14:52:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: linux-next: build failure after merge of the device-mapper tree
Message-Id: <20140115145259.2961c5623f17b20afd5f04c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Jan_2014_14_52_59_+1100_Fus456Tttw_.52p5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jan_2014_14_52_59_+1100_Fus456Tttw_.52p5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the device-mapper tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".dm_bufio_get_device_size" [drivers/md/dm-snapshot.ko] undefined!
ERROR: ".dm_bufio_release" [drivers/md/dm-snapshot.ko] undefined!
ERROR: ".dm_bufio_client_destroy" [drivers/md/dm-snapshot.ko] undefined!
ERROR: ".dm_bufio_prefetch" [drivers/md/dm-snapshot.ko] undefined!
ERROR: ".dm_bufio_set_minimum_buffers" [drivers/md/dm-snapshot.ko] undefine=
d!
ERROR: ".dm_bufio_forget" [drivers/md/dm-snapshot.ko] undefined!
ERROR: ".dm_bufio_client_create" [drivers/md/dm-snapshot.ko] undefined!
ERROR: ".dm_bufio_read" [drivers/md/dm-snapshot.ko] undefined!

Presumably caused by commit b41bf7440bcf ("dm snapshot: use dm-bufio").

I have used the device-mapper tree from next-20140114 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_Jan_2014_14_52_59_+1100_Fus456Tttw_.52p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1gYgAAoJEMDTa8Ir7ZwVRxIQAIYvIPZ1y9TgHZ6Uc1B3cwOm
N9/EW7unywA66I6oPCEU9aQetsvw77DCTt5A1HaX0Ae9jJjOYe/YMzUAnXMkwNyu
j+vUjQXnB/vYS+F4H42d450RzKQqN/pu+pF388zBCxRPrZaH2rff3skFCLk3999n
p0l24/lX6TAhKVCJkolQVymQj1Obxel07RMcPuq0VxbQm4OBT03cEvWVm0EVHHfD
3pcOWvLBfCsziu8ipvfpjWHhHJ2nCw+c/Bqfld26wq+fS6d/SKVgGmAEwxaub6o/
OXoMazgyiXqjdhGnDC/0LPZu9sjYQm7PjSlpeWu9QrTTZ6ieHL7U0Cy8o14IGyhh
wLEa9An8IwdBh0vzLtX7PDwIXoTFiNjt4vpL7MBZ2YFL6Br+7Yprw0uk8CRa0cUY
beoe/FeP6gMM24OIa1gy5osvQH79ShXTA2YS3PyeT5rkWrmNGmJ3W6V3vcagPr7t
d9XAX1+ToaoL4QQvFA7HX8nIJ210sMbfmc01nXpxoZZhrFWMLYiPhSgp/5cfm11P
jvuU5ai6/Ulae16Ld/4OEnTX9e6I/qYIDcd4c6AF5dt+zZRh/N9QwLe6/Qf3l7Mp
qxT6Uqkzf0u9sJDtBeIT14MZ3LcUePL1vGDwd7FKouziINfoAkyTUXDojYbKJzcm
IcMEduVXN+Y27JfeWmwX
=IApA
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jan_2014_14_52_59_+1100_Fus456Tttw_.52p5--
