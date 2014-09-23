Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaIWISw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:18:52 -0400
Received: from ozlabs.org ([103.22.144.67]:34366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbaIWISt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:18:49 -0400
Date: Tue, 23 Sep 2014 18:18:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: linux-next: build warnings after merge of the akpm-current tree
Message-ID: <20140923181841.44b3355c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Fbv9DYWLC6YpZ.l3SG4f3QM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Fbv9DYWLC6YpZ.l3SG4f3QM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
allyesconfig) produced these warnings:

drivers/rtc/rtc-bq32k.c: In function 'trickle_charger_of_init':
drivers/rtc/rtc-bq32k.c:155:7: warning: assignment makes pointer from integ=
er without a cast
   reg =3D 0x05;
       ^
drivers/rtc/rtc-bq32k.c:165:7: warning: assignment makes pointer from integ=
er without a cast
   reg =3D 0x25;
       ^
drivers/rtc/rtc-bq32k.c:177:6: warning: assignment makes pointer from integ=
er without a cast
  reg =3D 0x20;
      ^

Introduced by commit 7bb72683b170 ("rtc: bq32000: add trickle charger
option, with device tree binding").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Fbv9DYWLC6YpZ.l3SG4f3QM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUISzmAAoJEMDTa8Ir7ZwV2XsQAIzFvl1MUHQHkZipGLcz+vbk
NXNhYtw9nPDCCXp/hk1r5R/EC6k00688AsyWEVoRn0VQpY9NdUGrSYSN6CLRFkZz
M9A5grDWb8NSohH5Agc2VnyydRbZAOi8Xs1ORuh0caXGOD3em/8im6H3TR7p2FMe
regLKu1M/P+MVNButYvTEg8V68PI18/JdwnXx72w/XujVOr9EY+SEJ01p6ocvf2Z
GRUDTkQngyHGfkoM67E0M/BoJM9RR+E7m5wNtPDC1PMzRBRGZAnK9ct0bzm6lzQs
/ka23PB3Mmf2MtGfHhJEn4BZiUx0JF4YRNs0oFRkGaI9UH694zj3z15Mj4tsrPPF
+MQSu5HYIkPZPFEfbHWGVgI3b1ziZDQ9qUHRXW+rVvi5fDcZfs757DBExwkwsMto
qoviBK0Ubj7cgGVacHjSYviKR1SsmGZIl/VavRz6UXEIq9/TnfohEcKrl523Ciir
vmVX2LcFfXEqaJ8mscy33PAsnrzgqoiNHjMI9NHxoGTmHt9hH0r1K5yt0iFrkhWy
t0pxPFVYZYDJmdkiaDXqdBA31rWVFT7FB9uy6Rs074VroNCpNQR3cF1X1CdE97pA
hHcY5IxfLjsiTwzccATo/7BBcwubyLzyDzKij/VEh20hqzkda7OqFn1VeMVJTt9e
US3oi0pNYUk7RDlDpbVa
=K6jI
-----END PGP SIGNATURE-----

--Sig_/Fbv9DYWLC6YpZ.l3SG4f3QM--
