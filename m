Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaLXUGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 15:06:16 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64504 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaLXUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 15:06:14 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Darren Hart <dvhart@infradead.org>, linux-leds@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: LED: inform userspace about brightness change
Date: Wed, 24 Dec 2014 21:06:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3483831.VSxtC1L7b9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412242106.09959@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3483831.VSxtC1L7b9
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

What is preferred way from kernel driver to inform userspace=20
about LED device brightness change? In /sys/class/leds/<device>/=20
is file brightness which can be used to read current brightness=20
or set write new value. But sometimes also firmware (or device)=20
can change value on its own and thus userspace software which=20
provides slider for setting brightness will be incorrect.

=46or example on Dell laptops there is driver which support setting=20
and reading keyboard backlight (via leds kernel interface). But=20
firmware/BIOS can change brightness (when something happen) and=20
it can inform running system about this change via ACPI/WMI event=20
interface. But how to use kernel led interface to inform userpace=20
about this change? It is possible?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3483831.VSxtC1L7b9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSbHLEACgkQi/DJPQPkQ1I1KwCgox/WYS4Cp0BuOqyXnZRHUUux
8yIAnjVdqZplFgg/LB9PSIhimxCTWaK+
=cQSp
-----END PGP SIGNATURE-----

--nextPart3483831.VSxtC1L7b9--
