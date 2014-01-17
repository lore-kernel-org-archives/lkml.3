Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaAQDLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:11:54 -0500
Received: from ozlabs.org ([203.10.76.45]:54420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaAQDLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:11:52 -0500
Date: Fri, 17 Jan 2014 14:11:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Ebalard <arno@natisbad.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the devicetree tree with the arm-soc
 tree
Message-Id: <20140117141146.8c6338ce852268d2f5ac22e7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_14_11_46_+1100_4ou.FyB3qpoGCdN+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_14_11_46_+1100_4ou.FyB3qpoGCdN+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts between commit
261e7735d0ed ("ARM: kirkwood: NETGEAR ReadyNAS Duo v2 .dts cleanup") from
the arm-soc tree and commit 40aad3c1a9b6 ("dt/bindings: Remove all
references to device_type "ethernet-phy"") from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
index 4d2a8db9ab77,00c0669b1b8c..000000000000
--- a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
+++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
@@@ -241,8 -210,7 +241,7 @@@
  &mdio {
  	status =3D "okay";
 =20
 -	ethphy0: ethernet-phy@0 {
 +	ethphy0: ethernet-phy@0 { /* Marvell 88E1318 */
- 		device_type =3D "ethernet-phy";
  		reg =3D <0>;
  	};
  };

--Signature=_Fri__17_Jan_2014_14_11_46_+1100_4ou.FyB3qpoGCdN+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2J92AAoJEMDTa8Ir7ZwV9mYP/0l/QZLcVUDkPZ1f60K/LNVV
roc/M4wa6X7EkB66nX/ES2uPe/9huLsqRb/BsSuvORsuQz3O0csceiUNvBsRPHP2
b1EHpwFginkVKwzXVRWL0H4DcVlc4bvl1HTGyY/a+/3/K6X+BA9/ipr+e8M3hiBo
QtLXf16i2YhainvaWlO+qSlxImgudZ0bqEN7G8mYh+aK4qasc+swu4VYYN08tAsP
u5xsJHKmDP/oIgXJewkTJANxLDO1fnV13FNYx3nQkBHKEYlhO0oPzJo4gjR4gCPg
+n2etbaGibOlUJxqgFDlfn4Hvc2hampPby2GQ85MQXZj/X55dJuDQUzrN9uAzsPe
c9ElS0WzZ/F0jmDjjEpBnDOcNoqfJtdofPxlYPvYncUOQ/Cxe8HkgTdeI989Own1
HNvyiaVFj6eN9P1bnsJJgZ7HHJYNkMjEKH3LfnqFeU1HWpIzAzo9GLyyuXrui4gJ
1B4Oa5x66wfnpACAuh8GnoPOumImtodA9VJ7ezedbx90Qw+tbDK1cP0QAkQMnGMh
MMlJa2Ao01FDIUY7lbFcsP5kxOS1zStqzjiJM7dwyUPKM9nrM5gqjXSrsGLeUaa4
deRo4I6MLqNIiJKRydold8Y9O1J2ZrrMnMqS9Gsl4Sw9Eg4MFZjVaTewbeUOXVFm
kUWfnENl9m/9i/7Cisuz
=jaa7
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_14_11_46_+1100_4ou.FyB3qpoGCdN+--
