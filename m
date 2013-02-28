Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab3B1Vfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:35:53 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:44154 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab3B1Vfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:35:52 -0500
Message-ID: <512FCDBF.5050508@gentoo.org>
Date: Thu, 28 Feb 2013 22:35:59 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] menuconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org> <1362052335-17913-1-git-send-email-jlec@gentoo.org> <201302281916.00257.yann.morin.1998@free.fr>
In-Reply-To: <201302281916.00257.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2QVTTFDVTKFFOFVASVBGX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QVTTFDVTKFFOFVASVBGX
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2/28/13 7:16 PM, Yann E. MORIN wrote:
> And, sorry, I should have been more explicit in my previous mail that
> the legacy drop should be in its own patch. I thought that was obvious,=

> following the "one single change per patch" philosophy.
>=20

Hi,

no worries. I will submit as you suggested. It's a learning experience
for me and we will get this solved.

The new patches will come tomorrow.

Thanks,
Justin


------enig2QVTTFDVTKFFOFVASVBGX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEvzb8ACgkQgAnW8HDreRY2eACeIFtyB/a2TPNuWqkvwWkuBKTT
JU4AoLloOJzQoNoSuHupkqsetj9y6RBw
=HQ4C
-----END PGP SIGNATURE-----

------enig2QVTTFDVTKFFOFVASVBGX--
