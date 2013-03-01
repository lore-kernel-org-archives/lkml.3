Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3CAHs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:48:26 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:58909 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3CAHsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:48:25 -0500
Message-ID: <51305D44.3080601@gentoo.org>
Date: Fri, 01 Mar 2013 08:48:20 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org> <1362045557-9123-1-git-send-email-jlec@gentoo.org> <201302282159.20338.yann.morin.1998@free.fr>
In-Reply-To: <201302282159.20338.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2QAGWVMQMXVLBDKLVHCQR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QAGWVMQMXVLBDKLVHCQR
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 28/02/13 21:59, Yann E. MORIN wrote:
> I've queued that one in my tree, now, in branch yem-kconfig-for-next:
>     https://www.gitorious.org/linux-kconfig/linux-kconfig
>=20


Thanks for queuing, but with the points which Sven mentioned we should
first agree on a way to detect things.

The simplest option which might only be present at very recent distro
versions is using pkg-config.
Second best is ncurses*5-config. There we have the strange situation
that "ncurses-bin" contains the config scripts although no build time
dependencies are installed along.
Third, we might only find either of nurses{,w}5-config.
And at last we might face the situation where the new ABI is used and
the script is named ncurses{,w}6-config.

Ugly but working would be a simple "||" chain. This would create
problems on debian/ubuntu which needs to be solved.

Any other suggestions how we can solve the problem?


Thanks
justin


------enig2QAGWVMQMXVLBDKLVHCQR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEwXUQACgkQgAnW8HDreRYZKQCfcA/llnOqq3tVV5Ld3F7P/XzA
cJEAoJirfp8/RGcu5NFToPHTg6R2gbrc
=Hjot
-----END PGP SIGNATURE-----

------enig2QAGWVMQMXVLBDKLVHCQR--
