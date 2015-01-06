Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbbAFXFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:05:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45442 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbbAFXFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:05:44 -0500
Date: Tue, 6 Jan 2015 17:04:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <pali.rohar@gmail.com>, <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106230415.GC13752@saruman>
Reply-To: <balbi@ti.com>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106220805.GD13902@amd>
 <20150106222717.GC6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106224622.GA13752@saruman>
 <20150106225614.GA31990@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20150106225614.GA31990@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 06, 2015 at 11:56:14PM +0100, Pavel Machek wrote:
> > > But I'm mounting it from userspace (using builtin initramfs inside
> > > zImage), with a poll loop that waits for a device to appear. Maybe if=
 you
> > > do it from kernel you need to use root wait/delay etc. options?
> >=20
> > yeah, rootwait should do it.
>=20
> No, rootwait does not solve it. Try it. Tested many times. (And yes,
> you need to actually fool the rear cover sensor or close the phone.)

yeah, just put a magnet or, if you have spare back covers, cut one so
that you "close" it, but still allow you to put the thing on a
development jig.

Also, if why doesn't rootwait work ? You never have a new mmc node or is
the mmc node changing names ?

--=20
balbi

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrGnvAAoJEIaOsuA1yqREA0cQAKUohXUU8k7HWFmYW2Tw+rCP
YarhoiBNwyXGiL6mQKUEkz7dNz/8/Qxfx2ElQx/nsxikBybCT1czUIDM7ZTmHZci
FjekuqR8WJOWpZfUkuvhRGE/WUJZsLa6jM+Q3TbTchS3tpQkKnarHoMFCMMUMAWi
QbU9vZE8a3fOMkqUADPKoBLp3af+Pr01z3FJgEvkXw25BFn8Rhwx0aSkFZqfxCQo
U0NG/VSORCG0soW3PoyRw0xbxNNOvodNf6NZZEabagp4/+KkSpZNBj+2EAqmyPqK
KKFazOwIrigk4lC9Cb3YwKzzrth4ASj7cYEk6ZJwNLcTPqp27scJT8i2Leqk2qh5
bVMhL+8tHDjaDDL5zRHOfL/oQHywcyWqd300k0EyiVO9Sa5p0TVLVJs4dXNGULul
ahBg+r7MttztkMGTJxTlyMFU2uEwO7CS+vSbyuG2srsD3vF4ytg2VIymPPjryXJg
ciuUs5z5n55VHyj1fs0ME0QWo0oMgFP5LNzR6R3uPrc2KIXjaMpXN943m7GaVypS
j5XCCNaOoHGMDGc8GKOPBeSt61LT4h2CpmT0NGsvfaLxegeSTMFQXKvPbl6vHKu2
LdvkNhGDgRiH0w60ENrc8mwuhUniZ2cNicpYJLTt9wU+NOlJg7Vkbc+lYTtY9WaC
/+1vLFaEBVf9SuFjjibE
=hwt3
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
