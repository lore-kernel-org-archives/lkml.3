Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3KZRRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:17:55 -0500
Received: from ring0.de ([91.143.88.219]:43758 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab3KZRRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:17:53 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 26 Nov 2013 18:17:49 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        freemangordon@abv.bg
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126171748.GA26429@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
	freemangordon@abv.bg
References: <201311191151.17153@pali>
 <201311261810.22885@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <201311261810.22885@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 06:10:22PM +0100, Pali Roh=E1r wrote:
> On Tuesday 19 November 2013 11:51:12 Pali Roh=E1r wrote:
> > For a long time (since 3.5 or 3.8? - I do not remember) obex
> > subdriver in g_nokia usb gadget module causing kernel panic
> > after module is loaded on Nokia N900. I do not know where is
> > problem and due to immediatelly kernel crash when loading
> > driver I was not able to see any dmesg output. Now I was able
> > to store something into mtd log and here is crash backtrace:
> > [...]
>=20
> Hi! can you look at this problem?

So it worked at some time?
Have you tried to git bisect the problem?

-- Sebastian

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSlNe8AAoJENju1/PIO/qa6RgP/0F0t/vdy0/F5xvskpmqqSYH
BL6xJACSzetLy1cthdaVMnxXunqdRD23a2V9ylqjnawrabge6S04+QQ77Fut3SW5
TsO54wAN6dtrCmM28prd0aJBqWIn6FxkfG5uwC/cUBoSg73PyGPlljmKZA6kcpxQ
MfCfbOQmEz2vvlpICvl5XZwy1mIPophD9ZCYNUMMbrmJhYLtjAmpTGP7CAQL0NLu
Bs8o0iw0D5i3EFxd2efRcYjTs7Bipx4SGyMUnLe4FXIw1E618j3dXP5+kamdPiKN
uCcRuuwHxprGLw0kXuXt76kTXIvwCLJ/vxHWl0Kl2tNNtveGpr7JoY6FnJ0iQqpR
5oC+0krT83S0PkA1hCec87JrrGnXev6zxXOp9iTmo1KMJnzGu2PVqCNdT4Mm9X5Z
3Azd63mbB7zjJitNsK9fju4mcznoq91yHp2xM+1t13s1GK6Kuz6a6qve7vgH6jRu
6VPvhcaAevHZmAy1Q2BRz5ZonrA6HhanzgNptAlEnQZ/6xHzT0Z7SwPjQ8POn+j9
hy2+hD8QlQ0Ruq4cUIbHrTuUZfpZwG2IfLJJ0ce+gZLUXrtA89l+S6u0Rsyni6iP
aOY+cLWBBfhJI6o/CejPHB/NFdGSikAsnlL5047HayxplBXoaIGE/EXxG2yJVJVO
Oy1un8QFND5H+SiEbZZC
=qGAV
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
