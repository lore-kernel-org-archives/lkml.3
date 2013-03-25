Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab3CYGUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:20:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53472 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3CYGUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:20:46 -0400
Date: Mon, 25 Mar 2013 17:20:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Cc: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC:kernel: make additional room in exception
 vector area
Message-Id: <20130325172035.7ecf486f05009afb4b603529@canb.auug.org.au>
In-Reply-To: <5944.1364191637@ale.ozlabs.ibm.com>
References: <51428C81.6000204@asianux.com>
	<25841.1363323174@ale.ozlabs.ibm.com>
	<5142AE27.7060003@asianux.com>
	<514AA0D9.1090509@asianux.com>
	<10123.1363906486@ale.ozlabs.ibm.com>
	<514C0061.8080004@asianux.com>
	<29457.1364169818@ale.ozlabs.ibm.com>
	<514FA8F3.1030102@asianux.com>
	<20130325161435.ffff94805826bc7cad2c7de4@canb.auug.org.au>
	<5944.1364191637@ale.ozlabs.ibm.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Mar_2013_17_20_35_+1100_1iDW93=VQb7Fu_FA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Mar_2013_17_20_35_+1100_1iDW93=VQb7Fu_FA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mikey,

On Mon, 25 Mar 2013 17:07:17 +1100 Michael Neuling <mikey@neuling.org> wrot=
e:
>
> FYI you're gonna need this one also to make allmodconfig work.
>=20
>   http://patchwork.ozlabs.org/patch/230244/

Thanks for that, I will add it to linux-next tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Mar_2013_17_20_35_+1100_1iDW93=VQb7Fu_FA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRT+yzAAoJEECxmPOUX5FEMX4P/1sgJBPMfROG7pOapNG2xaBw
EtJqvTu3h1E1X0yFH5FbbAdYSmJgICFsg2l9RMPzf6pWL/dlAPoAfNsbCcMNLzGb
kyP7pmxWWwlCSA8SVRIvOb9ea270gwTxoR0RUsnPFfBQRFEXeq7wsqZwO1orMXKz
KgaPsqLXKJBy1TLsTQBRpiitae1UWR7mD2FDWc25yfwtRbEK0ZKvFl3LRAchxODx
JLeVX40iejEwWTnSqwJgaXuK6LEv123w9yFwM1sL3Q2EJvBzITaX8YfGRcB4h6un
tHZrPg5PXegHNhrmTViZhpUR9wmk22cUkr6HV67WUpe42PEGm5G+QUNodL8q71gS
l7rtdBJnXJA2WqU4Br/8lgJaeTEChVXMxulxHCvQO79HswLvSYq5REXwDJ2yJaCM
elA6ZxCCguLSa0yhw5/vDbxSn3zU0iJpqXdKxhxInet7ht4rA/vuTl95N8xB6G9S
B4rKDmkfFM+Y88L/3olzfKNEDnO4WQ1UTYy+wpbyhvNmcbeOiuvAECuOuqaf2q1F
NBGR6RZ+xt516PhUnQG7qJV6o+s2spsxXahl3RLlrbRQOfQmDQzB4S4/sU8PZobd
XwZIISeeKucMNA5zDlcMvjFLGoXAmhQF06j3T8hniFmBcYZxDrvzJfu/sLB5C+4h
V4TCX98M2a32FLG4PP6M
=eNIn
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Mar_2013_17_20_35_+1100_1iDW93=VQb7Fu_FA--
