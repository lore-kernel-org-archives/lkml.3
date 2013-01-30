Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3A3Lln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:41:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52292 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3A3Llk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:41:40 -0500
Date: Wed, 30 Jan 2013 22:41:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20130130224124.7b1d992c648c86c4af61d58d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Jan_2013_22_41_24_+1100_pdJj90kj0VXQo.8m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Jan_2013_22_41_24_+1100_pdJj90kj0VXQo.8m
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

--Signature=_Wed__30_Jan_2013_22_41_24_+1100_pdJj90kj0VXQo.8m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCQbkAAoJEECxmPOUX5FEOEEP/08A6lu60ELPYooHGCNq9txG
tU5/zpc93rxdMWsJd3arathOjG0MyXEO93aF5FF+8FiU07VC2MEkqNFVqHVCQIcI
QEtyzZ20ZY4We1FhDh5ieb0444IZccotbX6VeTBxLW4kqjxwHpLhdKsJaGi20mOt
N9ZBlEFL5TBSgDlxRXLeV77EI9OJ9Ajb9lkAYIvzY4DpdPlHNwcX9KiM+t8y8W1W
XUvnIKW4Rs+i3qtgzQ6Sh46KNV/E1nVVZnLePjn1Qo4QuN8agIqpq1poRdjwAg8O
QfWVClsnjCSRei9z1fscCBkvkCrnzbJ3WTmrac87Zw0myfPbMhoiLD5Dc7X2D90E
gN/VCmB6kbPNyTTpVZJjN6HZ/DLGEVKXpSGR3TG6cpD7F/yKSobW5cuc2yRKoIZw
ocXBpQg18Y+B5p/TrfIXTOz257gwyKhWF5NMX7qj9wwftrq1oqSoVNhc6BDUFujZ
XJ/VRsloUeaCiRDlRI/8vf/PbVSjjn5A2TXlI6eA7ROoVrgmMVE7vn+Y7Cz6k/PU
UOzCKv435jKRojoxuQhPSgWEOK7F1i5aR1BujqnxTU1Nsso8ygtWGQQquA03sRgv
kGcA+MiZ2u0lHHGx7nIVqIFLhr31cr0Kuv5UhYif+lLNqkHtday3hyRkopbsje6r
+u/t8zWXx6wqO43OJbMI
=SUl1
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Jan_2013_22_41_24_+1100_pdJj90kj0VXQo.8m--
