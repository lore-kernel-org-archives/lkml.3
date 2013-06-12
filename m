Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3FLQlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:41:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55376 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351Ab3FLQlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:41:44 -0400
Date: Wed, 12 Jun 2013 19:40:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Philip Avinash <avinashphilip@ti.com>,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 2/4] ARM: dts: AM33XX: Add PWMSS device tree nodes
Message-ID: <20130612164026.GC22120@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
 <1370526759-31163-3-git-send-email-bigeasy@linutronix.de>
 <51B89D78.6010906@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <51B89D78.6010906@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 12, 2013 at 06:10:32PM +0200, Sebastian Andrzej Siewior wrote:
> On 06/06/2013 03:52 PM, Sebastian Andrzej Siewior wrote:
> > From: Philip Avinash <avinashphilip@ti.com>
> >=20
> > Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
> > AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
> > adding necessary properties like pwm-cells, base reg & set disabled as
> > status.
> >=20
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>=20
> Can someone please grab #2 till #4? Paul took just #1 as far as I can
> tell.

DTS should be Benoit Cousson

--=20
balbi

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuKR6AAoJEIaOsuA1yqRErY8QAIMQqji3CDR/ycenwR8GW2M4
rf8BMZtrzU9JKsrpaC8vN/nDFQuqn+OxYQP472Cfk29MznWU8VGMwCE+lin7nXbh
yISrCAPZ2EmbFRruH+oB3HMCsH+zkcW14vu1mUBfB6I3B8RI2/U6H4ca8q1wvFSm
hw3R5q8vUmPaRdUzJbE4OqI8LZYAkhyzK1ic7OKwBb89MdAggm8o49yYn9ZIGJVj
7MZnZiGU5obCZinyZP+rSdZ2dmeGI0UuLAS21M0IYO1yum/QxPotdT+e4Mko8j8U
MWgNL+MhdwRArZxsgVwN29jRv9looitMUj4I9RSs+RgI9W18BbPf04QMBAmCvb47
ZVrPmCDJI7keaCK/ZORUhOLcgPuEUjfjJskCLBKNiDOA3hYGVEKw30WrWzpSOdxw
6vkIyKXS2Pi7kp0DRiPw75Q6bC6NWseIHZQy/TnNcKtfsWvjUtRInmvI0QYaYl0E
pKp+htJNG8/nCzSV6HlzAl/0YcBU2hzv3W5o3PMIypHLqzFnxWXt9fBVQc5ZZq5i
50UiKkExrB3aoZRib8tpq82K6+aRC4vu4iwOIF+TeR9X1gLnijV61AZA2GyqIVn4
T+X29uwNTJePJ/mwv7OBBkM03Mi5U1bOMIW1oDugJteToxikWKtUk37Lm5MUtN8N
outPOF9LfFIB3M4QElyj
=weH5
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
