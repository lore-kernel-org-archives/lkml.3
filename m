Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaIYORQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:17:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:47968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbaIYORO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:17:14 -0400
Date: Thu, 25 Sep 2014 16:17:06 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] power: max14577: Fix circular config SYSFS dependency
Message-ID: <20140925141706.GA21125@earth.universe>
References: <1411628731-8458-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1411628731-8458-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 09:05:31AM +0200, Krzysztof Kozlowski wrote:
> Make the max14577 charger driver depending on SYSFS instead selecting
> it. This fixes warning on x86_64 with allmodconfig:
>=20
> scripts/kconfig/conf --allmodconfig Kconfig
> fs/sysfs/Kconfig:1:error: recursive dependency detected!
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CHARGER_MAX14577
> drivers/power/Kconfig:327:	symbol CHARGER_MAX14577 depends on POWER_SUPPLY
> drivers/power/Kconfig:1:	symbol POWER_SUPPLY is selected by HID_SONY
> drivers/hid/Kconfig:638:	symbol HID_SONY depends on NEW_LEDS
> drivers/leds/Kconfig:8:	symbol NEW_LEDS is selected by SENSORS_APPLESMC
> drivers/hwmon/Kconfig:299:	symbol SENSORS_APPLESMC depends on HWMON
> drivers/hwmon/Kconfig:5:	symbol HWMON is selected by EEEPC_LAPTOP
> drivers/platform/x86/Kconfig:496:	symbol EEEPC_LAPTOP depends on HOTPLUG_=
PCI
> drivers/pci/hotplug/Kconfig:5:	symbol HOTPLUG_PCI depends on SYSFS
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

http://git.infradead.org/battery-2.6.git/commit/6a91e854442cf950d9cb8068916=
67d16c4a41d88

-- Sebastian

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJCPiAAoJENju1/PIO/qaahgP/AkRCq8Nhdv7Jqo2vJib8/gr
IAqdohuUnyuAlqIqwgGiSbFI07ypUV3UMFNT6ITDQ03/EOgKx5vGT1NLK/qFDQDj
pk4p+XXDtODISYM1QphPOLOxSbEjVRBIgbpWHktkNvqR56YnSKvDxyxfSt0atSpA
GhAWCwGAkYwCUkpnxLcLhiwFVDtzt2sTN5yQnKykLHMqn+hgBCTDy/xpMiLDzabJ
kQMW3BoaDPY5IOBtimQzGQhYDfXoPg/0fr/vptfLGyGM9QyCtVu/CSGxA1NZo7ZT
Sw6kSMsDFUTiOlCi/HuxZW4kmszWQ5Oj/h9dUTcESooV9QVwjGKfH5iuqJM6zlpC
0cCJaWSNJjG64oxkbRENX504nQ9TRyZGtdVQV+t3nd4n0V+jNj4Pyh860j/mB1XQ
OvzTLp6ILuZjYnQcAVZyKOTAAKVVvoddJsM/HYhwI3ZpaosHuBztl7L6GlA/B+OL
BIIUmk6DE7RGI/UDGbPCbTAieAo2Z0wBggwQvDz2VOGDOwKAsWHVSR8p9dH1JVXS
VHWq3wnEc9NRn/X4g/ylR5BnoEtbU7+aDzzATj9IE9Fyw0P9DMKJr4cUyNnuxxeC
UgupEgeJ4vKEYCNbI/FBwSWhvfnWQbn7I2EYUjkqaVcKGSAR7v1w2ejHK4zHta5X
x43EnIb0N9V1Y1sEhPUB
=MFKD
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
