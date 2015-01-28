Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbbA2D3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:29:41 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56691 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761553AbbA2D3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:29:02 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Wed, 28 Jan 2015 14:38:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20150127223331.GP26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1659276.ZOd2qhmsQT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501281438.46942@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1659276.ZOd2qhmsQT
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 28 January 2015 03:07:43 Nicolas Pitre wrote:
> In other words, what prevents someone from creating, say, a
> custom minimal Barebox version that sits on top of the
> existing N900 bootloader?  Wouldn't that provide a much
> better user experience?
>=20

Strong cryptography used for signing first stage bootloader,=20
undocumented interface and other stuff which initialize HW and=20
small memory (about 100kB) for second stage non-signed=20
bootloader. Next kernel image is limited to size 2MB. And=20
currently uboot can be compiled to act as "kernel" image, so=20
second stage bootloader can boot it.

I spend some time to replace second (non signed) bootloader with=20
something other, but really it is not possible.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1659276.ZOd2qhmsQT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTI5mYACgkQi/DJPQPkQ1KsqgCdGk9XC3MnJbHGpL/UJiRrn2ve
GacAoIDHxUa81A/QlFEMz2X9sQARCOr6
=lJm4
-----END PGP SIGNATURE-----

--nextPart1659276.ZOd2qhmsQT--
