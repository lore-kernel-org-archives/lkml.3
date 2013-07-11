Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3GKIYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:24:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44002 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3GKIYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:24:17 -0400
Date: Thu, 11 Jul 2013 10:24:13 +0200
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, cb@sgoc.de
Subject: Re: MXS persistent bits driver
Message-ID: <20130711082413.GU11243@lukather>
References: <51DE5F1A.8010209@digi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="57SHPaztv6dlLu/a"
Content-Disposition: inline
In-Reply-To: <51DE5F1A.8010209@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--57SHPaztv6dlLu/a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hector,

On Thu, Jul 11, 2013 at 09:30:34AM +0200, Hector Palacios wrote:
> Greetings,
>=20
> Linux 2.6.35 had a driver for sysfs access to the MXS persistent
> bits (drivers/misc/mxs-persistent.c).

Freescale's 2.6.35 I suspect, right?

> I haven't seen this is supported upstream. Is anybody working on that?
> Where would such a driver fit?

Christoph Baumann recently started porting the Freescale's driver to
newer release.

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181569.html

This needs quite a lot of work, but it's ongoing.

Also, about where to put such a driver, I started a discussion about
this last week. Mostly, that would be part of MTD, from what is out of
the discussion so far.

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/182002.html

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--57SHPaztv6dlLu/a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR3mutAAoJEBx+YmzsjxAga+sQALUqupsWDB/GzsUveNq+fuhj
iS/lECFC8wKJHJ8BUTz39r6FlQKlEd2M/wev4NN/wEIDq9BgJX4key1M/cj2vp90
T/TthWnoj6Q3W2cjso0FWQyeISbHZGEuaIdg1Q7UbQsFP/lDTDEPt5P8wr5s/Ab0
vBgnUbG/x8PqVIu5zOH4nFG58ohul93YF7WDMQNkEyqYvL+mwGeCv8C1yCjZBKj7
sThq/sQf0wwfQDVCKeZ9SfZTG5rgD39hqvzJRGzbs2WRh5tYq0M8F7IPlXv1gYC8
0t612CTWM0T+xwZG4+ELq62OlNz+kIPB3V2HdnPhVk7LzoKx/W0qaNA5NLalK1er
dW1u98xdcXigFLUwo1BMU3f1I3k3WfFoubYmNuiempj0GsJhacxfyV2l5ocD/W8d
6j1n6iWSKC3eB5a2S5dfTPJyCx6NUDAuKv90ipwUrM+9iK0DTs20Gy7FnQMCWfbn
5QTQfN4Yrm+iCvh+iZyyU4vllhfdTiY3/Pzuxf8atAFRNttN3UdCzaexzVFCRj8F
INv54HmkncHUHKgrUm/FWFVdSRAXqHCsKv+o3ol341In61gkZeU/S63+0nO15eFX
SQ6/U5c9inqwUTueWLl6bnuuZwwhuohB6QddJrDX+ekuI8UqvHVOXzeGz3M9cZ1F
ts0XMVu254gjK0OsD5DI
=+O+O
-----END PGP SIGNATURE-----

--57SHPaztv6dlLu/a--
