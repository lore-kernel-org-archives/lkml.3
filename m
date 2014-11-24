Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaKXWV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:21:59 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41448 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKXWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:21:58 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Mon, 24 Nov 2014 23:21:55 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201406182122.29623@pali> <20140618211038.GD558@drone.musicnaut.iki.fi>
In-Reply-To: <20140618211038.GD558@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart708437191.5LzpsHdefE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411242321.55626@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart708437191.5LzpsHdefE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 23:10:39 Aaro Koskinen wrote:
> Hi,
>=20
> On Wed, Jun 18, 2014 at 09:22:29PM +0200, Pali Roh=C3=A1r wrote:
> > So without this patch DT migration for Nokia N900 cannot be
> > done without breaking userspace - which is not
> > acceptable...
>=20
> I guess the fact is that the Nokia N900 proprietary userspace
> has never worked properly with the mainline kernel without
> severe patching, so you cannot really talk about any
> regression. If you cannot fix those programs, you could still
> probably emulate the old Nokia kernel's /proc/cpuinfo by
> providing some text file and bind mounting it, no?
>=20
> A.

Mainline kernel (with patches for missing driver) working with=20
Maemo CSSU-Devel userspace. So there are regressions.

Emulation of /proc/cpuinfo is possible if somebody provides=20
needed info. But I still do not know from *where* to read=20
machine, serial number and hw revision.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart708437191.5LzpsHdefE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRzr4MACgkQi/DJPQPkQ1LyVQCgxPiaQhp/5Ejq7NYkrpVlPlVm
piYAnixseYpEroIWow0B8luEAlbyF/rY
=IIys
-----END PGP SIGNATURE-----

--nextPart708437191.5LzpsHdefE--
