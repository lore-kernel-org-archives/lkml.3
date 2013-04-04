Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263Ab3DDG0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:26:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51560 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763171Ab3DDG0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:26:50 -0400
Date: Thu, 4 Apr 2013 17:26:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Nathan Zimmer <nzimmer@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130404172648.27834d12cbb68338f4b89482@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_17_26_48_+1100_mS6UWCiaj_Bi=Mh2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_17_26_48_+1100_mS6UWCiaj_Bi=Mh2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/generic.c between several commits from the vfs tree and commit
"procfs: improve scaling in proc" from the akpm tree.

I just dropped the akpm tree patch (and the following
"procfs-improve-scaling-in-proc-v5") as the conflicts are a bit complex.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_17_26_48_+1100_mS6UWCiaj_Bi=Mh2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXR0oAAoJEECxmPOUX5FEdg8P/j7TGaT1KEqyZkxb9eOZ6Nbr
PERDLO2tioAtsHjsS/eAyg0EfnyxVruYiCg68RNx0+TcK91pHJderGJ2ZTJNyZI/
CrbGY3WabqSI901omVKrrb3j5Yni9NNL0RpazhAT0/pFC1xioc4W2HwxwkKnSTl6
qtOqWVlIgwX0I/MiVbsc4NTfQIO1sG2rIGess0dA77J+jsKAvrE7O6naprCcGSkq
s+Dnq+jcPPfWu3eS9R8ZAc+Ik4ircMD0pXOPwKcewQKe3tTJWjv1YxMAElbKymx2
CfRyHpiheWNFFqSSz4v0fw9haJFBECLdQ1HBvDtQqI51B6mV0KtEJPujjUtl05j5
dLPqJ4116nctJMM1bHKgH5G4Tjwx4G9PfQdV0tZfp26/wW8AJzbyDwxfqcBoTRsV
A+fwz2rFZah1fcQjPLaxmK01rYlyHQCxz66I6/A94QWSRMYTQODf8ft0SZKnZtKd
oNvtSwn/Zu7UZ5J+mPvshXa+e1gXKfLPkloWWIp347udbObF8BdMws/WnSyFDVHn
MIeYEqCKzf8blHw71RQxDBd8q72jB97cSxEzH+swSpo1wDwvMm6F7bVTflYpPXbK
DNMjY+bBjSENtNuXleoSbPOs1rTLys+n33U6AF17IEK2Av6qM4i5r9Ry7qtDxR3F
viPZSGKKyI8YuZdoEqg+
=qMSw
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_17_26_48_+1100_mS6UWCiaj_Bi=Mh2--
