Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3AORNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:13:47 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:60617 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3AORNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:13:45 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Tue, 15 Jan 2013 18:12:52 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nconf: add vi-style command keys for the menu navigation
Message-ID: <20130115171252.GD5513@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp>
 <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
 <201301142310.32044.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <201301142310.32044.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-01-14 Monday at 23:10 +0100 Yann E. MORIN wrote:
> Dmitry, All,
>=20
> On Friday 28 December 2012 Dmitry Voytik wrote:
> > Add alternative vi-style keys for the menu navigation:
> > <j>/<k> for down/up navigation, <C-f>/<C-b> for
> > page down/up, <g>/<G> for first/last menu item selection
> > and <l> for entering to a submenu.
>=20
> The <g>/<G> keys are not documented in the help text.
> <HOME>/<END> are not, either.

Already documented in previous version and in v2 posted half hour ago:

User interface:
<F1> =E2=80=9CGlobal help=E2=80=9C, table starting near line 36.

Source code:
grep -E -n '(First|Last) entry' scripts/kconfig/nconf.c


> Care to add those and resend, please?

v2 based on 3.8-rc3 posted.


Thanks for review.
--=20
Roland Eggner


--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlD1jhQACgkQdN/hKfT7G/Jw0ACfXqGGhSdVpAIOuHIISIkhNt5O
FEUAoKkDUVc4Rex1J991g5qHOtItAgR4
=UhxT
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
