Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3HSByN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:54:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59939 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3HSByL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:54:11 -0400
Date: Mon, 19 Aug 2013 11:54:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Terry Suereth <terry.suereth@gmail.com>, stable@vger.kernel.org
Subject: linux-next: build failure after merge of the libata tree
Message-Id: <20130819115401.1f3ce4c2479645d72fb5cb00@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_11_54_01_+1000_KorYN.xCxdaoY1YO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_11_54_01_+1000_KorYN.xCxdaoY1YO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the libata tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/ata/libata-pmp.c: In function 'sata_pmp_quirks':
drivers/ata/libata-pmp.c:386:36: error: invalid suffix "x26" on integer con=
stant
  if (vendor =3D=3D 0x1095 && (devid =3D=3D 0x3x26 || devid =3D=3D 0x3826))=
 {
                                    ^

Caused by commit f1a313ad86b9 ("libata: apply behavioral quirks to sil3826 =
PMP").

I have used the libata tree from next-20130816 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Aug_2013_11_54_01_+1000_KorYN.xCxdaoY1YO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEXq+AAoJEECxmPOUX5FETUwP/RvmnLVh+vaQ9l8rnjjLGQAE
41lffm96WyLfyk3uFlmXS4eWka2lP0+FocJZp2edjh3sKUNgoVI/u8tegyWTht3D
V0q3aCz+MHJzLrQJ2EgKcPzRMhtal+RlZnorVOGRL7eJlpJ5l+g77NTvUEt/1TB5
1xwZuVSOiwmvyNKV+3Tethp4nhPAG6I9Zn75TIUTaPqGDoEiD9SNYLQYp0Sjol3q
+918Sw1O+za77run4BfY8BoLrn1KmLtLT2KNeHgesODGokiI9g0NB/dbiPaPOlh8
eTKM2YrBVobdN3egzqz5mc40n8DIflHdf0pTkcyd3S4uTt95hmarHCLY3xnpRnsJ
dnssHO4LAtGw4WSaWkZzcsblheXGPnVawZ6aJE3jMkK9GrsP91mw4q1mqHPHIpCL
Fh4Syr3afqcsNnIj/2dsjMSpZ8xxCY36orqG6+0797iaxsSp6/2GTSwtFxoL7/Kk
R1SP0Rbx0V6fMOS+OnCZ7AZWeNEYskxgaeVwVxA4siDsYlhogAiP/fu/K6lHRz3U
NqTnf3Am1/cLEmwlvhDl8p0PTJ/6s10KfyLDBczldiSkF1snNmFGHmrEDlzGUmyJ
r/rBbg69pikdyY2SAK8othVGtFfO7kiVyLjTVtE0wEa1EldB35H6Om+DdTvUKIWW
bBNBHBklny121vcDs9gl
=CoHh
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_11_54_01_+1000_KorYN.xCxdaoY1YO--
