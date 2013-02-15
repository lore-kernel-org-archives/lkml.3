Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358Ab3BOF3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:29:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34311 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3BOF3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:29:46 -0500
Date: Fri, 15 Feb 2013 16:29:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the idle tree
Message-Id: <20130215162944.97d852fe2437f2985661982a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_16_29_44_+1100_pkkPn1xzLprN4fu_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_16_29_44_+1100_pkkPn1xzLprN4fu_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the idle tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

arch/x86/kernel/smpboot.c: In function 'mwait_play_dead':
arch/x86/kernel/smpboot.c:1370:22: warning: unused variable 'c' [-Wunused-v=
ariable]

Introduced by commit 69fb3676df33 ("x86 idle: remove mwait_idle() and
"idle=3Dmwait" cmdline param").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_16_29_44_+1100_pkkPn1xzLprN4fu_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHcfIAAoJEECxmPOUX5FExH0QAI9qhpab8cnOuRWbo/ulgeA5
jS70zPg4XDhegPObEMEY1W63gbx03OXzL/tAuSQrmEWGIMbJ+GN3eoPixIXfK3KV
QoXz4Tg8CnetvcSHjQS3Is5ID6UH1jMQU1Oz49eAD8EQ2GP7fRaj+TtKwCvjhhQS
QCgRk56wGadiAKcxBv355KBVXAlgvBDo+ZfwFEgWV0HrOu1iNtKOhFrCN7XUjUC8
pPlHlAUvB9GCWMUI+LI00voue3ZiKFbzuA1c58Dw/vaDqV3qZrmTu1CNDsnuuDUJ
RELcZd+ckL3RZ8i//lK5hTEdNlT36qJB/YbCHLpvzH4WqWPiZDBqJb/wTHIVCiHU
BakLrKauF4kKlvP5Tx6TZUL4LPzVOiN59EaE+VkKs/rpImSnkgSrlWUMQz2FB6tZ
74CGoZYiGNoLxWTzhMrIu6t0gEH2I6pGJFzeKq3grANx2Pcwki5nUn4BEYRMznmT
Rtt3yvPwyDTLWBhV4hFnTiRqp8PHljXAEp39baYHqOUjtm3NvPo1kLSZnn/sEp2S
dKkULCy+nFVkYPY7go8EOgWYE2KoD3HzPhKx/m2M7Q+DWnR/YYftI7XUuJGlMieq
f3pD7lGqBDXybFfIpLyThCYeZsf/vL9GnIFCSyElJ6jwecIGKEGBWyMn3CSCttZb
m5TL9I41TUkOaEsHzav1
=jJc1
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_16_29_44_+1100_pkkPn1xzLprN4fu_--
