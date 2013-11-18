Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3KRXU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:20:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44030 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KRXU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:20:57 -0500
Date: Tue, 19 Nov 2013 10:20:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the cifs tree
Message-Id: <20131119102047.a103f012e381f64da3cd4c2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Nov_2013_10_20_47_+1100_oNZ+XiZ1h_TD+mjK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Nov_2013_10_20_47_+1100_oNZ+XiZ1h_TD+mjK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Fetching the cifs tree produces this error:

fatal: Couldn't find remote ref refs/heads/for-next

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Nov_2013_10_20_47_+1100_oNZ+XiZ1h_TD+mjK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiqDTAAoJEMDTa8Ir7ZwV3ZwP/iLvov1ua4pZwyDiZca8rM+r
gnoxeqhectEXtlfcQ86Jm4vSGRmZloH0gS8qsKFv5bi2AoQ1dswZ9kBZnd+Teb/W
CLsq/4C+MBByQFraoVRh8Vf8AJUmbvoC7KsnGsfQcUiqM3c2Ig4vY4bwlYRTo3PS
LHLjODQPfON642CQJvdS2y5CRXCfKj/GkyJFqjEo3HLEYZ1Ks+GAK+VCbuBgRYPe
NcctQ6yVD6Wf7+t2Iw+ZXIoo+KyMsztNCsQQty2UP4nw9GY7Z2KyRQvf7pt4lnkz
ti+uJfFFg9Upw171DRnEPJX55QF/fwEk02Fo9k7tIRYGs8EgM4uaYab3bUKeluHu
h7EbfQTSlleeh+OJkB4FIoY8BCt423Sa+saj90Me6Nib8OOIjo3JNlbzPTpvOTe2
CYmnj/oHMKmv/PXZVLBwY4rCYPTJenJpJw0GYhqua8usY5jZpu2mCP+dpC+YItOR
1riiJX840D+Zgz97K0dF1GsQLLh2rnf2L5dv7cy5Zn4TW4xqv1FXqvWRbgbVj4n2
+XwYxt9p3kwPYg1ZTkj5LfhtcP6rqdvcvXPOSeTzaBRycC5ugnYt1W5/nAHalfMy
MSKdB+QwKaZYBGSobNqqv00ienFOe1e1/ZNv6RZ9Rww0H0kFVE6rogUWmXhm/mB7
q2G/Dbih47SKS+Ixt/ss
=OrWj
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Nov_2013_10_20_47_+1100_oNZ+XiZ1h_TD+mjK--
