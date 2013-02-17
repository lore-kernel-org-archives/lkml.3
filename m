Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3BQTUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:20:39 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:37085 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab3BQTUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:20:35 -0500
Message-ID: <1361128775.20542.6.camel@scapa>
Subject: Re: [PATCH 00/15] Secure boot policy support
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Sun, 17 Feb 2013 20:19:35 +0100
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-B0wckL0qdO0tV3XIZVXr"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B0wckL0qdO0tV3XIZVXr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun., 2013-01-28 at 11:42 -0500, Matthew Garrett wrote:
> Secure boot makes it possible to ensure that the on-disk representation o=
f
> the kernel hasn't been modified. This can be sidestepped if the in-memory
> representation can be trivially altered. We currently have a large number
> of interfaces that permit root to perform effectively arbitrary
> modifications to the kernel, so this patchset introduces a new capability
> ("CAP_COMPROMISE_KERNEL") that controls whether or not these features are
> available. The aim is for this to be useful in any other situations where
> kernel integrity can be assured by some other mechanism rather than speci=
al
> casing UEFI.
>=20
Wouldn't it make sense to prevent writing to MSRs too? Something like
c903f0456bc69176912dee6dd25c6a66ee1aed00 with CAP_COMPROMISE_KERNEL?

Regards,
--=20
Yves-Alexis

--=-B0wckL0qdO0tV3XIZVXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABCAAGBQJRIS1HAAoJEG3bU/KmdcCl53YH/3VkZsNDo6we+2sGDRLsgJsG
PuoxwbXIAcs7d0nH1exVo2E/WT9lHLgQdtYOEv6Who4tT6D9IG+y8kcOADb4eCWP
0yVv7f9t7d90QJhyU/A0ThJlPN6av+942GW9biW7TaQFEle5ADaUkiL0WsGFCdzP
wka0LGMYQLCkF336ftdQ+BR9Ye49MUsAUBECFEBCmRlX/Lzzryl9Ly0wZENbHqC6
C+rM0FMTVa7E6DKB5DGz41Gsm1uI3tZnz8PWblChatv+rFf3F0KTjs/gacsJrGlJ
Iszs4Gjfmrp3OTnLu5JkAKJmUgoTdj9mc+0qZ6wMKOnFh7Tb1aVwyEfRj5xDH5w=
=LCji
-----END PGP SIGNATURE-----

--=-B0wckL0qdO0tV3XIZVXr--
