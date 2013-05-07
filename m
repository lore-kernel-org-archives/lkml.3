Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab3EGNP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:15:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab3EGNP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:15:56 -0400
Message-ID: <5188FE54.6050200@ti.com>
Date: Tue, 7 May 2013 09:15:00 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com> <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com> <20130506213413.GH5634@blackmetal.musicnaut.iki.fi> <20130506223653.GA12089@obsidianresearch.com> <51884971.9050508@ti.com> <20130507003651.GA26035@obsidianresearch.com>
In-Reply-To: <20130507003651.GA26035@obsidianresearch.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2WTIPEAPNWATTXGNEDRSO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2WTIPEAPNWATTXGNEDRSO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Jason,

On 06-05-2013 20:36, Jason Gunthorpe wrote:
> On Mon, May 06, 2013 at 08:23:13PM -0400, Eduardo Valentin wrote:
>=20
>>> I get the impression it is desired to minimize driver kconfig
>>> dependencies to the minimum required to compile to increase build
>>> testing coverage, so maybe it would be appropriate to drop this
>>> entirely?
>=20
>> Well, it is also desired to compile things to the correct target
>> right?
>=20
> There is some of that too..
>=20
> But broadly the direction seems that drivers should have minimal
> dependencies so, eg, the thermal maintainer compiling for x86 should
> be able to compile test/static analyze your driver..
>=20

Well, I do not see much of this attempt actually. Do you have some link
/ evidene that shows someone who actually cares about compiling drivers
for targets that they are not used for? On this specific driver, I
actually have  had exactly the opposite advice [1]. I am not convinced
people actually want to do that.

>> Thats the idea behind this config option. It follows the same design a=
s
>> CONFIG_ARCH_HAS_CPUFREQ, for instance.
>=20
> That is entirely contained inside arch/arm and doesn't involve
> drivers.

It actually goes outside arch/arm.

>=20
> Jason
>=20
>=20

[1] - https://patchwork.kernel.org/patch/1185431/


------enig2WTIPEAPNWATTXGNEDRSO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGI/lQACgkQCXcVR3XQvP1jfQEA8LtORo7s4WiJR/8Sx+DAMixY
D/TlaN98D/EJjePV87ABAMinzf3CXDuprOVPzfulqBvuFYza/K7Ti+az8ia3vQ0r
=An59
-----END PGP SIGNATURE-----

------enig2WTIPEAPNWATTXGNEDRSO--
