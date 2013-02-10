Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065Ab3BJEKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 23:10:01 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:45759 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761045Ab3BJEJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 23:09:59 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 10 Feb 2013 05:09:07 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v3 3/3] kconfig: nconf:  add vi-style navigation
 keys
Message-ID: <20130210040907.GB20308@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net>
 <201302090203.04055.yann.morin.1998@free.fr>
 <20130209050748.GB8891@mobil.systemanalysen.net>
 <201302091236.23641.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <201302091236.23641.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-09 Saturday at 12:36 +0100 Yann E. MORIN wrote:
> Rolland, All,
>=20
> On Saturday 09 February 2013 Roland Eggner wrote:
> > Regarding the <h>/<H> conflict:  My vision is to eliminate the need for=
 help=20
> > keybindings <h> <?> at all by displaying the related help text beside t=
he=20
> > menu permanently, similar to some graphical backends.  For terminals wi=
th=20
> > COLUMNS>=3D160 this should be rather easy to implement.  nouveaufb give=
s me by=20
> > default terminal with 274 columns, =E2=80=9Cretina=E2=80=9D displays ar=
e entering the market=20
> > =E2=80=A6 the frequency of COLUMNS>=3D160 terminals probably will conti=
nue to grow. =20
> > While staying compatible with COLUMNS=3D80, it seems reasonable to use =
the=20
> > capabilities of wider terminals, or what would you say?
>=20
> How do you navigate up/down in the help text (when the terminal is not
> high enought to display the entire help) if it is displayed at the same
> time the menu entries are, yet without breaking the UI behavior people
> expect?

Good question.  My vision is a UI similar to mc with directory listing in o=
ne=20
panel, file content in the other panel, =E2=80=9Cquick view=E2=80=9D and =
=E2=80=9Clynx-like navigation=E2=80=9D=20
switched on.  Help keybindings <h> <?> will become superfluous, and keybind=
ings=20
<Tab> <Ctrl-i> to switch focus between menu and help =E2=80=9Cpanel=E2=80=
=9D will be added. =20
Implementation will require some ncurses exercise and more time, than I hav=
e=20
available in near future.  Thus I keep saying =E2=80=9Cno promise =E2=80=A6=
=E2=80=9D

--=20
Regards
Roland Eggner

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEXHWMACgkQdN/hKfT7G/KfcgCeM7kYqOECxZa3T+8BceGrDVIA
Oy4An1hYI2glCxwzZjjqjvXIRXLxxv80
=iiPJ
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
