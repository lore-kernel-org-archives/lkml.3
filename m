Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3HPCUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:20:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60915 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3HPCUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:20:22 -0400
Message-ID: <520D8C4C.7000704@gentoo.org>
Date: Thu, 15 Aug 2013 22:19:56 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130714 Thunderbird/17.0.7
MIME-Version: 1.0
To: chanho.min@lge.com
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Why are BSD-licensed LZ4 symbols GPL exported?
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2BITNIFAMUXDJHHDFOWRR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2BITNIFAMUXDJHHDFOWRR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Why are the LZ4 symbols being GPL-exported when the LZ4 code is
BSD-licensed and no substantial changes appear to have been made when it
was merged?

Also, why is the module license GPL when the code itself is clearly
under a BSD license?


------enig2BITNIFAMUXDJHHDFOWRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSDYxQAAoJECDuEZm+6ExkTmsP/00fY9VFlYiQBWObDw3Bc7zU
yolYPkU+8mh5amF3+XkX4x5fTDnCbhaZODaKHAKbMIuA4cg01HtWvA0e4KfMovzn
cTyGBJ+BhxhyLuHCKUaIHfnYV34P7/LyvkH2MaPgfBNwyDI/h+O1EWwYeewqlR3w
6uv8o/PmIbEkNxGC3bALgnHqYBoaZPO3wSvbdO6sXiNF3Zd5WroP+JBt/tfnkMk+
62sd/IjmDgmLmIDpKeUsjpmETONgSgwx1PknbniFO28qRMXch2Q9UXFnaPsG7ZY/
hHGhTdnflnN4we+FAYiSm5oedm/5EfZnHysBo12Zr+Y3dQBC+nM72lflOCj8UE11
I0/sKTD0JsKb7F6PkOurOhnIZZ3tKcAgn81ttnZe16pxeb3+LyPLBcFE/g+dsM6T
CmkRTdjgxkFfZHgwSViWOgur/+G5J8lQN0Cl33O5L3aZZgqrfQ6wdD/EKwJyDFBc
ky7LtawLsOaEVYY0oy8/ujx8tcYmpYr7tn5vNOtH1eb4uWEdbZeBfwrYXzPtXBnx
FcB2Jh7M1lko/zRWNnN6wDNLzaWP3GsasXkyxfN2UetxFtA+JZlx/xSljXbkUzN1
GH4P0rTRSy9aGFOUE0dBuOPfCcTe9I2VfE6gzJjj7Cp4m3bR2K27+QoO+MhsQjuI
rTAh+kCReKbpbbkhM8ev
=7lph
-----END PGP SIGNATURE-----

------enig2BITNIFAMUXDJHHDFOWRR--
