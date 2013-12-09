Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab3LIDrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:47:22 -0500
Received: from ozlabs.org ([203.10.76.45]:51353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760309Ab3LIDrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:47:20 -0500
Date: Mon, 9 Dec 2013 14:47:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-Id: <20131209144712.57a50d7ed468ae8a4d57a0bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Dec_2013_14_47_12_+1100_gdVLJ2t9D2/w3+i8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Dec_2013_14_47_12_+1100_gdVLJ2t9D2/w3+i8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
fs/sysfs/file.c between commit a8b14744429f ("sysfs: give different
locking key to regular and bin files") from the driver-core.current tree
and commit 414985ae23c0 ("sysfs, kernfs: move file core code to
fs/kernfs/file.c") (among others) from the driver-core tree.

I just dropped the driver-core.current tree commit as I don't see what
needs to be done after the other changes in the driver-core tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Dec_2013_14_47_12_+1100_gdVLJ2t9D2/w3+i8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpT1FAAoJEMDTa8Ir7ZwVIKMP/0yn8G6bLuoK2hMToELkg+zO
MJw6N+UO83H1uzCY7PMlPUA0JAERDVgK8HhaYYsFNITc0H+kQfvVPxqbf90NBuoO
/z09kU8oqOE80q5n/dFHZtYKMf3G7aojw9bH8ePUM6yIaREoRCW7BfQIz7dhvAt9
+fKvu+Lh0k8iItN3VDedjSfhuUB4zxQJeXSCI/MJq2bnqI5zIRJMsWxRsI+bigX0
M1Z4JJ3RwO/Jn/GBth3h690Y4PWRUGAJ/hJSqMKEgeYiG8zaZQU+582wS9CdTD4+
7cUGCJpg0KrLgHAdEbctbnDU+4+O9aIge0PMIMu28ymvYx7PpRZQbklOp+sIxkqB
c0N7m0UT6v5McTgUXwZ1UyxqBqLFPCVj7aKtjO4Xtw3+bKbG4oRK1spFir1s3z+n
ZCNuVWW1jatatHEx3ZqtVR2ZQTn1kUnAczkJauVK2BXDwRoeJ1bjAQZnebnU7dNz
D/CmEQbaZnkbtHyL4GfX9+cTpDhf6LLFMWYNRArQ657SBfNbkiVe2sKOBVgU3661
cOi+HiLi9H/Lju3ZIMJzkblwPLpXxvG3R63KgzZOXioabySI1smS6IdKGZiB8phf
7bgaVCzfkFqdHBML1FNLdkvQUc7cAvFpdfx9xSp8TpWvp4wLYTuRmGkT5n+3fgJt
BLkdh5J3aPhhsLt33Cf/
=nfFn
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Dec_2013_14_47_12_+1100_gdVLJ2t9D2/w3+i8--
