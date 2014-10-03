Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaJCAqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:46:06 -0400
Received: from sauhun.de ([89.238.76.85]:34528 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaJCAqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:46:01 -0400
Date: Fri, 3 Oct 2014 02:46:31 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Carl Peng <carlpeng008@gmail.com>, Huang Rui <ray.huang@amd.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] i2c: designware: Add support for AMD I2C
 controller
Message-ID: <20141003004631.GD1323@katana>
References: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline
In-Reply-To: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2014 at 01:04:52PM +0300, Mika Westerberg wrote:
> This is second iteration of the patch series. First version is here:
>=20
>  http://patchwork.ozlabs.org/patch/390694/
>  http://patchwork.ozlabs.org/patch/390695/
>=20
> In order to get source clock to the core driver we need some way of
> creating it in the first place. For Intel LPSS it is done in
> drivers/acpi/acpi_lpss.c but that is not applicable for AMD I2C host
> controller which is too different from private parts to the LPSS one.
>=20
> We solve this by creating the clock in ACPI parts of the platform driver
> when we detect the AMD I2C host controller. Doing this requires small
> refactoring to be done to the probe() which is what patches [1-2/3] are
> doing.
>=20
> Changes to the previous version:
>  * Rebased on top of i2c/for-next branch
>  * New patch defaulting ACPI probe to fast mode
>  * Instead of direct dependency to COMMON_CLK we depend on (ACPI &&
>    COMMON_CLK) || ACPI. (suggested by Wolfram)
>=20
> Carl, can you test that this still works on your machine?

Yes, Carl that would be helpful.

Patches look good to me.

Thanks!


--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULfHnAAoJEBQN5MwUoCm2kscP/RcpZpUg53J/x5d5Yzpk3Gil
BMhljwDAD2CZk/BAgDEA8X2rU/j+HGxFRoaHR/5di1k7In8DE92gkE1d53/8k5KK
BPH0fmDzgWr0NEH62x4n9ShubKE/T3jXC+5meF8a+g/jsGq2BkCymz6zwHsD2mnR
+K8o4JBcioZz7RrEM4Y1SfV5YpQRfSEfgkf2qgjuyoo0MBTtMrJrHOXSM+6zr1jP
Lqr1puNiPTbnNnUuwuhI7XbaykhkH66T3mgW7VayXwXrXQlvtI9hr6OVA2r1tbVY
rEycQiCtzog221qRjRjMkj4c/GCC5/c04tY4Sn6lZ5EehNsozB5e5vQBpnUFuyuQ
XuhFbxp3bpL9+OamWks7dIKwUPHmxFb/rdlGWYYhuiPssIe/w4ZGS1pXwVZoTRh0
8wseN2XlwtBwVQZFkcM5n4noo0L3l+NT15MlWoAp7Iv0gmoxvI56TcFcIIj2EVAs
4HXQHnbqudjQaJEQWGJN4vxai/pgw3Z8C57IcHJyULw62LeAlhFbPj7TjkVLqVwJ
+94+kPK2l3qhiRamsB4cLWyaKRD+ijoiual65A91ZhT9l1a88p2ORKm5pcdpigQz
rDfJpmthWwySdZ5v9b+ZFvL2NYxd4rmzjaQNyACW0p3hXJwrKQlF3MUL3QHDmXqK
ekclJ6NLuMAQoYkjYCAg
=2cG3
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
