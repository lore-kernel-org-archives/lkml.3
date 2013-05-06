Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3EFDvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:51:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40631 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3EFDvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:51:19 -0400
Date: Mon, 6 May 2013 13:51:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: linux-next: manual merge of the akpm tree with the  tree
Message-Id: <20130506135109.9c0b24ea1e22784fb28ae6b9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_May_2013_13_51_09_+1000_xua6eR5cnSxyYVw4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_May_2013_13_51_09_+1000_xua6eR5cnSxyYVw4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in ipc/sem.c
between commit 321310ced2d6 ("ipc: move sem_obtain_lock() rcu locking
into the only caller") from Linus' tree and commit "ipc/sem.c:
alternatives to preempt_disable()" from the akpm tree.

I just dropped the akpm tree commit for now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_May_2013_13_51_09_+1000_xua6eR5cnSxyYVw4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRhyitAAoJEECxmPOUX5FE940QAKSRRBUYd34QqGl1iiKVWcTs
tmBP/LC6uOmZrQwnw4Ru24gGw8vJrJtf+HExCOeC6TPcjshZSWt/1V7t2LbQ5Yd4
PGpgPveyMQBhLx1gder4e0Qcaq6XfdM0FOPtD3LhULx27DlPCramUSZN8bs0bQ0D
C6NIecGS4xSfvUBzWAznnpV911VDgtNL3JlvXZx9aj/Nj7uYTq0ibsxchkrXjGCz
AHSomzuxdGIidXQZWTJj3ahDfW9IRuqkRT8hfbmxGjgUjV4mjaCGoFU/Zb7Q8Gcv
bJ1aUaIYlilvZ3VtU0MPgztgFhP8iZDhq11mq9iWi6nzN/58NbXecOgEo4EJ+Gvi
zNB2Nyj/ZYJb9aUCX3spNqvqwe5/D5S3CHH5OcEu7orYwJGprMH/KFJPNECBsdvT
MBUv+gK5CqdWSezoLaSYdRoDYobgdiYhQxGKN3XoEf5tjL1rCBQ6hZNoFmhIu5yJ
dXkM2SmeqmOyNkTpO7TPR8bHw8Aut4IKG86pDOiTsxX4X/gb6yuryDICRVxeuxj6
hxP+aATzChwZvcedf2Gxz2EvxNPTjaVGnDFezpIgWi/VFzj0y631zr0g5Lw2QMVa
6secpgWiuPqawWNXEUzhWejyNNi4SaoWGG1PkPhUQEU1NDGKHUyydjAQ+Udm0keq
qNsVNUKX0++Hpt3Xe9y3
=JNmf
-----END PGP SIGNATURE-----

--Signature=_Mon__6_May_2013_13_51_09_+1000_xua6eR5cnSxyYVw4--
