Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3DSIHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:07:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59929 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3DSIHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:07:33 -0400
Date: Fri, 19 Apr 2013 18:07:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20130419180724.a0fecca0869e712e48e430f2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Apr_2013_18_07_24_+1000_zZqVvd96fuyGe31B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Apr_2013_18_07_24_+1000_zZqVvd96fuyGe31B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
produced this warning:

In file included from arch/x86/kernel/early-quirks.c:21:0:
arch/x86/include/asm/irq_remapping.h:87:58: warning: 'struct irq_chip' decl=
ared inside parameter list [enabled by default]
arch/x86/include/asm/irq_remapping.h:87:58: warning: its scope is only this=
 definition or declaration, which is probably not what you want [enabled by=
 default]
arch/x86/include/asm/irq_remapping.h:93:18: warning: 'struct irq_chip' decl=
ared inside parameter list [enabled by default]

Probably caused by commit 03bbcb2e7e29 ("iommu/vt-d: add quirk for broken
interrupt remapping on 55XX chipsets") from the iommu tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Apr_2013_18_07_24_+1000_zZqVvd96fuyGe31B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRcPs8AAoJEECxmPOUX5FEQ30P/RfVgrLIxVrvQQwYJV9z0NlN
l6VWtquUuH/vGD+MlCij9yQLPM+DxcOeMzxspR0ZVtGzPsTs7Jn+k8kB2uCzg820
9MpUcAt0d6fyNCD2Tc1YSJ3NmSPQ//rqEJQJuD2Hu1s099Ma+FL7SJ5wal0xlU5J
kU96N9kPLkpcpZQpK6IcCHA2obNtNJraPeieEr4qAGt6Tzi5nfDJWNgvvdIoyRXl
7rnycMbxChJkCQ6tlYJb8OSAWLESQAQs84ejsl9vIEW3p2R2ur3ke9sdoBSJrdne
k0wIHHGlNcin/P1qLh12aNHBb6zMF5gC5cOMfyYiaoV5jUaMMq46PlSvTl1ZHQ27
GmDaoRmrWrWmopg3sLrJEfQvS9AkPNKXG6qv1x/5VKbUH0GDFpSOfI6hJ1gRIthr
4gatBag4G5UWPQkRgwJV2deUmamqz+LkmjV2tQ3VzsrJQJjw14I3C+Sfpzv3FRT8
qmpoMaL8Fk+x1fo5FrRCFPgyq+YQITrf3R+SStYLM5SaWGr/PuyZk9T6I/eJAUZA
cWceysfW/lyG7WQa2pLbE8AUh2m1rBtcyNfH+9qP57Pl3RMArlm6iz/nbdf3Eu+n
eGoW+NrKmJMSz7tgTPFo+VbuBi8v96Fnhwp7ZpmhstIGjnksSDzPmWrPFdGSFIOT
CrkSpzrg6+MisBmYGLgy
=+/QD
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Apr_2013_18_07_24_+1000_zZqVvd96fuyGe31B--
