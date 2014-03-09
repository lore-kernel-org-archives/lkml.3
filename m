Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaCILlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 07:41:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55117 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaCILlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 07:41:49 -0400
Date: Sun, 9 Mar 2014 11:41:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140309114134.502cdcae7e6a97db684d6b15@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__9_Mar_2014_11_41_34_+0000_BIEAkRtpn+kZ3kQj"
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: build failure after merge of the arm-soc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__9_Mar_2014_11_41_34_+0000_BIEAkRtpn+kZ3kQj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the arm-soc tree, today's linux-next build (20140309)
failed for multi_v7_defconfig like this:

ERROR (phandle_references): Reference to non-existent node or label "sysmgr"

ERROR (phandle_references): Reference to non-existent node or label "sysmgr"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [arch/arm/boot/dts/socfpga_arria5_socdk.dtb] Error 2
make[2]: *** Waiting for unfinished jobs....
ERROR (phandle_references): Reference to non-existent node or label "sysmgr"

ERROR (phandle_references): Reference to non-existent node or label "sysmgr"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [arch/arm/boot/dts/socfpga_cyclone5_sockit.dtb] Error 2
ERROR (phandle_references): Reference to non-existent node or label "sysmgr"

ERROR (phandle_references): Reference to non-existent node or label "sysmgr"

ERROR: Input tree has errors, aborting (use -f to force output)
make[2]: *** [arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb] Error 2
make[1]: *** [dtbs] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2
Build failed

I have tried using the tree from Friday instead but see following mail.

--Signature=_Sun__9_Mar_2014_11_41_34_+0000_BIEAkRtpn+kZ3kQj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHFNuAAoJELSic+t+oim9AAQP/R0vD7+OrjVtA9GEwA+2whdF
UucbEV1dMZSvJCSItYyLvbkzr3SksrTrNNhQhtz25+rllR595N2qfOJIxjnp0X6h
PYFmxrxSay6u4rZMzoZUums6BJUPUKmdxJx5hiXpOh3VZCmEgW5UDjXJzEmWM9hP
TGdRvc2XDo/wBlZlRGptdOFCy+PVm/HCzRlGtCy22BmBdLpJUeJy7xfy1sHQUtOR
yHrOzw72l4PAPPUQqx2Tms1dSe+duXX5PL/YKNnIGGlaTr3bD7J0XcepCm5boyDH
x4dXjAQUChG/ohRzlt/ol5CVnq4vvB8cvYHKEWcyYcm0lIi5tIoaGzS37wpENtLk
yAKF8kA5ei2YWK7VQSOoWewKtPnnl21/ydMyOKLWtAOrW1BCjhtJxQ53VGexi+ha
xiGugr05+148J54SUkVDYVsDWDxcqcK9yBlKMcxK2IhvSIdYSCzkE0jfbLQanecO
rT5wiM2TDlcIDLgv4Qeil96lRRlS+bAzmemJZAjXwz/zueh/+aFyt2xPfsg2oNBv
z9i52Pmr5PqgAGl0/PeFpKy+CZzXBibgcQvpy8RSdpyft7/xwup1Q0NZ0es8mo9j
lQ/UhTKe84n3FJdu6UgZt88sSJKUgqkmV2hbMHrAMQLgG+NoXmyyzbzHT+u7uj9r
bv0uVmsxW0jlDA77SbsY
=wSGW
-----END PGP SIGNATURE-----

--Signature=_Sun__9_Mar_2014_11_41_34_+0000_BIEAkRtpn+kZ3kQj--
