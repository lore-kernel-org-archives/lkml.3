Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaJCKXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:23:15 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51904 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaJCKXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:23:13 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 3/3] input: alps: Reset mouse and ALPS driver immediately after first invalid packet
Date: Fri, 3 Oct 2014 12:23:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <201410031205.42927@pali> <542E780B.7030103@redhat.com>
In-Reply-To: <542E780B.7030103@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1869901.lScz0Yih5A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410031223.10608@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1869901.lScz0Yih5A
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 03 October 2014 12:18:51 Hans de Goede wrote:
> > On my E6440 machine it somehow working. When driver
> > doing ps/2 reset keyboard, touchpad and trackstick not
> > responding.
>=20
> Right, but I would expect that to be for only a short period
> of time, or does the whole reset take a significant amount of
> time ?
>=20

It is one or two seconds which is OK for me.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1869901.lScz0Yih5A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQueQ4ACgkQi/DJPQPkQ1JvlwCfdbiMLw4YyC1MTaEG9a3f9xYT
crsAn0n8CTo9Tn5LY0z4XdeBXKexewiA
=HUe4
-----END PGP SIGNATURE-----

--nextPart1869901.lScz0Yih5A--
