Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3BBF65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:58:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54507 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3BBF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:58:55 -0500
Date: Sat, 2 Feb 2013 16:58:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20130202165853.399001fb288754a9af6ffa13@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_16_58_53_+1100_CZ2z_0VokBn6/hsU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_16_58_53_+1100_CZ2z_0VokBn6/hsU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/mm/numa.c: In function 'setup_node_data':
arch/x86/mm/numa.c:222:3: warning: passing argument 1 of '__phys_addr_nodeb=
ug' makes integer from pointer without a cast [enabled by default]
arch/x86/include/asm/page_64.h:12:29: note: expected 'long unsigned int' bu=
t argument is of type 'void *'

Introduced by commit a25b9316841c ("x86, mm: Make DEBUG_VIRTUAL work
earlier in boot").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_16_58_53_+1100_CZ2z_0VokBn6/hsU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDKsdAAoJEECxmPOUX5FEjT0P/3qDkEYGJaKutX4a20BIyDsB
AfPnK76MiIIvneDb+wGCAAnNJ6DRBio1u89udMMwP6kVaV+N2Vw0mzhQJBZIyfKr
rTwRg2LLlX+R98Ln/noEIbbM5qW9NEHcXLp+i/Gf7B/ZaqF86WCi96HFAXpuJlTj
3EOixZ8i97kgjVit0Sx8kapfYYJ2SAWU8VW3Wywh2gKkRBGqfBJDXMqwYJ4tAmVY
AvoeqE2frThroOeUAEdG9YWSq/ymZ3AmWjgNn7DzlsBG7bpa/k56n5PtLII5xGK6
iKwwY+pPuF38Ppd9wRuS6UxH4l8laTaZQNbBol/5HhtqeQ95PdWNgDmRPSDCMv+C
3AN+5S5OAjkfwwLQcuek2jEuxfCxIt7aGqDcKlyiq3lFUFe2eI9QZKuDFCsbbU8m
1xbxGa/u1ozZgX9tFOeIIIOzlYCe9KKgP4vbfMneh3gP2IduDKani0rZuXokMfG9
/XjP18hQlRc/VbLFQDhLHZxLZmqbaaGo0txV8h0N/eMc5/eW3UiQw8xEW4aZTedY
c32LLN/E1h5n321Ooo+TaA0HL9qUMAIkvMgkZglMiLCu8QVoCdFJpNxcXZvml7g0
bNlgnrG1O93WtS5gAXr0OrVxA47hQYpNIqyU5NFspW0jUsZHIxAVv9d//J21/GGe
WWqoSHezBRaam4SIM45s
=MS5c
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_16_58_53_+1100_CZ2z_0VokBn6/hsU--
