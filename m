Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaBSPQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:16:32 -0500
Received: from sauhun.de ([89.238.76.85]:49910 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbaBSPQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:16:30 -0500
Date: Wed, 19 Feb 2014 16:16:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Message-ID: <20140219151626.GA13973@katana>
References: <cover.1387588711.git.luto@amacapital.net>
 <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 20, 2013 at 05:45:13PM -0800, Andy Lutomirski wrote:
> Add i2c_scan_dimm_bus to declare that a particular i2c_adapter
> contains DIMMs.  This will probe (and autoload modules!) for useful
> SMBUS devices that live on DIMMs.  i2c_imc calls it.

Hmm, after thinking about it for a while and a couple of times, I get
the impression that the functionality of i2c_scan_dimm_bus() should
better be in userspace, i.e. a udev helper. I could imagine introducing
a new functionality macro I2C_FUNC_DIMM_BUS which can be detected in
userspace via i2c-dev. Based on that, the helper can do whatever
necessary. What do you think?


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTBMrKAAoJEBQN5MwUoCm2j/QP/RweNaFTpVw9nI/LU07tolwU
/W202vUpU6lVGxLRS6WSDfjO4DvzAp7rXUdMWioxvfr3i8t+bCVkFDvm/dcpnToS
ts67v5Wq5vPYEDxrBvsQ/+IHJmKc+i1hjE8FkD+iqUN+ri/c1Xvb6YaVNsVjZ0wK
Tdm95w26cy7rcUyBvvJU8xjO0hE/T2N8mE/B7ZUpmhKEEONPv5LqEPGPPjGYJnXa
KeoqdabLmdgrQa1GfAyZ99qklDWxZ6zs4IvjonaD3cJqLnRwa/dU/kRKFYtOewNA
kUnlqSZ8Hf5F+nnBFL8Q949cv0SH5uK3WxK/0iaVMQyjJuk1bfHhIReuU2WSW1g6
gg1ZCrTQbccBv/pj76u+4JbZ235lYmOXcj+QkptyAnrmnDIg/ZneH1FT5DumQzka
VZ0WC071EmGfPGe2MZ3ZcMgzC0OzqbkaeHoVDAa+19YNjKQfKzdYxxv0kz4S/bKC
+BEiAD/7u8yH6rKiN9A9KFhvNZo5iqfNJrO62l2xcnN+GVEfUFt3ZRKkOHBT2NBt
ZLVcTEM+uAZsLPylr/hXhEQeML4qaolHiWbLalcgrmnTthiYRcktrht5MS5tsUBX
+jT+MXE25YiqazfXQ1SX/jFi/34xfcE8dGKjw/TLNGil2j2mV+hXI6eyTBkWGQOl
6zaBJWf4EhbrBLsaxnwX
=wrrz
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
