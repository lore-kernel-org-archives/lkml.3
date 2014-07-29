Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaG2XZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:25:04 -0400
Received: from ozlabs.org ([103.22.144.67]:47420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbaG2XZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:25:02 -0400
Date: Wed, 30 Jul 2014 09:24:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: URL change for mfd tree?
Message-ID: <20140730092453.089e1094@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mn1iYSp1kdcZdd_4sOMW7D0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mn1iYSp1kdcZdd_4sOMW7D0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

I noticed commit 71e297b17bb6 ("MAINTAINERS: Update MFD repo location")
in the mfd-lj tree today.  In linux-next, I have the following mfd
trees:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git#master
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git#master
git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git#for-mfd-next

Does your commit mean that I should remove the first two?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mn1iYSp1kdcZdd_4sOMW7D0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2C1LAAoJEMDTa8Ir7ZwVTMQP/AvnNqZmDkNe2ZIqUbcTsmms
Ce63sKeDkUqe9CLJqi0k9QuL8JkTEqEXsAwqKQX9vcggvfhCLvrroRpEyDAR5ilF
U+bx2VvSxLA/WOZKScNPDI6g2NpDtRVRMnAVfaMX6Q2nRHMECMyq/yx/UBmo9yuh
gBjb9qS+NGoFbS2B5dHld0KfzU2/0XlbHjTUk6lZIcAj4LNoAuuFEIf5xqPVTIXU
cLuAnS1xl4n/W7wDyK2cQmBBlygXwrkm0uOMCK80LvkWJl6s34KHOR1/9wFM6ytP
ShwokR2Fl//b1TYBshi+CfBqCc2QOX5AuNl5k79z8yyZ/jApihHZuW9lfuCwFnix
iRklPJBk8gAcdi4mG4ECFHtpV7KIUwEwVbK6y3dX2f8zmd1YMMc3eu4Ab/D8KrSC
7HggRsdVHOrTlvvbkKyaQd7CFQrJdGclvX1Q2TEjxC1rqpV2/+tyk+1DvZGAI6Wn
Juv3KGlqoEXwxKeA7dZZbQkHJ+kIcX+G+ocxi48D4y9xRcmBnW/SXtIdinodUg8p
iGVolLuRpi5r83hAYda7uJAKDnILOzYwYFeDayTziHNfJ3v8bi0AuUA5cAhk9ZbG
jjSrKJtesunsJHuUyqNyDdVrfXk7fL5j3vgGdkN0A1IZ27/mIDPjcqimLKUV54nV
+ccw6s2JNSEX4wSqvYaH
=f9rK
-----END PGP SIGNATURE-----

--Sig_/mn1iYSp1kdcZdd_4sOMW7D0--
