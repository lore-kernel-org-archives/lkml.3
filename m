Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJSPZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:25:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57067 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaJSPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:25:13 -0400
Date: Sun, 19 Oct 2014 10:24:14 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: <pali.rohar@gmail.com>, <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141019152414.GB5189@saruman>
Reply-To: <balbi@ti.com>
References: <20141019090107.GA19132@amd>
 <20141019100739.GA2547@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20141019100739.GA2547@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 19, 2014 at 12:07:39PM +0200, Pavel Machek wrote:
> On Sun 2014-10-19 11:01:07, Pavel Machek wrote:
> > Hi!
> >=20
> > From 3.6 to 3.10, USB networking works on Nokia N900. With 3.11, it
> > fails with messages on the host. I also tried to get it to work on
> > 3.14 and 3.17, with no luck.
> >=20
> > Any ideas? Does it work for you? Any config options to watch for?
>=20
> With 3.17, I get
>=20
> omap_musb_mailbox: musb core is not yet ready
>=20
> message. It looks related...?

is musbmhdrc.ko loaded ? Do you have a gadget driver loaded ?

+ Aaro

--=20
balbi

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQ9edAAoJEIaOsuA1yqREI6kP/06GBgb3/0MUxfCFxcoaPEVP
JHkAtUhbayh5oilurv+16VD9TnKxIeTCsAW/bRUUNgVJW7qSMLbgX5H3rinymP3j
04ig08cML7yDns2RH8ChtwsyVFvLGmXgI+pYerTigZ5qmunYdvkz6Q1Hxc2vqaN7
XMgLtDHrnUWj8RsJZYrI3q7GFedViQbJF2DR96ItUL67mLQWKykrr87Vt8bZxMem
SUFESYkb01dcze/npgtFfqWeMbmx0cmkGMdWAIHbrQnsHx9G9WYV4pWxsKqo09Hl
PUAZm9mcKy+t9norUG1k4rK0HEhytMyX+Oc06P8CXHXerTm+lvwU765WHtsooKs5
cQBH4Mayq64d4me3gZWBW4BoLKY+itptwARgAUoTWadHZEH4f0v62PpSweGtbSkN
r97r+9vxDvM6TBwdnBC5/n1dREHkfS0gh5Hk+lwlzMj2SwL43kICsJ0rxddXlZyR
TErFC8AW7Acmj90/YnvJ0MBIqX8orAiniaGZJrWLdG0Ve/FzwfP6L4hqIPKkpd4C
xB0b1NBc+qfrdEmuYTqR6sZOQeHtdu1+jFEgG4ilglVB/otp1/CkzPHxnZMrYZYG
tl6z/kIqpOgzXWdyjc1yoGzOJnL+V1EBoy52tMeWTc1h4ZcutVNjjzcqQbj48omt
352a7PsS3+8NjIiknYWn
=JRre
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
