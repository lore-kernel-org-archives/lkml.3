Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3LPUkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:40:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44712 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752098Ab3LPUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:40:04 -0500
Date: Mon, 16 Dec 2013 21:38:01 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: kevin.z.m.zh@gmail.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add SMP support for the Allwinner A31 SoCs
Message-ID: <20131216203801.GN3037@lukather>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xTKfHyrFnSV9DG3y"
Content-Disposition: inline
In-Reply-To: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xTKfHyrFnSV9DG3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 03, 2013 at 10:30:11AM +0100, Maxime Ripard wrote:
> Hi everyone,
>=20
> The Allwinner A31 is a quad-Cortex-A7 SoC. This patchset adds support
> for the bringup of the others CPUs at startup.

Applied respectively to sunxi/dt-for-3.14 and sunxi/core-for-3.14.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xTKfHyrFnSV9DG3y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSr2SpAAoJEBx+YmzsjxAggOwQALRVqTlZEXqAybNmuiLUSPvH
6S7gK/8WwHOqMu5Weae+7pSR0Is5ctf/6N2o/Nk/vu5EXgJ+GrLYjKDOVzQ5oDBy
dnb/UzwmeziQCVztTB9Orx9Oxcyi2+303QBZJLnC6O3ArKk0ylip18Gfof17yBGo
hE7iif9hiacqiHdvlVUECCKlnuCngrZXRgIf3N65yaP3Q9RX+xgoQLoa7cmCCNZ/
CQrtnbL6lx1/VfPgGzSz1dMNo6x/mDQz/1xU2SNnw2Jp0Hi7OwiIwSnQQU/caScH
J3OYnsVr0vTh8xExGya/2N1I+EohStrmh2SWUyKGwPyAXATjqQ9iZCTjRahlyA4/
a/DDsyFfep3Kmg5vqyz2HChn7F9vpYn2NyXHPq/PwqI6roBVNCj/QeR7OBiyAgZ1
bvXtfDhP8vZY0/hDrvd37sPHYjooqPxwr3uwSn+idBlgnG1az5IJ9rB72ctOVgxj
ji7PDDOaZK/OKI6d8kGZF7OSxvhMqgr+U7hKB4Rx07etqS/n/jV7Ei7s00qL26s/
9958ykzaKNXRqPRUd7DF2wdj2kBaZWt51waM+gg4Nfq/UF0gYoVYNJZSIIPKVpuV
zuwTFMVNHjB0nsbxdSffbFByxYKMt+2VzrIbOlDovis1MMfT7oYul0mqG1ryzlKp
uKzgiX4izurT9WUgwSz7
=RMq7
-----END PGP SIGNATURE-----

--xTKfHyrFnSV9DG3y--
