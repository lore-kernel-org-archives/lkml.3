Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3EJDTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 23:19:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41460 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3EJDTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 23:19:30 -0400
Date: Fri, 10 May 2013 13:19:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build warning after merge of the origintree
Message-Id: <20130510131926.bbbee7dec35f696c407ac63e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_May_2013_13_19_26_+1000_=wR3auU5n/lvVftI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_May_2013_13_19_26_+1000_=wR3auU5n/lvVftI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/md/bcache/super.c:656:2: warning: initialization from incompatible =
pointer type [enabled by default]
drivers/md/bcache/super.c:656:2: warning: (near initialization for 'bcache_=
ops.release') [enabled by default]

Introduced by commit cafe56359144 ("bcache: A block layer cache")
interacting with commit db2a144bedd5 ("block_device_operations->release()
should return void").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__10_May_2013_13_19_26_+1000_=wR3auU5n/lvVftI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRjGc+AAoJEECxmPOUX5FE5GgQAIh/+NNI0KL3IlPhKLm8RBs1
UkfCbNboDj7AhvQDTSGGvrF8WfO3XqxJUxoNGoMQgPVoIGfdFlk3MOJ/askg9pwV
m6frTM4Pgs2+okmpL5HeX5/crPkRrTqZNcrtBc81YvRhruURnT5umsMZ4TQQ5zxA
oAPPZG7GvJDgF2Yhhh34zqb1V8CPc3kjnX23RCk9OzGhpAk8XmKtzB9wIse/Asyo
SVzhvgiEPqnYOcu+B2tCH7kC4APAVGJbeS9b9Zu8sU2nVbRmolbxni1ty4+jLhq3
8yKID0jbfx5jtJr07tuwGD8WdiaAC9TG2VF9Eerb2djJp7CL6Y3IAV7Zr/leHLsg
VEzIExSVUVG2R38M6u/rkGddJ5+UDuKz+9AJvOY6fRDSOlwUM9yHT0LSHR6Xg2Id
2xa6P8HAeUYwpSXrSJHVYUSP6k0mED/XAmMZL4nlenwkwPIZMommhKEy02KXPxPQ
Wy+3aaLR9apZgHaoEl8VfuJL3BM65iOgfqyiD0F0ScUHRQP+Evo3rQ5h6CGr7ru0
s747ar9QByUG0oLRFgXn3YgaeCoa64uGOYSh++bAUkJ1aw86r5VVvUfnJ/fwLhcq
kcs6mhXWSwcazD5H/jgecJf319rj+BSqIVDcNIX8ubI9Z6/07KIJgDqhxF04U0si
iuaxplDkyhfI31YBz5Sy
=r1kO
-----END PGP SIGNATURE-----

--Signature=_Fri__10_May_2013_13_19_26_+1000_=wR3auU5n/lvVftI--
