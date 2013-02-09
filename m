Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989Ab3BIFIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 00:08:40 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:43446 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3BIFIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 00:08:38 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sat, 9 Feb 2013 06:07:48 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v3 3/3] kconfig: nconf:  add vi-style navigation
 keys
Message-ID: <20130209050748.GB8891@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net>
 <20130201183357.GD11098@mobil.systemanalysen.net>
 <201302090203.04055.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <201302090203.04055.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-09 Saturday at 02:03 +0100 Yann E. MORIN wrote:
> On Friday 01 February 2013 Roland Eggner wrote:
> > Add vi-style navigation keys, based on initial work by Dmitry Voytik.
>=20
> As much I am a unconditional vim user, I doubt this is a sane idea to
> include this, as it conflicts with the established UI that people expect,
> especially since <h> is remapped and people already rely on <h> to provide
> help, not do any other weird thing (like exiting the current submenu).

Having the most frequently used keys in the middle of the keyboard is=20
a professional computer usage pattern, not an anachronistic one.

Regarding the <h>/<H> conflict:  My vision is to eliminate the need for hel=
p=20
keybindings <h> <?> at all by displaying the related help text beside the m=
enu=20
permanently, similar to some graphical backends.  For terminals with=20
COLUMNS>=3D160 this should be rather easy to implement.  nouveaufb gives me=
 by=20
default terminal with 274 columns, =E2=80=9Cretina=E2=80=9D displays are en=
tering the market=20
=E2=80=A6 the frequency of COLUMNS>=3D160 terminals probably will continue =
to grow.  While=20
staying compatible with COLUMNS=3D80, it seems reasonable to use the capabi=
lities=20
of wider terminals, or what would you say?

Cannot promise when I will find the time to prepare a patch.

--=20
Regards
Roland Eggner

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEV2aQACgkQdN/hKfT7G/Li8wCghN4v8W1fFkkA6heKgTxh0KsG
K/8AoK2Vi8LJWQ04tnXVjMNBXH5eTkuB
=1bVV
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
