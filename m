Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaKLRBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:01:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:39114 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaKLRBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:01:49 -0500
Date: Wed, 12 Nov 2014 18:01:44 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, sachin.kamat@linaro.org,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-pm@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH v5 1/3] mfd: max8997: use regmap to access registers
Message-ID: <20141112170144.GB27681@earth.universe>
References: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
 <1415776996-11569-2-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <1415776996-11569-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 12, 2014 at 08:23:14AM +0100, Robert Baldyga wrote:
> This patch modifies max8997 driver and each associated function driver,
> to use regmap instead of operating directly on i2c bus. It will allow to
> simplify IRQ handling using regmap-irq.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>=20
> [For extcon part]
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>=20
> [For leds part]
> Acked-by: Bryan Wu <cooloney@gmail.com>
>=20
> [For the mfd part]
> Acked-by: Lee Jones <lee.jones@linaro.org>

[For the power supply part]
Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUY5J4AAoJENju1/PIO/qa1/UQAJcZ1SQq0B1MUjO/YKl3l+qz
NjW8NVf6aZZP1jcHILJZCdb7vafFKVbin4LJgx4B60vVejyy7VEqFtxtl2TgRmlG
YpnIGVjIDteIVQGO2sOPNJZQCkmwXcojnLUpmDusQ1mf1BOf8RonCy5IHfGnp3EE
2vZ+8EOJ47mGqK0cuD08W7kvGqwQtcBq/M4pvTmzmPcBSUnaZjv2Wp7e6+MUmp6k
+LBjgiOerlkAnKWZmuDRl+a7D6MhPW8lI5u/Kk9Qzw+WFtiO0HllkXy26+VSB5uI
3TpeOUQuk5mRilqtiQdNIqrVJLUH2BVEDil6JxGGa3TU7eOQrkg8hZCEW+/FDWW9
hOCZG3VxsWHNPfOhpdlhGZ7SXTh9Z2oxjftxZYer7CwC9XS7PHUeLCczqIyFchY/
j86cBXreb6uUOE4icedZDBePNkSvT3oY63Q13VmauXfL5X5LVpp3jANFPszI4QSl
LxrllmqpSCqCJegctxq+v95g/4YC/+ZpM/m4eWbNrzyvKgJZQ/iVNH3xNUKdoaWr
cQTfjdZ+7ma298uIS0IIdo/12QVYaQ9hFqKU/Oy+VNfQxmEHVjcWYIZcO6eIcUFf
1L91G7lLpXz2H9L8u/zAY0LL+RKY8f3aH20VKI3jbXDG/tW7sai5p0C2WnWIlWDA
gx/ysKjHSMuUhi2tHf40
=r5Wi
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
