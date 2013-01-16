Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3APWZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:25:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56352 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3APWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:25:46 -0500
Date: Thu, 17 Jan 2013 09:25:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error when fething the git.secretlab.ca trees
Message-Id: <20130117092536.f1a4e0ed60610845cc919b15@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Jan_2013_09_25_36_+1100_O3qN4617DVSVMS=B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jan_2013_09_25_36_+1100_O3qN4617DVSVMS=B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Fetching the trees from git.secretlab.ca over the past few days has
produced this error:

fatal: The remote end hung up unexpectedly

This affects the following trees:

irqdomain-current
devicetree-current
spi-current
gpio-current
devicetree
spi
arm-dt
irqdomain
gpio

I am using the last version of each that I fetched.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Jan_2013_09_25_36_+1100_O3qN4617DVSVMS=B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9yjgAAoJEECxmPOUX5FEzrcQAIxaXMYr5lKFaATs82XTzUAa
kvp+I3ndUNHSVfsam+WictPE95RlOTw7kBp3aFlgV7AYicgbMFlb8E+fwibVu3qH
zM/kNEa8NcivauU++3NXaieF2lOLFpZJoLbsWg1DtXHSA8+CniAUEV0XbLfZCWcM
lB4LSzTvcbcMn/1uOZSEv1AYDHvwbSg2Fcjitrjn+pew1kdS78Q6usa9m9NmvztX
9OcmyM1r0MHqbmujKPSumRejXzgitbfcCBwJ/O3Sm8ItmRlm4aC5OZMzl2G887q/
jLOm92oi/SOBrWFYNE9N82aLYi67jr2GTyfypN08SYWN46DfB7GCd5kn11nwhAPJ
Ix1knO7S7RJ0eBYBiO1Xiv4Osae5oFU6JxKrMMCSPdvyK6Nd2iQ8KG/3vcxl48mI
OMNul2EA1tCzq+vLaFCMZc6FPkaD+vSlBOASL7pkxqfjP98W3H5OOJNe7FwNJHnm
0hHnMg+WlbBTQHh1hJWmbOMzOyT2WJSY3PVesYWBUG88FRTGJBeiHAUICYDexYIA
Pm7VaTsNoJhogYev6v0/7mqp6TqfBTjQZUgWX4w7AKGY3cpJd3LTZQ6YNTf6CVRU
EQkYsY+kbY23qJEhD50MPXCc+KFEuan94p9oHjMdB5UPg5OmuHqpjdT3KdqI0csp
lH19PCfDz60qq3d1myo3
=glQ8
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jan_2013_09_25_36_+1100_O3qN4617DVSVMS=B--
