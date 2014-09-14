Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaINEYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 00:24:39 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61312 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaINEYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 00:24:37 -0400
Date: Sun, 14 Sep 2014 07:24:27 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-09-14
Message-ID: <20140914042427.GA1926@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140914041912.GA1623@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20140914041912.GA1623@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Sun, Sep 14, 2014, Johan Hedberg wrote:
> Here are some more patches intended for 3.18. Most of them are cleanups
> or fixes for SMP. The only exception is a fix for BR/EDR L2CAP fixed
> channels which should now work better together with the L2CAP
> information request procedure.
>=20
> Let me know if there are any issues pulling. Thanks.
>=20
> Johan
>=20
> ---
> The following changes since commit 39e90c77637b3892a39f2908aea57539e961c5=
0e:
>=20
>   Bluetooth: 6lowpan: Route packets that are not meant to peer via correc=
t device (2014-09-09 15:51:47 +0200)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.=
git master

This was supposed to be a reference to the for-upstream branch instead
of master. Both point to the same commit at this moment but it'd be more
convenient if you pull from for-upstream so that the master branch can
continue living on without waiting for the pull to happen. Sorry for the
extra hassle.

Johan

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUFRh7AAoJECQj9vv5qNQSzywP/3WE/WVtytzT+kURz02i/d+/
xe8bFszWhbaLk2Aoiqv634UCaq2MiP9vhd1aPXl0eHI5dbV6/k1OMPmrszBzbJ7v
qs3gbnbRfrGuW0udrQJTqt/WMXH0JmkGcL48i4V0fjf271e37aJAcvo/Rq67i+/o
9LdaV1gLXfSs2bqtVUKvsXlBdF4HBNcUnPURjtWFDkytT7z4heci/7KdYpKcNDYk
saksJbgalJ7wy3E/Uz3pkufMNTnxrmDJOLxRihZ3JDzRTPCNtkTyKOPvkjhl7nJp
mA12NMOjC+V2vrJ9euFLnX17lJqwPZUkij51B4H/h0VaAwWdQHNM5OLhvsWqTDRa
MBELzAWWGN4HHEn8JCQpHy8tCZKrOd33KmzTzY4u7kTc5zjK2Z+BQfP1PkXMxUFc
ZupfUxMKj5HzV3t4qsMAy+e7Qj36HcYl93p6Aabb/27k8mS+6m3V1dFJ3Qal6aFb
dY1nAzOx3CWO+xiuwZGCVObPl7s5LDgAeTVl3MBCodC9Z9oXbWdCmosIZrQuD8uQ
QqQp+tvKjSSUF81s73gR73YIwmQpN/SVUaeUBOyySEUPIyki4Xp8DJvARnCj83PE
svEUOySIzvak6Sz5H9XqZNUaTocmEP5i0qjTmngC5VNal0Bo4kxGfteBcTpA+mnH
uHcMMTA5ONV1gYVg9NYn
=hNjp
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
