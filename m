Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab3BIDrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 22:47:05 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:39584 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3BIDrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 22:47:02 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sat, 9 Feb 2013 04:46:09 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v3 1/3] kconfig: nconf:  rewrite help texts
Message-ID: <20130209034609.GA8891@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net>
 <20130201182704.GB11098@mobil.systemanalysen.net>
 <201302090130.07194.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <201302090130.07194.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-09 Saturday at 01:30 +0100 Yann E. MORIN wrote:
> Roland, All,
>=20
> I've taken that in my branch now.
> I will push later with a few fixes (see below).
>=20
> On Friday 01 February 2013 Roland Eggner wrote:
> [--SNIP--]
> > diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> > --- a/scripts/kconfig/nconf.c
> > +++ b/scripts/kconfig/nconf.c
> [--SNIP--]
> > +"o  Global help:  Unless in a data entry window, key <F1> will give yo=
u\n"
>=20
> ... pressing <F1> ...
>=20
> > +"o  A short version of the global help is available by key <F3>.\n"
>=20
> ... by pressing <F3>
>=20
> > +"o  Local help:  To get help related to the current menu entry, use an=
y\n"
> > +"   of <?> <h> keys, or if in a data entry window then use <F1> key.\n"
>=20
> s/ keys//;  s/use <F1> key/press <F1>/;
>=20
> > +"<n> to remove it.  You may press the <Space> key to cycle through the=
\n"
>=20
> ... press <Space> to cycle ...
>=20
> > +"Unless in a data entry window, key <1> may be used instead of <F1>,\n"
>=20
> s/key //;
>=20
> > +"Enter the requested information and press <Enter>.  Hexadecimal value=
s\n"
> > +"may be entered without \"0x\" prefix.\n"
>=20
> ... without the \"0x\" prefix ...
>=20
> > +"Text Box (Help Window)\n"
> > +"----------------------\n"
> > +"Use movement keys <Down> <Up> <PageDown> <PageUp> <End> <Home> as lis=
ted in\n"
> > +"table above.\n"
>=20
> ... keys [elided] as listed ...

Ok, because you are dropping patch 3/3.

> > +"Alternate configuration files\n"
> > +"-----------------------------\n"
> > +"nconfig supports switching between different configurations.\n"
> > +"Use <F6> to save your current configuration.  Use <F7> and enter a\n"
>=20
> Press <F6> ...
> Press <F7> ...
>=20
> >  menu_no_f_instructions[] =3D N_(
> [--SNIP--]
> > +"Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\=
n"
> > +"Submenus are designated by a trailing \"--->\".\n"
> > +"\n"
> > +"Use the following keys to navigate the menus:\n"
> > +"Move up or down by any of <Up> <Down> keys.\n"
>=20
> ... with <Up> or <Down>.
>=20
> > +"To enter a submenu use any of <Enter> <Right> keys.\n"
> > +"To go back to the parent menu use any of <Esc> <Left> keys.\n"
>=20
> Enter a submenu with <Enter> or <Right>.
> Exit a submenu to its parent menu with <Esc> or <Left>.
>=20
> > +"Pressing <y> includes, <n> excludes, <m> modularizes features.\n"
> > +"Pressing <Space> cycles through the available options.\n"
> > +"To search for menu entries use key </>.\n"
>=20
> ... press </>.
>=20
> > +"<Esc> always leaves the current window.\n"
> > +"\n"
> > +"You do not have function keys support.\n"
> > +"Use key <1> instead of <F1>, <2> instead of <F2>, etc.\n"
> > +"For verbose global help use key <1>.\n"
>=20
> ... press <1>.
>=20
> > +"For help related to the current menu entry use any of <?> <h> keys.\n=
"),
>=20
> ... press <?> or <h>.
>=20
> And so on in the following...

You performed a nice =E2=80=9Cpolish=E2=80=9C =E2=80=A6 thank you!

> =E2=80=A6 =E2=80=A6
> > @@ -229,26 +222,26 @@ search_help[] =3D N_(
> >  "Selects: LIBCRC32\n"
> >  "Selected by: BAR\n"
> >  "-----------------------------------------------------------------\n"
> > -"o The line 'Prompt:' shows the text used in the menu structure for\n"
> > -"  this symbol\n"
> > -"o The 'Defined at' line tell at what file / line number the symbol\n"
> > -"  is defined\n"
> > -"o The 'Depends on:' line tell what symbols needs to be defined for\n"
> > -"  this symbol to be visible in the menu (selectable)\n"
> > -"o The 'Location:' lines tell where in the menu structure this symbol\=
n"
> > -"  is located\n"
> > -"    A location followed by a [ =3D y] indicate that this is a selecta=
ble\n"
> > -"    menu item - and current value is displayed inside brackets.\n"
> > -"o The 'Selects:' line tell what symbol will be automatically\n"
> > -"  selected if this symbol is selected (y or m)\n"
> > -"o The 'Selected by' line tell what symbol has selected this symbol\n"
> > +"o  The line 'Prompt:' shows the menu text displayed for this symbol i=
n\n"
>=20
> ... shows the [elided] text ...
>=20
> Any reason for the re-indent with one more space?

Intention is optimization for fast reading, as usual in professional text=
=20
processing:  seperate words by single space;  separate sentences, half-sent=
ences=20
and listing symbols by two spaces.

> > +"   the menu hierarchy.\n"
> > +"o  The 'Defined at' line tells at what file / line number the symbol =
is\n"
>=20
> ... file & line ...
>=20
> > +"o  The 'Depends on:' line tells, what symbols need to be defined for\=
n"
>=20
> ... line lists symbols that need ...
>=20
> I will push soon to my branch.

Thank you!

--=20
Regards
Roland Eggner

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVxoEACgkQdN/hKfT7G/IxnACfZNlhOGY78EccSvKZul5yXq1R
PigAn2g1KgQTD1eZYJKH04ugswmPJ3Cl
=e6gQ
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
