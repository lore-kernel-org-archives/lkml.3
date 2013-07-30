Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3G3WR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:17:28 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51242 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3G3WRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:17:25 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: next-20130730 - Seen in drivers/staging/lustre/lnet/Kconfig
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1375222608_7183P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Jul 2013 18:16:48 -0400
Message-ID: <11551.1375222608@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1375222608_7183P
Content-Type: text/plain; charset=us-ascii

What's wrong with this picture?

config LNET_MAX_PAYLOAD
        int "Lustre lnet max transfer payload (default 2MB)"
        depends on LUSTRE_FS
        default "1048576"


--==_Exmh_1375222608_7183P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUfg7UAdmEQWDXROgAQLxNw/+JkOwYhd20hxNH5KXHwXFsdKIpoOtqWzW
cQzyoUwFuuKaANPxSzJAqMdl70wxuSYyUSf0DwwIIFhJQSoP7qQZ0RDVrhQj+CbD
SwYkKVzJnyrCkAz6z1KMbWVws2uzHI89Y3xw9l1amacXFi3Ztal6mXJYOzJzgQCp
M+9PBs8AJPq6EzEIwBWDAbXeBtwQn7l5pE2MbxeFLwVaBH3pbgwzoWb5sgQ1Olec
M9+eWJAmuw48qIscAJ81iat/cT4gS1wqXFj2QZPB2fDqTNYTdE3tZpn4WOMrh+Zk
acHu1R8BSUpURq00NbMqgQ5/GNYhtZcyod1rC8Y1ML2XQQfLqIOg+wwiNzd5p4v+
i+kETbAHib/jZ3Wnudg/ij13x9YgAqWRhWKLYmJTe3jwYK5OJ7CTUoVyh69U9UXa
8P9GmN8ul/98zpUAS0VXwgJTmcxF1HffM/geryl/nPdAr57laRoYIMRYynDt/Kk7
PmH5OQ+dBmuhb671XZDKuhuHvQkfXNLg38vbnB7bBAi0gck9UUTNaxN1fG3aH7yC
DI+0IVWFL2UEcCJLREbMVL5ALUdIvPfaHIT2w79kRdbssPEz9+6xdorRxekjLzEx
vLF6PWQ8nHGVU9UgoJvv4snXzUjyFcPbAQb0m134R5aov5zhla6K1yEJX73JQHZM
3aXvcjbYlVI=
=86s6
-----END PGP SIGNATURE-----

--==_Exmh_1375222608_7183P--
