Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaJ3FTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 01:19:31 -0400
Received: from ozlabs.org ([103.22.144.67]:33278 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaJ3FT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 01:19:29 -0400
Date: Thu, 30 Oct 2014 16:19:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: linux-next: build warning after merge of the akpm-current tree
Message-ID: <20141030161921.0e204257@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5PF5IDHTxHxGAS0buGLKRkW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5PF5IDHTxHxGAS0buGLKRkW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (arm multi_v7_defconf=
ig)
produced this warning:

In file included from include/linux/mm.h:52:0,
                 from mm/gup.c:7:
arch/arm/include/asm/pgtable.h:184:0: warning: "pgd_huge" redefined
 #define pgd_huge(pgd)  (0)
 ^
In file included from mm/gup.c:6:0:
include/linux/hugetlb.h:183:0: note: this is the location of the previous d=
efinition
 #define pgd_huge(x) 0
 ^

Introduced by commit fee025d5dd4e ("mm: update generic gup
implementation to handle hugepage directory").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5PF5IDHTxHxGAS0buGLKRkW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUcpeAAoJEMDTa8Ir7ZwVOLAP/jj/ytM7C1c6dCM1IlBX8b6s
m2BIXDukmvWquMwyB0VQh4Qzs/P8Ys7p5+O8jFpjlEetv0P5CxraRF7rBkzEP3TM
Dg+ua/HwwLqpuS0DkYJEy5BwMhfh8LLixKXHxPK9mygFRB+P40v/cpgnTSbPvgpJ
hKha6gte29F0mO8tAEU0EDULCDxjMAVkMSHMttPQVIBvI1y+IfAX+6iTvU6u7gTT
FT+6E+Jvwi5VdY/afjxa4rLrKxCcqBowI189kq46GOd7yUG1u/lQoUjCibvtOmcT
bgu7zSCe+qaK27NrnUd5rEhMOvXIqcf0LcYZHIAiWMs75Sj8xzvb3BH6nStCkuLr
S6nr5j3wDdAk4YxjsEu1U07z0WUb523aIdkk8jD1yvxfaPT7Iiboxs3YwRV+MJnz
F7grNwGGTDK7+N0q2X4zlHTj5W8MO9UmVeJv6+knHAtyOlUiLpiAYjf6Lv6sHF31
MsF9woDqircxVeBD3Pc+Kfq7hpXanewocUv40qEHC1DaIWBmnfhS8c8Ug7lnlK4v
xllczXhjREoE+xmCzDQwgtprydbY5a7hyV4fD/bqOwzOY+qLaND0HdWPMDxtn2tI
Yn8sBRod27ufxXNZt7od6jfdUlXS5XiaVQsYhJeB7orQw77r/ClTvZPqjJHejtU5
F2Y5XB6USqcRLbmI87b0
=rkff
-----END PGP SIGNATURE-----

--Sig_/5PF5IDHTxHxGAS0buGLKRkW--
