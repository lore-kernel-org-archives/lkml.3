Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaIJIaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:30:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35358 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803AbaIJIaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:30:05 -0400
Date: Wed, 10 Sep 2014 10:25:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH v2 2/4] mfd/axp2xx: extend axp20x to support axp288 pmic
Message-ID: <20140910082537.GC31276@lukather>
References: <1410267775-4683-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410267775-4683-3-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Content-Disposition: inline
In-Reply-To: <1410267775-4683-3-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 06:02:53AM -0700, Jacob Pan wrote:
> XPower AXP288 is a customized PMIC for Intel Baytrail-CR platforms. Simil=
ar
> to AXP202/209, AXP288 comes with USB charger, more LDO and BUCK channels,=
 and
> AD converter. It also provides extended status and interrupt reporting
> capabilities than the devices supported in axp20x.c.
>=20
> In addition to feature extension, this patch also adds ACPI binding for
> enumeration and hooks for ACPI custom operational region handlers.
>=20
> Files and common data structures have been renamed from axp20x to axp2xx
> in order to suit the extended scope of devices.

I still feel like this renaming should be in the first patch that is
already advertised at doing it.

This is quite hard to tell what you are actually doing in this patch,
besides the renaming that is.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEAsBAAoJEBx+YmzsjxAgHg8QALLFLYzyhPCN5S8rUj6NA9ll
9JjSqPmyjAyDZT5PUupjG4hOOiYVEekCxecOmJmmADTtK3BkziCnYNLI8CgjO0GP
yuD2jmOnMEeyjr0Ig+9MVoaI1vC/ouWsY/GDpPXcwbHJLizYoq1xvb4NRT6/Yal8
kr6ISFLqS3SAxIC4HoGRP3LxiZwOXgQavIrJ16fcvlMBbO/WLGZ7Gcl9EKmi4Hlk
tmVIjUaEMEEGbhB0c0/Pp11f/SvLFOf8cSMLlmTGZX96RRCDfrho8wPf7jYPKj6a
fHGxmUe/dlTm34yZ/VgfO7veE2W5E+w2RZIb9KkdmQtQjsCoAPJDaHioeAxOkyUJ
T5X7KuZqaaMieT6hGMvSVaE9ZLdDmxmrhPwqXpYcZGX9WOjZ7vEDAmWK5IYTXtEE
et8etzxA3KpS0ZwZbPtE8WciG9hSpBcXxfrbqRTjKcBD73tTJYl6vgq1N5k3B8dm
NOGn8uY9H205+IpbfCE6ElwqS+TTmwWElAZPOoxh8hIAuP24pKii/S7fkOFPVPA0
UaENXebSANCetlg4qMaYrNvx7PQaTC9BmcTF6IMIvSaMG6tADYgHc24BkTS+HK4W
wDYB0TDFjsJXAw3WtR/4tmfS1Z6/IqfkHUc8LfOKUAZSmeylENuk8BedMr09cFkA
4O6Mj+Zrrz1/hRkf1ORn
=cFLd
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
