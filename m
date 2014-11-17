Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaKQPWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:22:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38794 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaKQPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:21:58 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Date: Mon, 17 Nov 2014 16:21:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20141116075928.GA9763@amd> <201411171601.32311@pali> <20141117150617.GD7046@atomide.com>
In-Reply-To: <20141117150617.GD7046@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart24421768.ZgrPxUV2KB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411171621.54895@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart24421768.ZgrPxUV2KB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 17 November 2014 16:06:17 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [141117 07:03]:
> > On Monday 17 November 2014 15:55:46 Tony Lindgren wrote:
> > > There's nothing stopping us from initializing the camera
> > > code from pdata-quirks.c for now to keep it working.
> > > Certainly the binding should be added to the driver, but
> > > that removes a dependency to the legacy booting mode if
> > > things are otherwise working.
> >=20
> > Tony, legacy board code for n900 is not in mainline tree.
> > And that omap3 camera subsystem for n900 is broken since
> > 3.5 kernel... (both Front and Back camera on n900 show only
> > green picture).
>=20
> I'm still seeing the legacy board code for n900 in mainline
> tree :) It's deprecated, but still there.
>=20

Yes, it is there because conversion from board code to DT is not=20
complete yet... It is slow progress but you can watch it on page=20
http://elinux.org/N900 (last two columns).

> Are you maybe talking about some other piece of platform_data
> that's no longer in the mainline kernel?
>=20

Yes, about platform_data which were never in mainline kernel.=20
Just only in other trees. That code is: camera subsystem (with=20
all other devices), cellular modem, bluetooth, radio.

> No idea what might be wrong with the camera though.
>=20
> Regards,
>=20
> Tony

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart24421768.ZgrPxUV2KB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRqEpIACgkQi/DJPQPkQ1KkLACfUNWGUzoX6EuoC8WlszGxWO+v
b+QAoIc1NDSPjO5s9uQL0EzC3uyP4Hcd
=0o81
-----END PGP SIGNATURE-----

--nextPart24421768.ZgrPxUV2KB--
