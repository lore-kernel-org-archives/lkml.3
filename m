Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3EGAYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:24:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56297 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab3EGAYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:24:03 -0400
Message-ID: <51884971.9050508@ti.com>
Date: Mon, 6 May 2013 20:23:13 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com> <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com> <20130506213413.GH5634@blackmetal.musicnaut.iki.fi> <20130506223653.GA12089@obsidianresearch.com>
In-Reply-To: <20130506223653.GA12089@obsidianresearch.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2EAAKNRALDJVHSFIXMWNU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2EAAKNRALDJVHSFIXMWNU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06-05-2013 18:36, Jason Gunthorpe wrote:
> On Tue, May 07, 2013 at 12:34:13AM +0300, Aaro Koskinen wrote:
>> On Mon, May 06, 2013 at 05:00:56PM -0400, Eduardo Valentin wrote:
>>> Introduce HAS_BANDGAP config entry. This config is a
>>> boolean value so that arch code can flag is they
>>> feature a bandgap device.
>>
>> Maybe it could be mentioned that omap-thermal already depend on this?
>> At least for a random reviewer it was not immediately clear why this i=
s
>> added, especially since there were no users for it in subsequent patch=
es.
>=20
> I looked (very briefly), and it seemed like omap-thermal is self
> contained and doesn't need arch support?
>=20

It is. At least I tried to make it, at least to the extenstion I could ge=
t.

> I get the impression it is desired to minimize driver kconfig
> dependencies to the minimum required to compile to increase build
> testing coverage, so maybe it would be appropriate to drop this
> entirely?
>=20

Well, it is also desired to compile things to the correct target right?
Thats the idea behind this config option. It follows the same design as
CONFIG_ARCH_HAS_CPUFREQ, for instance.

> Jason
>=20
>=20



------enig2EAAKNRALDJVHSFIXMWNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGISXEACgkQCXcVR3XQvP2GpgEAgnqZgHFcKy9T7f2uO57WcFrq
w4XfekxJfXM1JCrRKWMBAOzCTYLNVb02G+ILWtM9fw4h2A9OXrpgvn7MNqZkG8ll
=3ZQ/
-----END PGP SIGNATURE-----

------enig2EAAKNRALDJVHSFIXMWNU--
