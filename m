Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaGKFVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 01:21:39 -0400
Received: from ozlabs.org ([103.22.144.67]:59019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaGKFVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 01:21:37 -0400
Date: Fri, 11 Jul 2014 15:21:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Kristina =?UTF-8?B?TWFydMWhZW5rbw==?= 
	<kristina.martsenko@gmail.com>
Subject: linux-next: manual merge of the staging tree with the  tree
Message-ID: <20140711152130.45a6978f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kNEhfwjVU6gkoloKmDFb/Pt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kNEhfwjVU6gkoloKmDFb/Pt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/dgrp/dgrp_tty.c between commit e359a4e38d22 ("tty:
Remove tty_hung_up_p() tests from tty drivers' open()") from the tty
tree and commit 19b1e7695be8 ("staging: dgrp: remove driver") from the
staging tree.

I fixed it up (by just removing the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/kNEhfwjVU6gkoloKmDFb/Pt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTv3RfAAoJEMDTa8Ir7ZwVl6oP/R9xKRGI0oE0EbX1rxrJrGMa
AhusOHiX1IKLjpvXfKBD02+/OSR2CtMK5yKCEUL33ax6/4bothSfWsOzrA9jejY9
kLiXr/m8CMI6qJgAm/o4voG/gGFVG7k5QP7rFWzuHNxbvhId19AK0HGMtih2l4vK
TZW9heKI17t1kg8+puy/VwY3iWtqDIgtH9HdCinOOoKOtW8YRYBdRRCVxUvkH4cf
UUqM4HvYXa6x2Pnt05GylAHsiHW0/QENHp0XsebzCq8OXpJCPC5DQdLSucDJz6Q2
33dAosOW5PDrA8YTgE0CaxxAUe8r/6GYRdPJU0L50+cRWGzVKXYTKBBMNoVU0ZJF
kt+ovJBlA5Z5v6qJgppn00LCHx+6LUckecCrh8fKywPATHbp5hQFNnJZx3Fwxa+i
fuXp2gwRUNJjC2FZrrG6FzqPigGQTgId10j3CDohD12n2wCv9uvXcpCPOS7fkqfF
kWV3U0tadudsO3w7y+Gk7rXeij3CBTT98Ily3IFI9x+06O8PHp0uzxwrcYyzxM+s
IOxZhigHb4ujqDueMVTtSohNnqcozTyTSl5gLm/C/4Urfox4UUILGCXSDkFl3oyY
MvIVL0wpZuORxDb8cDMlf3Jsw3o2FDwlzfdF1//G41qxKTGYtpCNkvtqnpfdL4oZ
wGX3l2pAhkGBaWMm3f4G
=dPsJ
-----END PGP SIGNATURE-----

--Sig_/kNEhfwjVU6gkoloKmDFb/Pt--
