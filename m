Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaI3AMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:12:42 -0400
Received: from ozlabs.org ([103.22.144.67]:39348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbaI3AMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:12:08 -0400
Date: Tue, 30 Sep 2014 10:12:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jiancheng Xue <xuejiancheng@huawei.com>, Wei Xu <xuwei5@hisilicon.com>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Message-ID: <20140930101200.1239cd52@canb.auug.org.au>
In-Reply-To: <20140926115539.6873630b@canb.auug.org.au>
References: <20140926115539.6873630b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7m.r1L3LhVQOJ81s1RtjBvI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7m.r1L3LhVQOJ81s1RtjBvI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 26 Sep 2014 11:55:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the arm-soc tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> Error: arch/arm/boot/dts/hisi-x5hd2.dtsi:374.22-23 syntax error
> FATAL ERROR: Unable to parse input tree

OK, now I get:

Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:417.21-22 syntax=
 error
FATAL ERROR: Unable to parse input tree

Are you guys really testing this stuff? :-(

> There are a series of new commits to this file today and I have no idea
> which one caused the problem.
>=20
> I reverted:
>=20
> 610bd8722ef4	"ARM: dts: hix5hd2: add wdg node"

Reverted in the arm-soc tree.

> 6868feb6dd97	"ARM: dts: hix5hd2: add gpio node"

Error is now:

Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:183.21-22 syntax=
 error

> 420a2d55f046	"ARM: dts: hix5hd2: add sata node"

Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:183.21-22 syntax=
 error


> f16c7fb2f3ff	"ARM: dts: hix5hd2: add usb node"

Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:183.21-22 syntax=
 error

> b196e1ca400d	"ARM: dts: hix5hd2: add mmc node"

Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:174.21-22 syntax=
 error

> de8b6054780e	"ARM: dts: hix5hd2: add gmac node"

no more errors.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/7m.r1L3LhVQOJ81s1RtjBvI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKfVVAAoJEMDTa8Ir7ZwV7kQP/2sqQsh/WWo8VsVHmVjXx4cn
aNstsRKX/i6pfL0ojWlEiO/Nc7hFFj720aqa19424tbkN540QthXaMMlyyEvcUMK
K3F9Ug7Eez/6dEwauPD2whex5XqnNbP1eJ0xrjrcJP6GsQ/gwptoFBAeUQMGecc6
wIHfEcdnr9I0W0WbR+yN828VM6Ef1DalKmkrCvPcyAceZVBhYzx50GRWKsrTveX8
22FWgG5PqeAYPYHf+vzqxpARFsj17F380Mb0JOMG4GEaf5BWw86ZtvWYhsw0RVKM
J68EC7WV4wRl1GnJXsjJWM5iJlb8TPmJLwQCNpMiEPyi+AQ8UwVvOB15o1dWuNmJ
FfjMEhbeuAQJZjCtFjAh+WxTWWqz2n4uSP/kxaf27d7n0e4tI/HrOsL5SzYVVz1K
seEaeeFHuvcYhvZ3qNep1lhNbH8kJkoi3/udIPHe72Zx63SyfQZ7dl9rboQ+mB3u
uY/wbur+6gKHIAH/m4QX0NY+zuY5ZWmKiCm6AOhygiNpvNgJ5qEMF/GtMS9E+d/1
VcbfB3k6DNGsQ6+oN8UHGtmtCIpTCUPr4a8pqig4OaSKag2UwFLk4Q8VK+d2UaGX
Vn2oPuH3TLGdjAXp0epFJgpkrhCS7VdXpYKp226DckKXGQPp2BqGddK0YNQQobuh
C8GyIapn/MnaCnzpIoii
=FyZg
-----END PGP SIGNATURE-----

--Sig_/7m.r1L3LhVQOJ81s1RtjBvI--
