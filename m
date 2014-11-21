Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaKUHEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:04:41 -0500
Received: from sauhun.de ([89.238.76.85]:48994 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaKUHEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:04:39 -0500
Date: Fri, 21 Nov 2014 08:05:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Baruch Siach <baruch@tkos.co.il>, "Du, Wenkai" <wenkai.du@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: designware: prevent early stop on TX FIFO empty
Message-ID: <20141121070554.GF1480@katana>
References: <545CB6C4.8010201@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yH1ZJFh+qWm+VodA"
Content-Disposition: inline
In-Reply-To: <545CB6C4.8010201@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yH1ZJFh+qWm+VodA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 12:10:44PM +0000, Andrew Jackson wrote:
> If the Designware core is configured with IC_EMPTYFIFO_HOLD_MASTER_EN
> set to zero, allowing the TX FIFO to become empty causes a STOP
> condition to be generated on the I2C bus. If the transmit FIFO
> threshold is set too high, an erroneous STOP condition can be
> generated on long transfers - particularly where the interrupt
> latency is extended.
>=20
> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Applied to for-current, thanks!


--yH1ZJFh+qWm+VodA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbuRSAAoJEBQN5MwUoCm2Vm4P/2WJo/YijxHHkvdU0CMQ8zWa
ezutbaLvLDGKZHkbOHVWhIg9ST1ZDioE110x6pEL7ycTc3PpgNuCKiUXlzhgFNXz
HKJm7YhNM1CIs9gfUoHizvFMSUNzL538lwIy27AZ3WqAiNAdMFdz5aaDzBNXEVXq
iTZZyTgrz7xjmTLkITCklmra4998u8g+FLOuNkHKsyUZilqJvJlgaPpDCVkWI3WR
4YyS72cBmBxV8/7s1/PKOPJtFeNUJv0j238EyGiW6g5pZ+SEZH7J/8E1DJTK2IaB
/blNjPxiCr5jSGV0nM4P62S84kl1IItKD+JSXpzxiG1CHECLM0jT4V/ymcug50HO
jNlrd5d7/8zxB/HxtvgBnyyKn8QG44ztRxIMvWKKMbuyBh88Sie/9byp/gr6Wu2X
hN+tcrVVpSSXTfqk0KeEkBOU2IPoZpTMz37pBAqJybcChr5MX36bJ0CfeOSNNG6o
Zdqvqvyqq4Qh5VYKlgSqQ+CLOWc2qVRrnGZO97hw/Vajk7DZe33N4A6cbGoeau3g
bLM6xh9RXhkCR85pwKA88+2xXHmsOYMvjMQIBuqznYkecE1HOnmBIlXhB5l76wJI
ctphM21O/gY1PRkjv+FT9N9psnjKNXSy29S6D24Ijg8Orf5uEWC6+AaxbdbeFIFr
+L0MS5jrA6WBJbvQgOnG
=w4EQ
-----END PGP SIGNATURE-----

--yH1ZJFh+qWm+VodA--
