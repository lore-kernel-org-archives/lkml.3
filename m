Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaKMDiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:38:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:51959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbaKMDit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:38:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,373,1413270000"; 
   d="asc'?scan'208";a="636147062"
Message-ID: <1415849927.2454.14.camel@jtkirshe-mobl>
Subject: Re: [PATCH] e100: Don't enable WoL by default on Toshiba devices
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: linux@rainbow-software.org, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Nov 2014 19:38:47 -0800
In-Reply-To: <20141112.181813.1072534293888457853.davem@davemloft.net>
References: <1415832445-9524-1-git-send-email-linux@rainbow-software.org>
	 <20141112.181813.1072534293888457853.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nAQO+zSoHwI27HSlOxQS"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nAQO+zSoHwI27HSlOxQS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-11-12 at 18:18 -0500, David Miller wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
> Date: Wed, 12 Nov 2014 23:47:25 +0100
>=20
> > Enabling WoL on some Toshiba laptops (such as Portege R100) causes batt=
ery
> > drain after shutdown (WoL is active even on battery). These laptops hav=
e the
> > WoL bit set in EEPROM ID, causing e100 driver to enable WoL by default.
> >=20
> > Check subsystem vendor ID and if it's Toshiba, don't enable WoL by defa=
ult
> > from EEPROM settings.
> >=20
> > Fixes https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784
> >=20
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>=20
> Jeff, are you gonna pick this up?

Yes, sorry I did not catch it earlier.

--=-nAQO+zSoHwI27HSlOxQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUZCfHAAoJEOVv75VaS+3Oe2EQAIZvu1sjhsf9SEk9VrakOsW5
6Sm98oEo1fu35bWFHrlESiVyG8Jsil0Ev5UR/UbZunHhAJ1vx43+wjXPBHY249rl
kogGDoie/8AvSKsE5SMk2IqAMKPBLue8h1Md+sFRFZCGaZvS/zWvGBtcWCYNn3Xf
pNYcel3md643HLHl/o+pNzvKtkAFhTWvYIT60jnIyE30/6EvSsWJjPlBFBPKZQuq
uSawYFfQQ5zoK5cEvI/UcMiLu4CPR4K2DOJpOJYXZ1ZRO8wv3n32H3i3/c3c+ouz
7mKfaFOCU27g5EMZ94lHF2EODDm10UA6Fn+OrtIZpKZvNbyH6aYPvGxKDNgFmrrz
UXKQnt+NGqnhtNyeH7fNtcDuPiOFr/7AtJGU/71PEN8K1IJRl6uHJ6UyxlXYJWDt
DTDTOPzRMmvHKnFlXBqhuJo1PmrO1K2R5hYuNwEwVdcxbsdlNn6KEMKp2OaWR+bl
+3PwfseMLFIzbdVDvHe9VF6wQyhaCZgOuNYpx+6ItXzPs3k0obQFbNrbAnXjtt5p
/WcTmWqnDk3XRaihQiesMrWr2HbnDAb+/5Zhv1s7H5zfstYcPQsYSAObEosQfaQV
n4HInkM16Cm6CCON7Hx6Cnz6LdGxqFlwV+9g/KJKcBMVUHDSi4KkHomIjiiJ2zKU
HPjy00La1+62FJYpE7JQ
=1mvp
-----END PGP SIGNATURE-----

--=-nAQO+zSoHwI27HSlOxQS--

