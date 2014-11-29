Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaK2RYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:24:09 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33202 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaK2RYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:24:07 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Disable input device
Date: Sat, 29 Nov 2014 18:24:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1825506.TjKFcrOAEc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411291824.03996@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1825506.TjKFcrOAEc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

there is request to introduce some option (via sysfs) to disable=20
one input device. Originally it was for tsc2005 touchscreen found=20
on Nokia N900 cellphone. Use case is to completely disable=20
touchscreen when phone is in pocket or when screen is locked via=20
slide switch (to prevent random clicks).

But it would be better to have disable option for all input=20
devices. Sometimes input device is not use and only consume=20
power. Another case is when input device (e.g. keyboard or=20
touchpad) is integrated into machine (e.g. on laptops) and user=20
does not want to use it (so make sure that kernel does not send=20
events to userspace).

I would like to ask, how to solve it?

What do you think about adding new sysfs file "disable" (accept=20
values 1 or 0) for every input device? With "1" it cause that=20
kernel will drop all events from specific input device and if=20
driver provide some function is can be called (e.g. for power=20
management or disabling device at hardware level).

Or do you prefer something other?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1825506.TjKFcrOAEc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR6ATMACgkQi/DJPQPkQ1L1CwCgp15pe3+zYUHCR1FvXORiiVmk
cYUAoM19UHq7/gOcyRFeHTw1dizzs17Z
=+HQj
-----END PGP SIGNATURE-----

--nextPart1825506.TjKFcrOAEc--
