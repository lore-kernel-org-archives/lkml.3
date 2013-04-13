Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3DMBbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:31:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:65524 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DMBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:31:22 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Kyle Evans <kvans32@gmail.com>
Subject: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
Date: Sat, 13 Apr 2013 03:31:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-030900rc4-generic; KDE/4.10.2; x86_64; ; )
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4181137.1YX98hxonW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304130331.18301@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4181137.1YX98hxonW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

all Fn keys, wifi switch, web and mute buttons not working anymore=20
on my notebook HP EliteBook 8460p. I bisected git commit which=20
broke all above keys: fabf85e3ca15d5b94058f391dac8df870cdd427a

When I reverted that commit after reboot buttons started working=20
again. Can you fix it or revert that broken commit? This is=20
critical problem, which caused my notebook to be unusable...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4181137.1YX98hxonW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFotWYACgkQi/DJPQPkQ1KymQCgkwd4k/Sh0AITDgZnM7hVAW62
jFcAn0RhxaOLUKtWOJ56bTsP3XOcIulK
=w7se
-----END PGP SIGNATURE-----

--nextPart4181137.1YX98hxonW--
