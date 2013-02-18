Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab3BRFwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:52:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3BRFwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:52:35 -0500
Date: Mon, 18 Feb 2013 16:52:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        =?UTF-8?B?IkRhZ2Zpbm4gSWxtYXJpIE1hbm5zw6VrZXIi?= 
	<ilmari@ilmari.org>
Subject: linux-next: manual merge of the akpm tree with the kbuild tree
Message-Id: <20130218165232.92004590a089f22f67127db9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_16_52_32_+1100_d5AnoGEzRiPoDQDD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_16_52_32_+1100_d5AnoGEzRiPoDQDD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/timeconst.pl between commit 70730bca1331 ("kernel: Replace
timeconst.pl with a bc script") from the kbuild tree and commit
"timeconst.pl: remove deprecated defined(@array)" from the akpm tree.

I just dropped the akpm tree patch since the file had been deleted by the
kbuild tree commit.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Feb_2013_16_52_32_+1100_d5AnoGEzRiPoDQDD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIcGgAAoJEECxmPOUX5FEl60P/iCdzTRtXx/UKTZ0XG54iOuF
gm/i5FnrPQLk42gklUYclWPRDUC4aoYmVTOI7faAwNvP7fhKjK89GBhR25hfac0p
w76eEN/KMPHE9+dEnupWS3rmP11cpzCwP3GDJPBgTaRPinrhtkXVYghepQtOiry8
KMv5x8v91v9tAF3LndIWff1Gxd6qngiu71/l6GL8o9EnVpLC9yEApZX73tmDOMV0
+frdGS8SR2S+zEVxZGNgQfP9Kl3S8OzVJaZOO5wVK8PcQUhYIYWLOHEXdxUFyO/Z
4LxbxV4ShBJVVtnP/1wlC8aV5ZZq/YhIRQwBfQq5tn32XAysG8WeWj5/wIAEU0jz
mvNd5n1MjSOep2UbOwIdSShxAFOMKtIdPDrMxAeF5WcTBqP+AzI9d/d1ANe/7+U7
FFy0NAJG0a2NgYw8KmY/WZWw4FEcLVdUfLTyv+TUws+UB9nVjzgNLHb5A5Q4E5XG
v+06GMEg7EMGPr0oaU06NCKx3xPORRSNPMh7+Ej3rzuWoe7pzgIE9EbOcs8yeLQZ
iRiJ2kos3v2aOkKcbiQLHIHYSvHCy5NSzqWmboP+CfwoyH5eem7nnA9j+PBX/7iX
4uOSu9LxBf3XcexBIZ69DKjXi382m8d04RgXVamSnNTydNRb4fQpIRuHTCuvu/yt
CRP8MbVwsM81fkH03yAu
=xTHX
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_16_52_32_+1100_d5AnoGEzRiPoDQDD--
