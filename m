Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3J1MCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:02:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60931 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3J1MCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:02:07 -0400
Date: Mon, 28 Oct 2013 23:01:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: linux-next: manual merge of the usb tree with the  tree
Message-Id: <20131028230152.46d44ec81ac368fa00191225@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_23_01_52_+1100_8wwTyVDxS_udWB/X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_23_01_52_+1100_8wwTyVDxS_udWB/X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/Kconfig between commit 12cc4b3827f8 ("PowerCap: Add to drivers
Kconfig and Makefile") from the pm tree and commit ff764963479a
("drivers: phy: add generic PHY framework") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Kconfig
index 969e9871785c,8f451449abd3..000000000000
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@@ -166,6 -166,6 +166,8 @@@ source "drivers/reset/Kconfig
 =20
  source "drivers/fmc/Kconfig"
 =20
 +source "drivers/powercap/Kconfig"
 +
+ source "drivers/phy/Kconfig"
+=20
  endmenu

--Signature=_Mon__28_Oct_2013_23_01_52_+1100_8wwTyVDxS_udWB/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSblI2AAoJEMDTa8Ir7ZwVTMoP/R4sVs6rKvdw+ZXyYvWlKpDM
z6DoaDu5dJp2dUA3u14qOgEbh88SIyVtbuKJ8u1JCcd5Gll9gjQCf5pWIOMOkmOu
NajvTnEQYysuhHVjTCO5Y7Y2n+/5IU098/DdCS1HWz0Qgsg/llmwcJxMvDQpBUo5
syDDLVS0qslROey7pD9ZROT5P/CfHyl6AC3O2u+hC3HMvfIrCIoQXv0YnyAFGQ8F
4NbNL860w2wUIemKd8R8a2TYZXlD5NKtpGIhI+XodZ3pKu4FhmnPfPlnYG9IV//W
6qZrl0lzEeYpQvoOrSnlRo/f8cr2B5KBovoqPTLkfwTcnWPbHUGp2+nG9TmMmgza
ro5H9NzCWAJBKjfqL42NCF8EMgK7ru0kxAE2hajYehwXQlOewfqSO7awyyj2O5zs
/C6hSGy22TxDw5ZY386TqpslDuqCpBr6+i8UiOYugFoHh4D1IH7rNDhf9L1j3uAJ
UACGA5FX+B5KWjFyQ7Bvu3w23E/Ej/t3rckwRYFIo1l86+6G2VUFq/wE/2eORyCG
691aHRvzIS0Vys7DAbCabsXkQ+ntn2JYGc7Ir1jmFb1Bt/0ksVy8NMIPkApuX3Yc
uqmoVGew+ENAiKiqwumlm7E/2eGaC2/g9duMTOZyMVRQXZxsTx575G8A6CiJAsMJ
dkuqRETk0Z88gN1TkBGp
=hs2O
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_23_01_52_+1100_8wwTyVDxS_udWB/X--
