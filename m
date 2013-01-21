Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3AUEHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:07:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56682 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:07:20 -0500
Date: Mon, 21 Jan 2013 15:07:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Frisch <wfpub@roembden.net>, Johan Hovold <jhovold@gmail.com>
Subject: linux-next: manual merge of the usb tree with Linus' tree
Message-Id: <20130121150711.c4673d930c2f00253c2e471a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_15_07_11_+1100_uJZhOeWf8EiiHT.G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_15_07_11_+1100_uJZhOeWf8EiiHT.G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/io_ti.c between commit 1ee0a224bc9a ("USB: io_ti: Fix
NULL dereference in chase_port()") from Linus' tree and commit
f40d781554ef ("USB: io_ti: kill custom closing_wait implementation") from
the usb tree.

I fixed it up (the latter removed the code fixed by the former, so I just
used thet) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Jan_2013_15_07_11_+1100_uJZhOeWf8EiiHT.G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/L7vAAoJEECxmPOUX5FE64wP/RVnQE2QY71bzVWCm9RAfzp0
YUipy9+7NyRP43mdn+PrVwcVx3pfFxjseFxuyASQ4qBo52WxD6bMGE8ovzgVSvuF
Zwx1+bTF2RF6InmMEcBPzYnMdj/fRk18BMp+9ye8hFL9LK2dTwFvHbdbGpaCfRfJ
mUYzJQ4xDEcAHVIfQGW4g3P5wpISRsgdfMUkm1RG4266gaEJu9kPbZijFN3UR0RM
up8JAwLbxmEWqepgiFTdfqZXG1iWQ25pXshISTSsk2rYQCVOgVfuCIBV1q4MqknL
QfDjWyAQ7jAkPS7HVd7L5bxgw35/wGFPYA/uRJCiTQ1/XAs9RxOb60dUUHB+Cpub
soumAEADJIIyik2ULO445cjG7waDsxXqbh2cKZRcp5QtuMycvLVEPCEFdEIf4YfB
7Gs+myuoU68y1iG3YKCeuy1hQItdPrhA7wY/tUGef41JqOjADiS0BQx5VUsA5wMH
cUr3CKkioYsGqSzsW6oHHePKAzEmRwe/CBZ4DtX2d+etGLAGG9CnKGnegTCSyEJh
0icxx/KoahvRUkRjEk+QRPQiS0mMKhisaqx0BQ9OoEVaOQWBmsBkLNKLzBSF5Lm8
1UeUxv/98U4ermpsr5+Z+H8SGcto+b4krta9kWJel4JatleSpuG3S1ld4WjYJ23j
go5RnH/gSY9tRm7c1xKc
=fkN6
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_15_07_11_+1100_uJZhOeWf8EiiHT.G--
