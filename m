Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423003Ab3FUOkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:40:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51927 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369Ab3FUOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:40:18 -0400
Date: Fri, 21 Jun 2013 15:39:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130621143954.GW27646@sirena.org.uk>
References: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
 <1371818017-5215-3-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RCcFxJ34+mAtH0DM"
Content-Disposition: inline
In-Reply-To: <1371818017-5215-3-git-send-email-t.figa@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/3] regulator: max8998: Use arrays for specifying
 voltages in platform data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RCcFxJ34+mAtH0DM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2013 at 02:33:36PM +0200, Tomasz Figa wrote:
> This patch modifies the platform data of max8998 to use arrays for
> specifying predefined voltages of buck1 and buck2 instead of separate
> field for each voltage.
>=20
> This allows to simplify the code a bit and will help in adding support
> for Device Tree, which will be introduced in further patch.

This is OK but doesn't apply independently so leaving for now.

--RCcFxJ34+mAtH0DM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxGW3AAoJELSic+t+oim9LnYQAJ3M5Ch/8phf//tb4bcVfytm
8XJK3KZWKK+ABWo+3/tmvf3iFNhrlciFV8Qmkwdi3qzOj3rpPlULCH10dOspMj4p
4fcKAhZtT0N+SrLhNVsIfJdcmhyAuQfUFlWMKo9bo0UvliLuOwwaYB8C/dCI5gw/
BRTLaxwt1K/bdY7XgDxsP7WyWTk8hQfGKZJi8wBGYOu8Ya88UdYT0g5vuQEksM0B
jzQzBrN7DkZOFXNRz1W1SSrNvUayGutZEoEgVzgxKD9rM7hfjMkqpjrf09pfahAN
O+G7ZiTMDoWZIyqQr4Od2M3zONfG9ufdLAvT5dRZjgmJX90tKZeAdNfTYVCn0ji8
h77ZRSRytcbxfB0TTJlY7Gnye+q5bFUHe+gDXqu6DhSkONvA0P75/DymXA9XJfAn
cboaAZZXwaNsSUxvOvgIFudDXVO6S9OtK4BJZsn8jtvZJm6R1ofG0QN+JaKDrZCl
At9qNlisc4U3brE7Ty90s+62hQb1zjsqw+4h1/gXlxMytRpcuK23RSLH+26EE0A2
9PMxHFQOkT3KhBcMt0VWr4J48ozHMOsTHNseAIIH4GkSLk47r00kv+rP9YLbPCFA
J+8/IH/WnSVUnAq8KC+KfxxaMYfBsP3yJ5YJM6de/lySKUL7t1jL7d2TD6tc6vay
ikktUmI0MuzEJL/HP44h
=IXGm
-----END PGP SIGNATURE-----

--RCcFxJ34+mAtH0DM--
