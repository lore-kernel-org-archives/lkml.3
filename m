Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab3HNIUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:20:04 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63608 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab3HNIT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:19:58 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Kyle Evans <kvans32@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: BUG: Again: Fn keys not working on EliteBook 8460p after b253c9d1d858a3f115f791ee4fe2b9399ae7dbbd
Date: Wed, 14 Aug 2013 10:19:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-rc5+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <201304130331.18301@pali>
In-Reply-To: <201304130331.18301@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18357273.Elkb8AqA6n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308141019.53740@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18357273.Elkb8AqA6n
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 13 April 2013 03:31:17 Pali Roh=C3=A1r wrote:
> Hello,
>=20
> all Fn keys, wifi switch, web and mute buttons not working
> anymore on my notebook HP EliteBook 8460p. I bisected git
> commit which broke all above keys:
> fabf85e3ca15d5b94058f391dac8df870cdd427a
>=20
> When I reverted that commit after reboot buttons started
> working again. Can you fix it or revert that broken commit?
> This is critical problem, which caused my notebook to be
> unusable...

Hello, same problem happen again on my notebook. Problematic=20
commit is now: b253c9d1d858a3f115f791ee4fe2b9399ae7dbbd
hp-wmi: Enable hotkeys on some systems

When I disabled calling function hp_wmi_enable_hotkeys() from=20
hp_wmi_init() keys started working again after reboot.

This problem is present in 3.11 rc5. Please can you do something=20
so keys on my notebook will work again and it will not be broken=20
again in next kernel release? If you need some debug data or=20
something else, I can help.

In mail from 16.04.2013 you provided similar patch but with
#define HPWMI_BIOS_QUERY 0x8
I tested that patch and that does not broke keys.

But commit b253c9d1d858a3f115f791ee4fe2b9399ae7dbbd have
#define HPWMI_BIOS_QUERY 0x9
which broke keys again...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart18357273.Elkb8AqA6n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlILPakACgkQi/DJPQPkQ1ITAACcCdgNkZt/ttqEsGHf46T0MCqT
quUAnReEAq2t0CQL59hth4F33fU///1l
=h4+b
-----END PGP SIGNATURE-----

--nextPart18357273.Elkb8AqA6n--
