Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3IONxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 09:53:39 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54697 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3IONxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:53:37 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: input question: ambient light sensor button
Date: Sun, 15 Sep 2013 15:53:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart275853707.FCcElxl8mS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309151553.34000@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart275853707.FCcElxl8mS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I do not know where to ask this question, but I think that kernel=20
developers could help me.

I have notebook with one special button on keyboard which is=20
designed for turning ambient light sensor on and off. By default=20
pressing button do nothing (I can turn ambient light sensor on/off=20
via sysfs platform wmi module). Button press is reported by=20
kernel input device AT Translated Set 2 keyboard and reports it=20
as button "touchpad off".

Of course "touchpad off" is incorrect and I'd like to ask which=20
kernel key or button from /usr/include/linux/input.h should be=20
mapped for my ambient light sensor button? Is there already some?=20
And what is strategy for allocating KEY_* and BTN_* numbers?

I'd like to know this, so udev could have correct DMI keymap=20
hooks and other userspace programs can understand ambient light=20
sensor button correctly.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart275853707.FCcElxl8mS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI1u90ACgkQi/DJPQPkQ1JUKQCggeHfh9PuhAZJBOCp2E7/9xrJ
uBMAmwUqeP/8oxNljwunGa/5hqOU6F9O
=D6r8
-----END PGP SIGNATURE-----

--nextPart275853707.FCcElxl8mS--
