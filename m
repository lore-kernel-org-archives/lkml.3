Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3CANrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:47:53 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:59669 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CANrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:47:51 -0500
Message-ID: <5130B183.9080901@gentoo.org>
Date: Fri, 01 Mar 2013 14:47:47 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130224 Thunderbird/17.0.3
MIME-Version: 1.0
To: Sven Joachim <svenjoac@gmx.de>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org> <1362045557-9123-1-git-send-email-jlec@gentoo.org> <874ngwhzuy.fsf@turtle.gmx.de> <51305AC4.2030008@gentoo.org> <87obf35xei.fsf@turtle.gmx.de>
In-Reply-To: <87obf35xei.fsf@turtle.gmx.de>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2UEIMGWPEKLOOWIQRROKC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UEIMGWPEKLOOWIQRROKC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/03/13 09:36, Sven Joachim wrote:
> Historically it seems to be an accident, and the ncurses{w,5}-config
> scripts should have better been shipped in their development packages.
> But nowadays we want to make the development packages multiarch-aware,
> and since the scripts differ on architectures, moving them away from
> ncurses-bin would mean adding two additional binary packages just for
> these scripts.
>=20
> See http://bugs.debian.org/480437 for a discussion on that topic.
>=20

I just tested on an ubuntu installation what happens with the patches
applied; you simply end up with the warning the you need to install the
dev package. So I don't see any problem here.

> Well, at least until nconf does not make any effort to explicitly detec=
t
> and use the wide API, trying ncurses5-config first should work.  If you=

> build ncurses yourself with --enable-widec, there is no -lmenu or -lpan=
el
> anyway, these libraries are called menuw and panelw then.

You are right, we only should consider ncurses5-config right now.

Regards,
Justin


------enig2UEIMGWPEKLOOWIQRROKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEwsYMACgkQgAnW8HDreRZuVwCdGcFzxhBIz/0y9bCx6/lYAgQJ
fhoAn0acvIiZBV6RKoLTe0BeFu89pcf/
=c8jG
-----END PGP SIGNATURE-----

------enig2UEIMGWPEKLOOWIQRROKC--
