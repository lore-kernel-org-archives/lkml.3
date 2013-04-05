Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3DEEdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:33:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58374 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3DEEds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:33:48 -0400
Date: Fri, 5 Apr 2013 15:33:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: linux-next: manual merge of the arm-soc tree with the xilinx tree
Message-Id: <20130405153335.baf29606a97b1bee415f3546@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_15_33_35_+1100_Hh0d19sgnc5J/3Fs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_15_33_35_+1100_Hh0d19sgnc5J/3Fs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-spear/spear13xx.c between commit c79e33b3e828 ("ARM:
smp_twd: convert to use CLKSRC_OF init") from the xilinx tree and commit
2b9c613c4ee1 ("ARM: spear: move generic.h and pl080.h into private dir")
from the arm-soc tree.

I fixed it up (just used the arm-soc tree version) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Apr_2013_15_33_35_+1100_Hh0d19sgnc5J/3Fs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXlQfAAoJEECxmPOUX5FEG6gQAJLq0j0Tcld0A19ondF7Og/T
17RInsKaSVIJi4vo0GGb0yS/ekaIbkB/oNA9Pfq6DiDYq8qbxoj+GqkcZ1PFWGLQ
vW54h77kSAI5ksleT0lthE36m5UDl2LBoUQrlgmNrfdgUAhAffFePCi7dRoyo2jI
pAOHIz3IdopK7FkDHwMGreE+okiwRaPhi+zyWbX1fjVS6PX5SQKeA9//o6aCOkWo
uN7WCgvetuw4HYDFVFYZvXBWqgsxGp0ouTW3TQ88uhcaucb7PwgJuM2c7PqzBDpB
D9tec+k6DIT/mqXLPLvCQ/PZA3LEIqKqk+iOtYMPaoF/xpoA58Y2nSTBlSyjbsxl
NXbY7FnCDF9VLi4Jc3t78MlLgaNC8G3k8BVtAf6zDnfHgyK5rIolFRmHTDQmv7H6
XmhwYSAvVb5tmTxlppiwEgyLMexK+rGvPlIkmnjwEVcB0JUxVx3OLREJas4qptDi
A0cUDRj4tRtUfWi/BsniusT0a2GTaxcJvlCZMnXw7vhKxURnWkMlO9pD4WvcICZJ
SuORvbdCcVEPtU1vAXzPsVA2FeP5kH5726ey0PlFtfG18yw/3JcanQ0ITjsH7fxT
cFlyj9vY1fdNF3odOQDsDS5kJyYnrk8EXRoy9OATDnoxtXpI07qx6ZJSJiQqNK8Y
Z/JKtnn5GPTs2zkFf76V
=bWz2
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_15_33_35_+1100_Hh0d19sgnc5J/3Fs--
