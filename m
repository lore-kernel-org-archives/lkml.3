Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaKEVM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:12:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51883 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKEVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:12:22 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: N900 modem support in 3.18-rc1
Date: Wed, 5 Nov 2014 22:06:04 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Sebastian Reichel <sre@kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
References: <20141104205117.GA17606@amd> <201411052137.31452@pali> <20141105203918.GA29199@amd>
In-Reply-To: <20141105203918.GA29199@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2683732.v9upTCThi5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411052206.05379@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2683732.v9upTCThi5
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Maybe you need to enable modem?

This is n900 init sequence from script: nokia-n900-configs.sh

    # set up the GPIO's for N900 modem:
    echo 70 >/sys/class/gpio/export
    echo low >/sys/class/gpio/gpio70/direction
    echo 0 >/sys/class/gpio/gpio70/value
    echo 73 >/sys/class/gpio/export
    echo high >/sys/class/gpio/gpio73/direction
    echo 0 >/sys/class/gpio/gpio73/value
    echo 74 >/sys/class/gpio/export
    echo low >/sys/class/gpio/gpio74/direction
    echo 75 >/sys/class/gpio/export
    echo low >/sys/class/gpio/gpio75/direction
    echo 157 >/sys/class/gpio/export
    echo low >/sys/class/gpio/gpio157/direction
    echo 0 >/sys/class/gpio/gpio157/value
    # create symlinks for ofono N900 plugin
    mkdir -p /dev/cmt
    ln -nsf /sys/class/gpio/gpio70 /dev/cmt/cmt_apeslpx
    ln -nsf /sys/class/gpio/gpio74 /dev/cmt/cmt_en
    ln -nsf /sys/class/gpio/gpio73 /dev/cmt/cmt_rst_rq
    ln -nsf /sys/class/gpio/gpio75 /dev/cmt/cmt_rst
    ln -nsf /sys/class/gpio/gpio157 /dev/cmt/cmt_bsi

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2683732.v9upTCThi5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRakT0ACgkQi/DJPQPkQ1IAyQCggohsTovx6sTcRoSat5Nematc
jJAAn3FaCjj29X//NZ6FItoprxAF18Tw
=cmIb
-----END PGP SIGNATURE-----

--nextPart2683732.v9upTCThi5--
