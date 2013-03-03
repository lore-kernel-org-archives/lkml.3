Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3CCVU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:20:56 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47402 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab3CCVUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:20:55 -0500
Message-ID: <5133BEAC.8040304@gentoo.org>
Date: Sun, 03 Mar 2013 22:20:44 +0100
From: Justin <jlec@gentoo.org>
Reply-To: jlec@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130222 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] menuconfig: use config scripts to detect ncurses
 libs
References: <jlec@gentoo.org> <1362153044-23611-1-git-send-email-jlec@gentoo.org> <1362153044-23611-2-git-send-email-jlec@gentoo.org> <201303032136.27096.yann.morin.1998@free.fr>
In-Reply-To: <201303032136.27096.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2MFHWHRCLALJBAAOMOWBU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2MFHWHRCLALJBAAOMOWBU
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 03.03.2013 21:36, Yann E. MORIN wrote:
Hello,
>=20
> In the light of the different mails on the subject, it appears that the=

> ncurses*-config script are unreliable: at least one major distribution
> (Debian) is broken and, for various reasons, is not gonna fix it, and
> all its derivatives (eg. Ubuntu) do suffer from the same deficiency.

Indeed the config scripts come without the necessary build time deps.
But it ends in the same situation as current version of the Makefile.
The user will be asked to install the devel package.
So I don't see any problem here.

>=20
> I think we should stick to:
>   - try with pkg-config;
>   - fallback to the legacy heuristic.
>=20
> Does using pkg-config fix your use-case?

It does, nevertheless I would prefer to include the ncurses*-config
script as well to cover most situation we will find on users system.

Justin


------enig2MFHWHRCLALJBAAOMOWBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEzvqwACgkQgAnW8HDreRbShACfSxuPyszwKrOd4neMqQJ9KR28
pogAn0Wsk8HNJ2bObBgTr0/yvGsMwXtQ
=djrA
-----END PGP SIGNATURE-----

------enig2MFHWHRCLALJBAAOMOWBU--
