Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaKJJOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:14:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48413 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaKJJO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:14:29 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: tsc2005 touchscreen: implement disable attribute
Date: Mon, 10 Nov 2014 10:14:23 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, B38611@freescale.com,
        jg1.han@samsung.com, linux-input@vger.kernel.org
References: <20141109115636.GA3106@amd> <201411091349.20116@pali> <20141109200142.GA37384@dtor-ws>
In-Reply-To: <20141109200142.GA37384@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1663519.rvD1VYdpLO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411101014.25873@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1663519.rvD1VYdpLO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 November 2014 21:01:42 Dmitry Torokhov wrote:
> On Sun, Nov 09, 2014 at 01:49:19PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 09 November 2014 13:40:25 Sebastian Reichel wrote:
> > > Hi,
> > >=20
> > > On Sun, Nov 09, 2014 at 12:56:37PM +0100, Pavel Machek=20
wrote:
> > > > Implement disable attribute for tsc2005 touchscreen. It
> > > > is useful to avoid wakeups when phone is in the pocket.
> > >=20
> > > I don't think this should be some driver specific sysfs
> > > node. Instead a generic method from the input subsystem
> > > should be used.
> > >=20
> > > -- Sebastian
> >=20
> > Yes. I would like to see generic method to turn off input
> > device (or just "mute" it if device does not support turn
> > off). Similar problem is also on laptops or other portable
> > devices. E.g when I close LID of my laptop I want to turn
> > off internal input devices (keyboard, touchpad, trackstick)
> > without need to unload evdev Xserver drivers (or killing
> > Xserver). Another use case is to turn off keyboard (also
> > from kernel tty on Ctrl+Alt+Fx) which cannot be unplugged
> > (internal laptop keyboard).
> >=20
> > CCed Dmitry, what do you think about it?
>=20
> Actually I'd like it to be not limited to input devices but
> rater try doing it at the device core level, if possible. I
> am sure there are IIO and other devices that could be
> forcibly turned off/put into low power mode under certain
> circumstances.
>=20
> There were some talks about it with Rafael, but we never come
> with anything concrete.
>=20
> Thanks.

Ok. What about adding sysfs node disable which accept value 0/1?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1663519.rvD1VYdpLO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRggfEACgkQi/DJPQPkQ1K3agCfT1f1nSiPxa73eg49EoG14Cu+
2ZwAn1/esZxH/KjcvUbR1CpQ3DcytWdu
=nt1i
-----END PGP SIGNATURE-----

--nextPart1663519.rvD1VYdpLO--
