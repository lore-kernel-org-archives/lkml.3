Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161512AbaKNReY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:34:24 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62247 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbaKNReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:34:22 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Subject: Re: N900 modem support in 3.18-rc1
Date: Fri, 14 Nov 2014 18:34:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20141104205117.GA17606@amd> <5465A977.4030605@gmail.com> <20141114172008.GB12250@earth.universe>
In-Reply-To: <20141114172008.GB12250@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10492741.B20IFtmAfR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411141834.19242@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10492741.B20IFtmAfR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 14 November 2014 18:20:09 Sebastian Reichel wrote:
> Hi,
>=20
> On Fri, Nov 14, 2014 at 09:04:23AM +0200, Ivaylo Dimitrov=20
wrote:
> > [...]
> > https://gitorious.org/linux-n900/freemangordons-linux-n900/c
> > ommits/30e9a5c498a89cea4c29523f69e436bf0af3c631
> >=20
> > commits 89ce13b, b81d80d, ec4d0dc, 91256e2 and 8022a6d -
> > e29f558 (no idea why gitorious shows those mixed with SGX
> > stuff, on my local tree it is contiguous patch series)
> >=20
> > didn't test against the current upstream, but I see no
> > reason why those should not apply, build and run.
>=20
> The patch looks ok. It does not cleanup the cmt-speech driver
> for mainline usage, but it should work. Before adding this
> driver to the mainline kernel there should be open source
> userspace support anyway.
>=20
> Btw. I am aware that this would break existing pulse audio
> stuff, but wouldn't it make sense to export a V4L2 device
> instead of the custom /dev/cmt_speech ABI?
>=20

It is not good idea to break existing applications even if they=20
are closed... And there are some open source meego/nemo=20
pulseaudio modules which using cmt speech (but audio quality is=20
worse).

Anyway what is /dev/cmt_speech doing? If it exports gsm voice=20
call data, should not it have alsa snd interface?

V4L2 interface is not for video/camera/capture/tv cards?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart10492741.B20IFtmAfR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRmPRsACgkQi/DJPQPkQ1IboQCgv92aX//7c+RU05LVCJJuuJB8
XXkAnjKwjaeMyQKIod4yvVK1GyA9GdBZ
=0c7Q
-----END PGP SIGNATURE-----

--nextPart10492741.B20IFtmAfR--
