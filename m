Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3KKGMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:12:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3KKGMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:12:07 -0500
Date: Mon, 11 Nov 2013 17:11:54 +1100
From: NeilBrown <neilb@suse.de>
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: how to change size of a partition in kernel
Message-ID: <20131111171154.46694c76@notabene.brown>
In-Reply-To: <1384148491.94694.YahooMailNeo@web163901.mail.gq1.yahoo.com>
References: <1384148491.94694.YahooMailNeo@web163901.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CdM3xa0azfw43e_q8tDV25n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CdM3xa0azfw43e_q8tDV25n
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Nov 2013 21:41:31 -0800 (PST) Suki Buryani <sukiburyani@yahoo.co=
m>
wrote:

> Hi,
>=20
> can anyone tell me, how i can change size of these partitions?, aspecialy=
 mtdblock3
>=20
>=20
> cat /proc/partitions=20
> major minor=C2=A0 #blocks=C2=A0 name
>=20
> =C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8=
192 mtdblock0
> =C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 256 mtdblock1
> =C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=
048 mtdblock2
> =C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5=
824 mtdblock3
> =C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 64 mtdblock4
>=20
> my device is running linux-2.6.16,any help would be appreciative

On my device this information is hard-coded in the board file in an array
which is passed to omap_nand_flash_init().

I think 'uboot' knows the sizes too so it would need to be told if I made a=
ny
changes.

NeilBrown

--Sig_/CdM3xa0azfw43e_q8tDV25n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoB1Kjnsnt1WYoG5AQJV3g//dYE48xZVpTra7m4AWGoPHcOJxgWrQVxq
8TJjuhr2U7JrAuv+Cyy05hI45OXexJnTeAj+fYZOHz5yhv6NBTJZAx9l0EoPLhK3
aK/DhGOHW1sZU3BSYpU1zf7c5K1b34BThKMF8idAdfyDtHDuJs5G5to37JrTxkkA
Nts7Zzww8soaTufd9ADyr1lHRnq3tvqNx98QpEzj3Ce8GPMYvl+nAYtJvVrjLmzf
rRe0U0dAU2vUYZ9bCDoN1Z1PSeVvE1tMDU+5eB3YMmKs4NuMEkBSeeUNVgzaRhcM
Sz2FNdlpJZvOy7zUpIYj7UwzhHwUwcJHjC0zOqW7uAnY/5tnhmocsqMVFxUPXusV
y/G1Kcm4ICfcw4oHKTeCUtt9KBt+5Y+yc2cVQCOAkxPMtqAOgHsyf/RN4evpmwNv
LuqXIqh5Y7CjVfefTfnfknOiEqIf1YQYUPuisg1W6sgtv53gE6BX3L3Hm891z6f3
LrBoEPaW1SgtjIQUt2NtBq2jqM8LFNVIyj7aPY/FVtPx8n4kxcg1Bu17oAJJML+m
lvlycf1CV0KCogaR2yz4ynXWJ4HZFtjJYCmc+3Qpw+A95lU48Z7d2HqtH7sbCwRl
QDePZykE0nVdX2TTxPqfghk1BWGuWepG7Ig2YCZUdXXEuPaLE2tsD7RiWsj6uiHu
jbZWc9xzZ50=
=i+1A
-----END PGP SIGNATURE-----

--Sig_/CdM3xa0azfw43e_q8tDV25n--
