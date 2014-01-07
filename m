Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaAGDqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:46:50 -0500
Received: from ozlabs.org ([203.10.76.45]:40990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbaAGDqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:46:49 -0500
Date: Tue, 7 Jan 2014 14:46:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <PeterHuewe@gmx.de>, Jiang Liu <jiang.liu@linux.intel.com>
Subject: linux-next: manual merge of the security tree with the pm tree
Message-Id: <20140107144638.5227139098f6cf772a162f35@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Jan_2014_14_46_38_+1100_enE+GiCy8REbaUd="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jan_2014_14_46_38_+1100_enE+GiCy8REbaUd=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
drivers/char/tpm/tpm_ppi.c between commits df45c712d1f4 ("ACPI / TPM: fix
memory leak when walking ACPI namespace"), 84b1667dea23 ("ACPI / TPM:
replace open-coded _DSM code with helper functions") and 1569a4c4ceba
("ACPI / TPM: detect PPI features by checking availability of _DSM
functions") from the pm tree and commits 747d35bd9bb4 ("tpm/tpm_ppi: Do
not compare strcmp(a,b) =3D=3D -1") and 238b1eaa59e6 ("tpm/tpm_ppi: Check
return value of acpi_get_name") from the security tree.

I fixed it up (all of the latter patches have been subsumed by changes in
the former ones) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__7_Jan_2014_14_46_38_+1100_enE+GiCy8REbaUd=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSy3imAAoJEMDTa8Ir7ZwVtgIP/0TypRLLc40j5D+JGSrUM0xX
vK7K+PbZj26KbqnyvmC+FPdyVONIsZ2Z3Pbzmr2rSpfuoPuQr/cBVLLwpScocRrj
8PvOA7iZk9WKClDdBOtb/vK4nipkPjo/7O3XVyRok2Hevp97Qtxuu4AXg1g3vFdT
lnn4a1IlTE+vr0cYKJp94njTyJcXVC+RO1N4c+rQKxbdaOGQQ+qeEXOOv8GPeRUK
HksquqgVbK3dpBT9G81mhRkK2xqiTyciuCKfc0nK04F+y5OfWiNosNH7vrv8e7F/
NyObfVNSm4rJuqWU/9hDx45dH0smix7QWxBWtc+0vya5LLYyLhGtbAkATII2yhOq
LrjmeijDq3fI6azATBgDKOFs4MRA2nhMM42Ej/+kfRfIcgojAAebHmNbe9/peJys
TPEH9mfiNkeARt8UsFHRc/kCRWBDLUydYOsuAxj7ORC1wB0TYFX2Z0fvJtfl6uLE
0X09JKhXeT0pOZJ7Q3Lj+0oxK4swllZVT65YcxISIvBZ/bRm9BOvfuHJI4n/fqqX
2HjDhOR08Kb5PQBGe4dEVWe4VCcy9Aa/6FDjvC3dGvnXoz3qN+/UnsXcUDV32T3+
aWJLdOIq3isZ7290adS6yFxcgVc1imX7lct/SsBdx5KFNxzOSnO60Am4EL8lAaYG
gjmhmyNeFliyWVIL3/HF
=wt6w
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jan_2014_14_46_38_+1100_enE+GiCy8REbaUd=--
