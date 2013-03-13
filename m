Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab3CMVpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:45:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3CMVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:45:45 -0400
Date: Thu, 14 Mar 2013 08:45:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: fix CONFIG_VIRT_TO_BUS handling
Message-Id: <20130314084530.88019561cedf9a96bd01193d@canb.auug.org.au>
In-Reply-To: <201303131643.48506.arnd@arndb.de>
References: <201303131643.48506.arnd@arndb.de>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_08_45_30_+1100_h+7p2Sui5I58CnhR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_08_45_30_+1100_h+7p2Sui5I58CnhR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Wed, 13 Mar 2013 16:43:48 +0000 Arnd Bergmann <arnd@arndb.de> wrote:
>
> I'd like to merge this one through the arm-soc tree as a 3.9 bug fix
> unless there are objections.

The only problem is that, in the current arm-soc tree, VIRT_TO_BUS
depends on HAVE_VIRT_TO_BUS (since my first patch is in there but not the
second) ... that means that after this patch is applied you will get
warnings from the new "select VIRT_TO_BUS" statements (I think :-)).

Sorry about the mess.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__14_Mar_2013_08_45_30_+1100_h+7p2Sui5I58CnhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQPN6AAoJEECxmPOUX5FEyggP/iC7JbVe97ZiXThKHjYknPMH
JipnuCYed23VPpAmYlUliHDfXbQgq/5nDVsLJ2924W/vUgeXmr4O8OqJp7Jymqh+
1jj+FvIjbo0kBilecdly3Q+lmlqBpKcx8CtyaSlFtP6OdKhUkZDIKLm8v1Ia6F7v
nHO7Lr3Wc9Dx1npa4etrQ2JxpU62DEMHeR16DcJOFc6JawpuPhdTUeJQQDv1Pw9A
SO1RDaioHxxm5pBiLeRFHjwaSNa5phRyCBo9z33ykp24i1SskRpcu4tgVBrMrtuW
ivYsHXHJfcnOD8C1Ccew69L9Xjd6Lw6hAv0qJr3L2KneQY2h/CAEU/f13XIcHmjB
adnXQtdCBFnqnF73SsZrDPP7EIP0h2YBJEjnBk+CQ4/lmu6rkSRkSC2N0ywUelM1
k0iwJc5b82YcEOpSoGoMkD13AXFwnZ1wZSVIklzbyVqGuFyvwPQQknWnMm0g0WkQ
Q0g7DQBLgRPeBsTNlIiVo52pKD9O+he28XceJ/h8zhF+4cXcsjBIuWh+kWER8RQ8
KLMn/BB45vFHQcQHkaC8jLm/x2ZC2u7V2TgiVwvX7a6XdfOTzWlOlamU95/GsCgo
hvkufIVjm1RkfAloKTNzaRM70aODkLmcH9lHiy2DEGJ7TACSRaJb5QOCIy+B+AGH
9VVUtd2ITH9LgrnlMsS/
=r4qR
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_08_45_30_+1100_h+7p2Sui5I58CnhR--
