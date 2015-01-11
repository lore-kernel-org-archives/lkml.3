Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbbAKAJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 19:09:55 -0500
Received: from mout.web.de ([212.227.17.12]:56202 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbbAKAJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 19:09:54 -0500
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha256"; boundary="===============4901415456257742840=="
MIME-Version: 1.0
Content-Disposition: inline
To: wei_wang@realsil.com.cn, phihag@phihag.de, ben@decadent.org.uk
References: <20140810225012.3425.19201.reportbug@t4.home.phihag.de>
 <1407715088.3017.73.camel@deadeye.wl.decadent.org.uk>
 <53E81801.8000907@phihag.de>
 <B801BD58FDB66349A47F17A55A52796045FF6429@rsex2.realsil.com.cn>
In-reply-to: <B801BD58FDB66349A47F17A55A52796045FF6429@rsex2.realsil.com.cn>
Cc: 757733@bugs.debian.org, linux-kernel@vger.kernel.org
From: Johannes Schauer <j.schauer@email.de>
Message-ID: <20150111000919.4607.25466@hoothoot>
User-Agent: alot/0.3.6
Subject: Re: Bug#757733: RTS2557 SD card reader does not work
Date: Sun, 11 Jan 2015 01:09:19 +0100
X-Provags-ID: V03:K0:slxEs5dFoLxoHyzS8JyRBbZnornL0MUujxWcEY+JRNmNtOPn7Ld
 uHmNoxKs3r1mr1//i5eSO1yFH+1kIbYwHbDAxDHfBoIsPx07xcECi0xVrjUShWCwEUCXeJh
 2R8NCw9za09hBT1uxjYPNAgBTcFCXlKiVppVGz9ahNz0/uSmI6MPMtcVxN3WBJonn04zokl
 vp51lstB5t1ZdjBYiiwaA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============4901415456257742840==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 11 Aug 2014 06:45:24 +0000 <wei_wang@realsil.com.cn> wrote:
> Would you please try this patch. If it does work, we will submit it to up=
stream kernel.

I own a Lenovo Thinkpad T440s as well just as the original bug submitter
(Philipp) and that patch by Wei does not fix the problem for me (I applied =
it
to a 3.18 tree).

What does work is to follow Philipp's instructions to patch the out-of-tree
driver from realtek.com.tw. That module then gives me my SD card as /dev/sd=
bX.

Weirdly, my SD card reader used to work (but presented the SD card as
/dev/mmcblk0pX). I do not know why it stopped working though as I didn't re=
boot
my laptop for several months. Running an older kernel version (3.14 for
example) does not fix the problem. Maybe it is related to other parts of my
(Debian testing) OS. I'll see if I can find a Debian unstable snapshot that
restores the behaviour I observed last year and try to bisect to find the
source of the regression.

Thanks!

cheers, josch

--===============4901415456257742840==
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Description: signature
Content-Type: application/pgp-signature; name="signature.asc"; charset="us-ascii"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUsb8vAAoJEPLLpcePvYPhRDkP/3nq8SNabMVdXr6WQuE7SRV2
4ZehJ3IAM6uXIg9n4e8JCmWrWYrmwnOlz1O0vatXjyFgbizx2wUludiYMXUjblhS
aHlxSOxa7fgN3ILGRCKPBUauE/BmT/N4kRXVBNKC9FgRjaiARuViq8gIZ+++aNdL
rLnOiokvRQjdB2g9A7SMyMJXctR+SaCPHxQQLtgIUiDCCt6+lk8HCf91vVLHLSoo
GU3wW83ClKz43d2voWjpr1jrEF5bI4lYGM5CEp++IFgRYz031knWGS5o4m+90k0b
Ub0cmDrpSuZ9hQ3YUlGqlA54CNeRyDZtItUDMCeWee1hcqx/nwt5UWuzlmFa94+M
b9o637Xhd15apimEwwSbtpGU41Jh5p1OS85kdkDqPxDFvlq0ipHDNBVl8yjRtRFY
3PBELzrQdSS+QAXUaZh9hlWZ5dGYNtrmHUbVZhk6QSdAjIydawaTGdzTaMcYd7Fe
DpVx7C0EvImurIFNR5F2ubD6wlILpmJleZYQuGD6HD+nD/J+GoRRroHccvgNtAfh
x8Nxi8v9RNe4XTg75xKQVcTMB68tfpFmLwdVmC+z4jz7UjbyeNQKaAKol9szXn3v
t14asRbLZtvQHcOCV/UZ+bppzas86I/8TimDmDeQw29RC4H7fcHMEMnOYlDVEkG3
G6OiswJuL7fLKTbUXWYz
=sFMM
-----END PGP SIGNATURE-----

--===============4901415456257742840==--
