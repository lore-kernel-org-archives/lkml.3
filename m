Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3IKPxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:53:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50083 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab3IKPxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:53:23 -0400
Date: Wed, 11 Sep 2013 16:53:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130911155300.GY29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cm1SDJw2Z5TZh/dk"
Content-Disposition: inline
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/9] runtime PM support for I2C and SPI client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cm1SDJw2Z5TZh/dk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2013 at 06:32:31PM +0300, Mika Westerberg wrote:
> Hi,
>=20
> This is second version of the patches. The previous version can be found
> here:
>=20
> 	http://www.spinics.net/lists/linux-i2c/msg13152.html

Looks good to me now:

Reviwed-by: Mark Brown <broonie@linaro.org>

for what it's worth.

--Cm1SDJw2Z5TZh/dk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMJHYAAoJELSic+t+oim9AtMP/RsjPKLqeVwSu9N7CF4/FrKx
lTosUCz3R7Vu1/rtIBPuxvQ4I+J89a0qHVUzIwQGlDZqf43pN8ST2r0CRJivd3nC
rPQqtteyYA95v66GRUwc1lGnLPYAEy7WuV2flojGufqkFObDmmmwfwpwqFkl5wBa
xYceBh50kwBPapV57I0ezBmjLyQ5YWwr4oHmfsiYvjnpvtC5nd2uJQG3yUyXPMSy
Bc97vZzZdptqZv1D1TJWC6EBnBL+lcjKaWne8PKB/DTgcvP7RolxUwQE5EFUeBR1
8QaLL33M+7fzq/D15W3pN8jZl5Kn99wsqj3vi6pvAJ48wL2tl5WIyjGNtINyyg1x
98oGhxxBQefktNxT5qB/u76BvEVZinl9dS3j333iHK1ZpeIEOog2CZwDWD5mP07J
KmnLovp4WHzLUF64K5R0lTxG8lp5YBkIaiUGTikdu2DcroIeTX+3imKc6BFwgmFH
yitQX5nBoGobBYf57NsfXXltggEMC84f/opinghR4WSbDkJXb6otc5388ZO1SHC6
Zyt76bTPVnrTmBxPBcZjwH/r0GDgmzXgOre/1jCNVxXhCMuhy/iMwilotpXKRjUl
wAGx4v8etFpCtvEH9NDIuDzrlE+3V+oGvldH9IlxB0q23B8C/NsZ3mgcf9O9cEsN
VDVeyrTlaeYzBAF2qFCb
=JoG9
-----END PGP SIGNATURE-----

--Cm1SDJw2Z5TZh/dk--
