Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3IRBqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:46:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45446 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3IRBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:46:40 -0400
Date: Tue, 17 Sep 2013 20:45:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, kernel list <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130918014539.GB19817@radagast>
Reply-To: <balbi@ti.com>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130917154229.GI15645@radagast>
 <20130917220427.GC23937@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20130917220427.GC23937@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 12:04:27AM +0200, Pavel Machek wrote:
> On Tue 2013-09-17 10:42:30, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Sep 02, 2013 at 03:58:32PM +0200, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
> > > macro with if should be really enclosed in do {} while, and puts is
> > > going to be slightly faster.
> > >=20
> > > Here's suggested patch. I don't have the hardware, so it is completely
> > > untested.
> > >=20
> > > Signed-off-by: Pavel Machek, <pavel@denx.de>
> >=20
> > this is not how you send a patch, please read
> > Documentation/SubmittingPatches
>=20
> Have you considered possibility that this is how you nudge maintainer
> into fix their coding style?

cute...

Seriously though, read that file, you're commit log has garbage in it
which shouldn't go to git history.

--=20
balbi

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOQXDAAoJEIaOsuA1yqREgIYP/27valEJN2h28G3jQbH6+5oT
vW4AypjRuVMqtaMBGO1XsOn5dBMEwwEN2urz8HQLMj/QDDULnqwX4fgMREq+IxVT
9KhqrrvaybD7Ejf5tCGMFNd1coYDOTslOctKqlwJMBbrZ0LhwtKFaOLLQdJ1s5vE
ndSDqhFmZL3lr19LTpUz25XRy62viuY1BT2ASw2FdZumeOcptyjJiiAU1C40B14k
ogHN2ORdQpNZqIX8Rn46kBKwAwEN3+nhYB/qmkaKBS9q7lRxSlU3dJ2ke1ZK6Jox
FHm5gGqUMCfrN+s+bMFgWnh+CVmPK4zAR7ETLppATnmEoFdPMggLNXiCpk3CpIG8
quGFgj8FowkjOOo1WzStc2OYWhZrBDkpizqrcRzB/t89U/YRile7NyBTvf3SRj4i
UMfwrfsapXzVYzTTd9XMBO1JR0UNMos/KiEbI2lSeYJFElUiPaKDaSlZEeCmcFIh
8T88RAMNaoh3Wrvezn4lKSFic+oMcYgrQxPQuaPNELu5T/+yJcpFUd9ehW0Vm5ZL
1mQtvaMQfQAOC8tOM6Cm3slEFQYyVhaX5RKspwpZVO797bJ0QZ82xKgUzfBAASoz
jrbMgcEWlKn5r/mr8Qho8aXxBE0/UWWWzIHjMjgQsGTIsDTNRObD68AxvfL67bj6
0l5OH8mV7x6ioZAEX6Eu
=BD3u
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
