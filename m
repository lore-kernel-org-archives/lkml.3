Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3BRWr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:47:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59396 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab3BRWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:47:24 -0500
Date: Tue, 19 Feb 2013 09:47:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ouyang Maochun <ouyang.maochun@zte.com.cn>,
        Jiang Yong <jian.yong5@zte.com.cn>
Subject: linux-next: interesting commits in the cifs tree
Message-Id: <20130219094716.530b3d75b4fc850fe1629456@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Feb_2013_09_47_16_+1100_2PZCk9B/O+tLhdK8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Feb_2013_09_47_16_+1100_2PZCk9B/O+tLhdK8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

I noticed this commit in the cifs tree today:

cc67d17bffd7 "This patch applies to the kernel version of linux-3.8-rc6."

That really is not a good summary line for the commit and this commit
appears to be authored by you and committed by you, but has no
Signed-off-by line from you.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Feb_2013_09_47_16_+1100_2PZCk9B/O+tLhdK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIq90AAoJEECxmPOUX5FE0tkP/3MwVaaxTyvAEyjYmfdndhXX
vzdSSuKRrLCiZOEQhEAllJ+Ywy85bkSKMT08EqdQaMlXNIiD+Nqg80N9abmJ27hq
+Czkz6SI5FtuBeT6PSPnbLfv1/4gxLhwjRktfKf9LFI6pg/YQPX5hFWi69LtrWVU
oDdRnDNecGu5Vu9igP+OgD7loTVfi8ZBXErrYHPGCE751xKBi57Y9UaAn/6RXAoV
wO1B5YPRFb5xYQotyUAFWCZZ+WJ0UkmTflzzGp7+gRaun2eQzEfHLrSWK5prD+CQ
lf6lVkEizxoGwpMvNypJOjvMU7SRtwc38bOXJP83rzZlHkucYe8jBUEvu8pECJzS
Omd7QUciguLl95MjuQXfdv7ajgl/MhQEqjH1U+gqYkKD7ebeKk7E+U9AQP9TlSJi
2TZFxSiXSvXKyhmBnCQr2shGdy/vwyMyYvmRqLb+gIGlgUQu3vRSm2BUqk+YN24q
udIVL8//3sR+myYp99PEJzEghWCjoozGrROyUprj43SGEZ4FtKJ8UxZXL/UBTN1t
HNHPev2yDiSsdH4cNyUKr4Me4SnqpI6zkgx9U54Uj4IZb8x4sBgdz7fVisIxwyrY
gFVCGsyWs/fNR6PSQAkH5UjBQm1rhg27ih9HJhPTKLsmCaqbjLIIOvpgCPMDc0+j
pfKSI59g1Ul0Jp3sslSD
=TWhn
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Feb_2013_09_47_16_+1100_2PZCk9B/O+tLhdK8--
