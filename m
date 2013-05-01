Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119Ab3EAAF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:05:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45858 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945Ab3EAAFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:05:53 -0400
Date: Wed, 1 May 2013 10:05:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Hill" <Steven.Hill@imgtec.com>
Subject: linux-next: the mips tree is completely screwed
Message-Id: <20130501100541.7577b375b041559fbc8de5a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_10_05_41_+1000_2fK_0hM6dzRMCgLL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_10_05_41_+1000_2fK_0hM6dzRMCgLL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

You seem to have mucked up your tree badly overnight:

Fetching it produced this:

remote: Counting objects: 358824, done.
remote: Compressing objects: 100% (81248/81248), done.
remote: Total 350365 (delta 306957), reused 299661 (delta 267902)
Receiving objects: 100% (350365/350365), 131.26 MiB | 700 KiB/s, done.
Resolving deltas: 100% (306957/306957), completed with 5669 local objects.
=46rom git://git.linux-mips.org/pub/scm/ralf/upstream-sfr
 + 6eac6e6...eb35a29 mips-for-linux-next -> mips/mips-for-linux-next  (forc=
ed update)

It seems to have an enormous number of back merges in it (which Linus
will complain about) and old versions of patches that have been merged by
Linus after being rebased.  It looks like you have the complete history
of MIPS development in there :-(

It looks like (maybe) the mti-next branch of
git://git.linux-mips.org/pub/scm/sjhill/linux-sjhill that you merged was
based on the wrong thing.

I can't use that.  I will use the mips tree from yesterday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__1_May_2013_10_05_41_+1000_2fK_0hM6dzRMCgLL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgFxVAAoJEECxmPOUX5FEqrgP/00Tcxg+F3Pvm8ENiEekpsWT
/GCuZlx0RLFFUSBMIfnLTe5qUZjAJBBIu7lcCwtb6h/Y8/4eCGCctcn8jtfOLmcz
KDCnRHqpAzhvNwVUjE5lyjTEggWtSin2gH+Xaxn1q4T1yjM05sEKNSfGwpyMMm/t
zfpdFM72Kmx0eeOzGo5bgu5YgSgCUJX1MtQhnx+iiaDHUVJnWgImwfGVsnI1G2FP
qPFtz3FQiY2NiE/XzdAbCfsaUxB89P+ydqklKDzA3o8Pd4fvE0JwbjXybvUmMLhe
Xs3UqFlES3eKJWfSW3Qn5M7v5r3nnN6t00PoWw55KEHvtOkVkRVOWZkz2+wkBUbD
zyPkTHsVKC6lttXHhA8vUFBLoMrzWCb8wdBQBMYfHERN+a1J9xXrWKnIOGjyz2DE
aB6W+19mLgzOfAWMZ91mLiUJiOYRhLlBMTnh2oBZEpMuSPUFkvHDPr6qus/JeP/u
UWtf48uRsOEJytcCzQBIccEZC4u2Wbo6O8ibhxRFCBQvYwALhNmpDIET0HPYwN1x
j9XEgcpue9WtLvtkngwj+DFLFZMHE7d5i+B5lAV9r8eenMNOZrs1aJ4Z97//xVO2
PSgs0EWidmKrKgVlBHyd014Xrd/cPEBNfksANgykNeE1RSKGcvVjOQzZXjbiL3M1
AAE67XjCsJzKpHTznO5o
=wu0A
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_10_05_41_+1000_2fK_0hM6dzRMCgLL--
