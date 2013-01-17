Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3AQVBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:01:48 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:33790 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3AQVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:01:47 -0500
X-Greylist: delayed 3369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 16:01:47 EST
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: linux-kernel@vger.kernel.org
Subject: btrfs userspace question - where's the utility to dump/restore?
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1358453135_1911P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 17 Jan 2013 15:05:35 -0500
Message-ID: <6196.1358453135@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.50F85991.016F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1358453135_1911P
Content-Type: text/plain; charset=us-ascii

So I'm looking at playing with btrfs, and I start looking at the
userspace pieces I'll need.  What I can't find is an equivalent
of the ext[34] "dump/restore" package to dump data to an external
backup device. Is 'tar cf --acls --selinux --xattrs /external/fs.dump'
as good as it gets, or is something else recommended?

--==_Exmh_1358453135_1911P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUPhZjwdmEQWDXROgAQLKHhAAtddys/v5N2lULTfwQmDn0eVRKmIBG481
zJIwP/NGwhNc1klbxb8zOPBEC7WCTiLy76XUBjIpZ/Qc2QOwQuUvmOmHIZXwv3Gy
hmsoRgunu6WR4qd954cjQUpiqQVDznMdHmmCVroawrqZFUsKN2rFkNF3MWLo0rdd
z4Mi+uKKw93SJ41PmT973WFdbIB7jWfg2q7HRZcuGvkk/aLG9i2XrqAPKDMY35F/
z8I42Ye/MncNbS6drr/6YhJzvuBKK7NaXIH+E1n1Sy7YfbwIFlETmACKdBS1LKD5
MUHirj+rCTw3ldi7TB1iu//1sXLX81TcNuEkzkTeWxP8/NLlT32xIYV7iRMlOXZ/
cA3rykBKVTtPj1N5I19Zg0WD2JRCK3UB2883bF2d+LqNaBnmezJfSA0Puu3pYqsr
cQwwWMfOfJ5laWngy1sc72J6cON0hU+ON+TbGrOvdhyNgi56DB+3N9g28B9NlJ0J
o3IoV14+laIOySE+7dPIgB4lKHQQFJu5Z3UHgTl3V/TV1V0Y64i18dUqh1i21t+R
jvdng4NykDlr5ZA3CizjEq7P0SdDtXbC6IBzhGdCxtWHn6j1Yu6BqDg9aitHO88v
SpXQRn/VdR/+JpeQU6srZslETHSogYJd/1DtzBMA3QRwSxP4FrAwS4EDaloKK/ce
iY2zbdOw5m0=
=Vt4t
-----END PGP SIGNATURE-----

--==_Exmh_1358453135_1911P--

