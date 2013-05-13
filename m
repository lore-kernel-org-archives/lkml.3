Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3EMBSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 21:18:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40375 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3EMBSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 21:18:16 -0400
Date: Mon, 13 May 2013 11:18:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next stats (Was: Linux 3-10-rc1)
Message-Id: <20130513111805.391a4d4c605d5cbfc3e8ff4d@canb.auug.org.au>
In-Reply-To: <CA+55aFwfK661zATyUpjkXJo1av51nmMweYdPJE7Le7S2KS3xwg@mail.gmail.com>
References: <CA+55aFwfK661zATyUpjkXJo1av51nmMweYdPJE7Le7S2KS3xwg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_11_18_05_+1000_2VXNvjecas_Syoqq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_11_18_05_+1000_2VXNvjecas_Syoqq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 11 May 2013 18:00:09 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> So this is the biggest -rc1 in the last several years (perhaps ever)

ever (see http://neuling.org/linux-next-size.html after today's
linux-next release).

> Which was unexpected, because while linux-next was fairly big, it
> wasn't exceptionally so. I'm sure Stephen Rothwell will talk about the
> statistics of commits that weren't in -next, we'll see if that was the
> reason..

Since you asked ... :-)

This was the second biggest linux-next ever (in terms of commits) the one
before v3.8 was somewhat larger).

(No merge commits counted, next-20130429 was the last linux-next before v3.=
9)

Commits in v3.10-rc1 (relative to v3.9): 11963
Commits in next-20130429:		 11300
Commits with the same SHA1:		  9708
Commits with the same patch_id:		   885	(1)
Commits with the same subject line:	    91	(1)

(1) not counting those in the lines above.

So commits in -rc1 that were "in" next-20130429:	10684	89.3%
						(down from 90.6% last time)
Commits in -rc1 that were not in next-20120722:		 1279	10.7%

Pretty good, but it would be still nice to figure out where the last lot
came from.  I have the "git log --oneline --no-walk" list if someone wants =
them.

Some breakdown of that list:

Top ten first word of commit summary:

     27 NVMe
     29 xfs
     41 drm
     47 powerpc
     59 rbd
     64 arm
     78 media
     84 mips
     92 SCSI
    101 btrfs

Top ten authors:

     19 Wang Shilong <wangsl-fnst@cn.fujitsu.com>
     19 Wei Yongjun <yongjun_wei@trendmicro.com.cn>
     21 Dave Chinner <dchinner@redhat.com>
     22 James Smart <james.smart@emulex.com>
     25 John Crispin <blogic@openwrt.org>
     26 Steven J. Hill <Steven.Hill@imgtec.com>
     28 Josef Bacik <jbacik@fusionio.com>
     31 Hans Verkuil <hans.verkuil@cisco.com>
     35 Al Viro <viro@zeniv.linux.org.uk>
     64 Alex Elder <elder@inktank.com>

Top ten commiters:

     29 Ben Myers <bpm@sgi.com>
     43 Al Viro <viro@zeniv.linux.org.uk>
     44 Benjamin Herrenschmidt <benh@kernel.crashing.org>
     54 Sage Weil <sage@inktank.com>
     59 Linus Torvalds <torvalds@linux-foundation.org>
     80 Mauro Carvalho Chehab <mchehab@redhat.com>
     87 Ralf Baechle <ralf@linux-mips.org>
     92 James Bottomley <JBottomley@Parallels.com>
     99 Josef Bacik <jbacik@fusionio.com>
    111 David S. Miller <davem@davemloft.net>

Quite a few of these could be bug fixes (especially DaveM's).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_May_2013_11_18_05_+1000_2VXNvjecas_Syoqq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkD9NAAoJEECxmPOUX5FETQ0P/AmtSnMcBAhagB+vwfe/oAi8
RPB5nrDH2eabolNn4byVPoTshevkzSNzLAsaXf21R0pZ+aZwTaocdo8jDnjehqEj
7TkD0NMUX1NadcM/BWBuAYUHpVfXM4qIzDvyb80GUGRYZS3f/gvrY/StTI0vpFlQ
YAWwt3k5L/efiy5IS+JChiBlZSuV5cGqZt/RhQgaGQXh7P21JVX+MnEsweTr4b9X
L7U+NjLoVlVuGljSEf0/z6LD17fgLpmksH8DJHG/Q0GruA7iQGyMGPBGCQyz3Qop
M/N5gflRM3XGT4wtlROJ7UZLXNvaLB9U2FkomcBU2wLTWajGaSnbLeHcQY3/zdr+
55YgAQRbFNDutqqbhXhyzewHx5FNYr5oc3qBwSV6HfFSbm4tfjOGX9+XMDeOCbxh
0jgvnd9gzjA1gaB2Wo+v6Ykcx+AD0s4h4T8IPsl0l8yDUyKsKEsll4XzoK1bH8ZP
SjUuQZNfNHMz4gwCkF3Lj6V0ISxTTlDA8nCfttJOfAmDxRfgcfE0i+Ey59JFUAbL
Ab2IGCgSre0XKDuzKQIM+obRKznI0rpUlLdv2tEzExW57BFQJXFpSuZs0fe+jqCg
ARMfDrXFuXyW5R8zQ6Wqzvn9Di3Dssu07A3EOEIUFh9ahB4qyvaipXcT0VM7aDd/
vtt+HaqtrhhH/b6DV9On
=lnpq
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_11_18_05_+1000_2VXNvjecas_Syoqq--
