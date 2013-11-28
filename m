Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab3K1NrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:47:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44959 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab3K1NrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:47:13 -0500
Date: Thu, 28 Nov 2013 13:46:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131128134641.GI27568@sirena.org.uk>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BWWlCdgt6QLN7tv3"
Content-Disposition: inline
In-Reply-To: <1385626183-22990-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/5] rtc: s5m: Fix unsuccesful IRQ request during probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BWWlCdgt6QLN7tv3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 09:09:40AM +0100, Krzysztof Kozlowski wrote:
> Probe failed for rtc-s5m:
> 	s5m-rtc s5m-rtc: Failed to request alarm IRQ: 12: -22
> 	s5m-rtc: probe of s5m-rtc failed with error -22
>=20
> Fix rtc-s5m interrupt request by using regmap_irq_get_virq() for mapping
> the IRQ.

Reviwed-by: Mark Brown <broonie@linaro.org>

Presumably should CC stable.

--BWWlCdgt6QLN7tv3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl0k+AAoJELSic+t+oim999cP/3l02goJ1g1uUcP+bxKkWvLY
v/oSJs89nwIVOTP+uufAewvI4QfuWZ/VKkzFXqgXTyHpFfP9rEaoziYVrqvWhE6Q
zQB/uNobBKS1NjzZxDo3Qi8XYJIaUeXmWbjxYMff2Taj04F4b5jJ8FxFr+hQw3Pq
hJjJjmIfojOkFAz9Dys4Go4ogEAB5qT5b5owSk9aMnY5afRrm4MfShfOZlfE476Y
PMjjwGTvxPVIDNIm2PhrannHIGOL8uGULsUK8XzKClVD5507DMbN+ZMUImuFBm/h
ivpXi7bKCDHXoQv/KJOScAKWnWptz071umBiaY69X2Yj1+SUDUNq+78YjyqxZHH+
1Vnss5vje7dkTUK2o+fCitcnQLy0j8sHVhuBOeP642341Z4ZglQT5XnCa9HplshS
5avtmW0CBIBgIb0c8dLbp7GMF7lNIr+Vo20dQpgxVJcgfN/AMFKyNm2x1Dj/6/Xn
Xeydx9GXRvceQxCaEtrYwynqRGsVtcMsooOxq8+Lv0W8PuGhvSY4opbtrc0TM5jX
hqBt1kYd6s8N8ZIWvocSoJBYpv1QeegfrWc2+kfs8+jTsSl31vvtBcn6X0pILNlu
z+59O2M3ggRibbzFzKnuuTLfuwVEz9MrnrE1m8DQqhMjIhb/MiqNTesDUj8oCHXf
3CEYfPu3akaPWfq8H9K6
=fqxS
-----END PGP SIGNATURE-----

--BWWlCdgt6QLN7tv3--
