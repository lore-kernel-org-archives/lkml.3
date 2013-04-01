Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3DANZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:25:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39340 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242Ab3DANZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:25:48 -0400
Date: Mon, 1 Apr 2013 14:25:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] ACPI / SPI: Use parent's ACPI_HANDLE() in
 acpi_register_spi_devices()
Message-ID: <20130401132546.GM18636@opensource.wolfsonmicro.com>
References: <2747891.0orCNBJG8v@vostro.rjw.lan>
 <20130401114422.GA18636@opensource.wolfsonmicro.com>
 <3094287.rEsFgshmOE@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uwB7x3tnyrZQfZJI"
Content-Disposition: inline
In-Reply-To: <3094287.rEsFgshmOE@vostro.rjw.lan>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uwB7x3tnyrZQfZJI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 01, 2013 at 03:30:05PM +0200, Rafael J. Wysocki wrote:

> I can push it through the PM/ACPI tree along with an analogous I2C patch.

Great, thanks - I couldn't remember if the dependencies were in the SPI
tree or not.

--uwB7x3tnyrZQfZJI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWYq7AAoJELSic+t+oim9F48P/32ihAhB/Ux6b8R9mF0Wb+28
x0xRpc3ZGm2PodnrYZ8/qSvxNXSAHg1sYWuz8y3OpvC3A0sVi1lLXim89wOYtAwc
aNqlhc76C5RE2X/4XhVEerZcDux9eniLULRD/O1Xfg5HJc8LvGd6C4G9ZtkgLU3E
isDiFdtg0Q1E4bMejmsxfXzvTPYVghJJqaQIoMXS8uJmPJy3SISBcOmqrpAqF6ls
gugP0ehe/nYmVqdOvYWyjwKrZLat5rq63d4dpP7nvZ1CSBbdale+WiDliNMz25BW
1TDQBezQE1Bn4HMWUs3uWSDOe3B3n+T6+RM9XxbPq9GrQWx8JedcA5+fhXhFXD0W
+qN5q2IixV9zRz/O9XOypWd7G8/9f1qhTThNSFXTWKe0RZwdNYOiFV3JazZZUebe
quSRf4Xv45cLSdnaQpwHbfGqnot7X4slyqnX1C74HrrPkD7zu6Kayz/dnAMuc0tC
Z/UeiUFPD6fXeEUiGiXlM8SXp5Vk4qr8+4MTW1FvsrwWfa6/doYRXBap3epaUlA+
pRb6iDDfIic3/sRtNY9H5tM3P6nUVFRin91ZKTPgKusjvK2htLyf7MMZjoiu4kx9
Wmke+a6sssoD+ewMSMFCAAktSehf8WAmkmyh1bEZbXJPUqeqNJVxf3TEt/Qzar7Y
HdiNHE4QpHrtAkUu5Rnl
=8DVJ
-----END PGP SIGNATURE-----

--uwB7x3tnyrZQfZJI--
