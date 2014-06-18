Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaFRUXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:23:10 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62973 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbaFRUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:23:08 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] omap3-n900.dts: Rename model name to "Nokia RX-51 board"
Date: Wed, 18 Jun 2014 22:23:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500-generic; KDE/4.13.0; x86_64; ; )
Cc: =?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1403110635-29696-1-git-send-email-pali.rohar@gmail.com> <20140618201241.GB558@drone.musicnaut.iki.fi>
In-Reply-To: <20140618201241.GB558@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7054152.P5ARp0I99L";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201406182223.03420@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7054152.P5ARp0I99L
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 22:12:41 Aaro Koskinen wrote:
> On Wed, Jun 18, 2014 at 06:57:15PM +0200, Pali Roh=C3=A1r wrote:
> > Use same name as in legacy board code. There are lot of
> > userspace applications which using machine/model name for
> > determinating device type.
>=20
> Can you clarify this? Nokia kernel or userspace never had DT,
> so they cannot see e.g. /proc/device-tree/model. What other
> APIs expose model?
>=20
> A.

Hi Aaro,

look at email discussion about my previous patch with subject:
[PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible

Basically that patch export model name in Hardware /proc/cpuinfo=20
instead generic DT name. And this patch change name to what=20
legacy board code reported.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart7054152.P5ARp0I99L
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOh9ScACgkQi/DJPQPkQ1K92wCfWPzfOnXVAXT31aaaGYEpuewG
r1gAoLoEGLEPGM6gOJb/FllP211HjRj8
=93Eg
-----END PGP SIGNATURE-----

--nextPart7054152.P5ARp0I99L--
