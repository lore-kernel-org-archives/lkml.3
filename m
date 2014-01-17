Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaAQDX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:23:59 -0500
Received: from ozlabs.org ([203.10.76.45]:51027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQDX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:23:58 -0500
Date: Fri, 17 Jan 2014 14:23:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkxvdGhhciBXYcOfbWFubiI=?= <LW@KARO-electronics.de>,
        Arnaud Ebalard <arno@natisbad.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: linux-next: manual merge of the dt-rh tree with the arm-soc tree
Message-Id: <20140117142350.dc957c59116a9d0885e4724a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_14_23_50_+1100_d2.JI/NI5YSQCAmG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_14_23_50_+1100_d2.JI/NI5YSQCAmG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the dt-rh tree got a conflict in
Documentation/devicetree/bindings/vendor-prefixes.txt between commits
70e123373c05 ("rtc: Add support for Intersil ISL12057 I2C RTC chip") from
the arm-soc tree and 53d6b36020c7 ("of: Add vendor prefix for LG
Corporation") from Linus' tree and commit 7e73700ce785 ("of: add vendor
prefix for Ka-Ro electronics GmbH") from the dt-rh tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/vendor-prefixes.txt
index d92c88f551f9,d98fa9a6279c..000000000000
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@@ -42,8 -38,7 +42,9 @@@ ibm	International Business Machines (IB
  idt	Integrated Device Technologies, Inc.
  img	Imagination Technologies Ltd.
  intercontrol	Inter Control Group
 +isl	Intersil
+ karo	Ka-Ro electronics GmbH
 +lg	LG Corporation
  linux	Linux-specific binding
  lsi	LSI Corp. (LSI Logic)
  marvell	Marvell Technology Group Ltd.

--Signature=_Fri__17_Jan_2014_14_23_50_+1100_d2.JI/NI5YSQCAmG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2KJLAAoJEMDTa8Ir7ZwVFn8P/1VmTS+F8LdwQlpeIZQAAdz9
IDjXERHYGXFXmxpFN/a0r0+Py4I5WO5Aw4euX4cWUt8Iq/a3HI2FpocxYPLHjlVM
bUhbz9sLwU6wT3KqLvu/Q2dMj6Y79dneKaRhm1RMws2OEDIuZ1leg8W5jYAdlWMw
54kSatCbiqFccEzWbeJ3bhZel55RC0rXmBYXc46Nlaa4OrnUQT3UHsQ2VpsRk1NU
y4dUFfP3aUzCdDBArNmwByPh23UC406tFh9d2s1s6GCM4LKqbHejYC3oDJKnPSIR
GisfbiymScsVRatFdoikMjpqc39djv5JJaiDWJa3Nb2QteV2cdtvFNBaxHu8wBGe
C8XN54jBLhkP1+S0PCa8FskQg2yV34s4nXwDfAGHzP/v0R/BwCK79TjCeTT3S8T9
5ZfmKXRvUhN2fK68XbhQf+5fkFuHBPoVND29JNCMTdRc2imG+fyWzP34z7rqZ7dE
UHx9tDFmnKcW3EaRM7AzI6Uwhd/urSNVqG3pkxBM5Es9Rqe5maY6CU3y71TsxHbT
WQnttms8lkub7XtHxLW4vV27WV5Wwqe7fmbXGHgSHTvbUpYaA1KpNjtfBiWHgrW7
itFc2ug5GkZLOGqOGhmaau/+TccKiqR2EKMQT/8EkBKIGHcRF9RlFlSUa069yZJM
tqcIwlLZOtPfISDs2tmE
=Wu2l
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_14_23_50_+1100_d2.JI/NI5YSQCAmG--
