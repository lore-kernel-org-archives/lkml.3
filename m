Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbbAUW4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:56:50 -0500
Received: from ozlabs.org ([103.22.144.67]:48172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbAUW4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:56:44 -0500
Date: Thu, 22 Jan 2015 09:56:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: strange commit in the mfd tree
Message-ID: <20150122095638.46a0b503@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/dk98fxO8OtbckH5zoCwzmEe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dk98fxO8OtbckH5zoCwzmEe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

I noticed this commit in the mfd tree:

f11b9265e6ca "[FIX/HACK] Disable DRM"

Is that really appropriate here?  Especially given it has no explanation.

I guess it will make my builds slightly faster :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/dk98fxO8OtbckH5zoCwzmEe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwC6rAAoJEMDTa8Ir7ZwVqLAP/1PTJXNnk2X7hKx2NCQzfwOC
fjri4nutF8b/ym3vfYpanMW9Nb3iNCI2bCeropCTFwBRas4kcv46YSvTWZJLVmb+
l+9AdPNQVLZ+HGvOe6qa8gK37YGD6MgblshFkeS1bsnZNrmXMRyyxy7pX3rgMY1a
mJC9sR/kspirxMOQ/0XvVROhcB11OpBDTvXN1sf6F+G9lN+MPwhGc6gcvHK9HXyo
mXHp5UOhr5uWVS1WkbgYX1PVXlaLg+qLjuGkdzHh4n/F/EzJboD3pqLOPV2ibCFa
KZW9tBAt8SwzkH5rwq3Vz8fERJ+6Q5kElxy1ZR5Gk0v3FC5jaeekSVGoobf+3j8G
Dlk1FHHnVOUnU0VJTE+ICgLRja22tLivCyn2UAiPYD6Jabolqg/Gpr9OvxrD7ZC9
WWzHi1AXfMzdhRoaQSk0cRFBPu3B4/FOLXfFUV2pG6zX6H43R7O3X29EI59EmLwb
OOACTEaP0wCUhizlQ/tMXvGlprHAtv4MeulGxPlcdqbwKD6kW2XKDr1LAYSz8XRU
GZDmxQGQqS1v0MJrG3cJqUu92ve2zazurDbHQ3fXNkVlBDzdXY6+ok7K01+rYKKB
3im7/TnRNJAiLjThpTwcrUvnsbUnZ/PMSoPkY2YmMbKzCGmODM6jUbCQBrG6Amhi
AKzeYxmFdv13p/g+g4AO
=cpQc
-----END PGP SIGNATURE-----

--Sig_/dk98fxO8OtbckH5zoCwzmEe--
