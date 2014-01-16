Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaAPTYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:24:50 -0500
Received: from sauhun.de ([89.238.76.85]:57021 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaAPTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:24:48 -0500
Date: Thu, 16 Jan 2014 20:24:40 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
Message-ID: <20140116192440.GA4127@katana>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
 <20140116122819.GO15567@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20140116122819.GO15567@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2014 at 12:28:19PM +0000, Mark Brown wrote:
> On Tue, Jan 14, 2014 at 04:46:37PM +0800, Zhang Rui wrote:
> > ACPI enumerated devices has ACPI style _HID and _CID strings,
> > all of these strings can be used for both driver loading and matching.
> >=20
> > Currently, in Platform, I2C and SPI bus, the ACPI style driver matching
> > is supported by invoking acpi_driver_match_device() in bus .match() cal=
lback.
> > But, the module autoloading is still broken.
>=20
> Acked-by: Mark Brown <broonie@linaro.org>
>=20
> modulo the PAGE_SIZE stuff Mika noted - unless this changes radically
> please just assume I'm OK with it.

Ditto

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS2DH4AAoJEBQN5MwUoCm2zsIP/iesTC0J7+9BH9yhobIeHxaG
SSxm8jK+938hUgdZcTuZwS5+HKxWNzydkK7vop0xRDjIAHBs+WX6nDrKiq7WDQJ1
H74j/z4T2T5l/3TeAu26/DtoN25wjU3T0NYpKkx6Dw6+02V+LZ5a1i+VWFfsYfcG
uiTjBR6wHvIMnZ31CpU9gf1NZ/9NueIkXQxGKfDNucJZLltL4V9DNyCIhzCcR0an
R3C/mG9iiYMbIgb3RNcZZObxerB1sADQL/srEoLHZ/+fMmhT1M4sIZ26B1I0dP6m
OxuxAFfQ1xr+uKUBDxlqWX9CyMs9wWaQosQliMB8FKttLUrL5Cpica8WB3aTFl2M
TwwV30DzDDNXbGyJ4n7MDqD2Zu5rTqMkdduLMvOq/siQlw9PbeKvH9w0k8bdKd2y
iYrcLJv9wGDT73fGj4PMXlNQQ0H5u3JTAH4cg/upWzYH14E5lWouZc0ecrospFHv
/3MndevF7eoXfao8D574QNVsMqNkcZanZb5HTuWhTPL/V0E345uv4hvLuqBjSA+n
BqIoyH/YjmWzv1dpoimBI0NaR+g9rCs4DrJSg0+JYwRdXLlxzJkNKOWZ5XcDxpah
KQi0++0gGviIS5UOeCEoLyTyMr9zwsTKjcjIH5wI1RpOkYsMqvt9hjuPkg7Tu4LN
zM+uGCgxM7hBg8AogV7A
=Mp55
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
