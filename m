Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981Ab3BJDBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 22:01:23 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:41845 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3BJDBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 22:01:22 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 10 Feb 2013 04:00:30 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v3 1/3] kconfig: nconf:  rewrite help texts
Message-ID: <20130210030030.GA20308@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net>
 <201302090130.07194.yann.morin.1998@free.fr>
 <20130209034609.GA8891@mobil.systemanalysen.net>
 <201302091223.36881.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <201302091223.36881.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-09 Saturday at 12:23 +0100 Yann E. MORIN wrote:
> Rolland, All,
>=20
> On Saturday 09 February 2013 Roland Eggner wrote:
> > On 2013-02-09 Saturday at 01:30 +0100 Yann E. MORIN wrote:
> [--SNIP--]
> > > > +"Text Box (Help Window)\n"
> > > > +"----------------------\n"
> > > > +"Use movement keys <Down> <Up> <PageDown> <PageUp> <End> <Home> as=
 listed in\n"
> > > > +"table above.\n"
> > >=20
> > > ... keys [elided] as listed ...
> >=20
> > Ok, because you are dropping patch 3/3.
>=20
> If that was related to patch 3/3, that should have been in that patch,
> not this one.

My =E2=80=9COk, because =E2=80=A6=E2=80=9D referred to your =E2=80=9Ckeys [=
elided] as listed =E2=80=A6=E2=80=9D in that=20
particular hunk, whereas my =E2=80=9CYou performed a nice polish =E2=80=A6=
=E2=80=9D several hunks later=20
referred to the whole patch.  Just to avoid misunderstanding.

>=20
> [--SNIP--]
> > > Any reason for the re-indent with one more space?
> >=20
> > Intention is optimization for fast reading, as usual in professional te=
xt=20
> > processing:  seperate words by single space;  separate sentences, half-=
sentences=20
> > and listing symbols by two spaces.
>=20
> OK, I kept it.

Thank you.
--=20
Regards
Roland Eggner

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEXDU4ACgkQdN/hKfT7G/JPXACcDPvQnO7eHUg8rBxewWidqslX
+tIAniiJjXQkdCmdYyHOaUst2W0o2h1E
=NQB0
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
