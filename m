Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3AKEcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:32:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56674 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3AKEcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:32:14 -0500
Date: Fri, 11 Jan 2013 15:32:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130111153206.e075edb9b1e4a38d90f23ab6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_15_32_06_+1100_ptofYrwzzULiXqZE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_15_32_06_+1100_ptofYrwzzULiXqZE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got conflicts in
many files with the arm-soc tree.

I just dropped the samsung tree for today.  Please have a look and try to
fix this mess up, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_15_32_06_+1100_ptofYrwzzULiXqZE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ75XGAAoJEECxmPOUX5FEtN8P/1lvwIWfx7qU116Xr08RUMdD
8HUljyGZAnaM+HFqhRAZA2+RDPLK1q86ycd6i30/zl1K96gpgm/vCelIfiEFWXhd
ojLEw1/6w1izQ+g9v7KhWYBCpVNNxzWNsGWVcjCbH4FGV1oa2C4+5XYH9z0F4zq1
6W4lENfAj6agA6qnMTroZUNqK1layQJcQYz/aPMfAIz0zNznEfvDCwuN+9cuKH4t
ua+F1EdqBasQqDoWGH+QVV5JVJ5OP2rFRPM3noCKvDk7sthg4JTV4tVs6oriU2nd
tx4m6ucxl8aXamAmhSq3S+Efe2Vuxhl7/jwcsPwDZxFdCzK0SHh9+CzWPM1tk8Go
ju6uz+i2i6OtDwKkT57lABs+5LX4YOWy/P37jsnROw+VxJ+o8A3y4MfGZ+gIM684
u7pZKjisjAQCRXNvGzKjhYonTaTT4ymxiFXay/4/tABam7pMq0NxtGhpw2elCaIr
gQPBDZHiWDnKSwc+4QTRsAlrSWsqVDmneptQcCYDO4q+DErgJMUb8eVeqjvPw4Jx
EoTGnU7oeV1Afr6+/ztBGcu3OjZ3ZXdRYY16/V4XGdP2gq2FtUI8DROYz3rs2USH
jSHfDBfunj+I/bDsl50tLGOilvlMN8osZNCC1xM3ArAlHBs6Il2j3PVSD6dHJQGp
3cl3mIiwethetdB52o6e
=2reA
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_15_32_06_+1100_ptofYrwzzULiXqZE--
