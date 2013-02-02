Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3BBFvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:51:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52359 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3BBFvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:51:43 -0500
Date: Sat, 2 Feb 2013 16:51:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20130202165135.af88ff640ef6a2ee84b02986@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_16_51_35_+1100_lc/J+E+6/7fi.f2F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_16_51_35_+1100_lc/J+E+6/7fi.f2F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/kernel/kvm.c: In function 'kvm_register_steal_time':
arch/x86/kernel/kvm.c:302:3: warning: format '%lx' expects argument of type=
 'long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]

Introduced by commit 5dfd486c4750 ("x86, kvm: Fix kvm's use of __pa() on
percpu areas").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_16_51_35_+1100_lc/J+E+6/7fi.f2F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDKlnAAoJEECxmPOUX5FEBwYP/0GADz8H69iBeWiQ7mfmjMGx
8z6y+L272ueNzIwOMuqA3K1TDEswxeQQCC86pd3LS9AS8jtlsljMTqtC0AN+h95q
akjeER8HPCThaw281uHKe8EVk3PcsfC/uPDNJf58HxhtJ8adw0xYDYTLzjjAihCP
MF8JydJlakU6QZxG6YeA81egilXPJs/Pdcy+jzGrfm+wM9dTVC9YZYqmMsjECWK5
NZWW1UblwKzpDWuX9FTTMMYwsbzhn/d5AikcKvD64Hp7SUOZ7kRaxndyrecBBRUw
WQzAlavV7OlozD0LHGZFyLU3GMlaDfaq8V/DJuzj/eWNZED+NLo/l+1HSf67AkNP
Lq2gjiL8tmr/KPnt0qpx2Qxbv0G4eNd4A/n0+OdOWnFF4C8wXoIcPiFYhMMWqGyX
bblollHLlPq8GcKjp5duYxcTGNwrUFyqiYwL2z/oYS5pWKvPbdERTTxxuC0cL7UA
1H3Bot5Fd0zlaeTwkdkvfm6S1As9Z5VHYIpNOZIG+eBbWV76t4BgJwsj/YSpSm4+
6kpjDKR0QX0I3wrlOf0g6J1+kXFnRCzhLwmMSL2krYwSlflB02gQcxyHmxl/3XlC
kHH3FzOeOa1n/Y+4Lkpee3iwcN7PKMDy0awPs8vm1BoP7XEwFTkbrRo0b1pSv1vo
bLHfqaS4Sbrt6IKTgDE4
=GHwd
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_16_51_35_+1100_lc/J+E+6/7fi.f2F--
