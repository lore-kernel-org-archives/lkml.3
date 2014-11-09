Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKIMtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:49:25 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49655 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaKIMtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:49:23 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Subject: Re: tsc2005 touchscreen: implement disable attribute
Date: Sun, 9 Nov 2014 13:49:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, B38611@freescale.com,
        jg1.han@samsung.com, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20141109115636.GA3106@amd> <20141109124025.GA21763@earth.universe>
In-Reply-To: <20141109124025.GA21763@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2482422.I2mjBvijPq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411091349.20116@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2482422.I2mjBvijPq
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 November 2014 13:40:25 Sebastian Reichel wrote:
> Hi,
>=20
> On Sun, Nov 09, 2014 at 12:56:37PM +0100, Pavel Machek wrote:
> > Implement disable attribute for tsc2005 touchscreen. It is
> > useful to avoid wakeups when phone is in the pocket.
>=20
> I don't think this should be some driver specific sysfs node.
> Instead a generic method from the input subsystem should be
> used.
>=20
> -- Sebastian

Yes. I would like to see generic method to turn off input device=20
(or just "mute" it if device does not support turn off). Similar=20
problem is also on laptops or other portable devices. E.g when I=20
close LID of my laptop I want to turn off internal input devices=20
(keyboard, touchpad, trackstick) without need to unload evdev=20
Xserver drivers (or killing Xserver). Another use case is to turn=20
off keyboard (also from kernel tty on Ctrl+Alt+Fx) which cannot=20
be unplugged (internal laptop keyboard).

CCed Dmitry, what do you think about it?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2482422.I2mjBvijPq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRfYtAACgkQi/DJPQPkQ1LjewCeOq2LU1yi0D/nD6dpW8n3q9KT
/vkAoIGQM3wGrLcg8IhxSB7jHakFABV6
=Jd1K
-----END PGP SIGNATURE-----

--nextPart2482422.I2mjBvijPq--
