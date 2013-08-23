Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3HWIvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:51:40 -0400
Received: from sauhun.de ([89.238.76.85]:46680 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab3HWIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:51:37 -0400
Date: Fri, 23 Aug 2013 10:51:33 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jerry Snitselaar <jerry.snitselaar@oracle.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: move ACPI helpers into the core
Message-ID: <20130823085133.GB3035@katana>
References: <1377095303-19330-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <1377095303-19330-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2013 at 05:28:23PM +0300, Mika Westerberg wrote:
> This follows what has already been done for the DeviceTree helpers. Move
> the ACPI helpers from drivers/acpi/acpi_i2c.c to the I2C core and update
> documentation accordingly.
>=20
> This also solves a problem reported by Jerry Snitselaar that we can't bui=
ld
> the ACPI I2C helpers as a module.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Applied to for-next, thanks!


--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSFyKVAAoJEBQN5MwUoCm2RXkQAJv2lbEjHhujuArKKwHkFUwe
0U8a58jPYH7SUVbq3xJsf5jb9jtm5OJz0ZjG9PsQ8F4ZucNHTOPHkA3j/jnp72mG
y6ajjjWcw5WbMSAbbSpWIi9nVD+3E7+lZ1N2BC41OcieRNzfv12PCWBpcuWNZ+p0
iyO2HxPcrAU0ARV0irrNjBp8uoqhn7AjwgFGxnCbmjG40whRzQnlhIoOWuLGpelV
j+R/Fn+g0uWMHbYwoff+B1o348ZevStQ5oIdKtEz31wFH5G6tWflcQgqyBKta1wL
eXge6UURtVPTkEZWUeosvlWJM5UcmuT/2P5DGxkuhXqNeP7ZaNyLRwCxa2y5WJy5
4OSt+9fiG0eiWTpUj8+tVewTvSmsFJlqPrEWzSwiyB5UocG+Ld/dHil10gfMMOE2
tXgfW5MoyWxarfRGck5K7kgsX39URks/d6ALEtrBpCBDaRJNyrwONnYrv9jWXDed
8bp2qw+boLQqr0TONKD2Y2XDrDKzFL6We3qtJagedTx0jQy1T+Y8yCsD7GWXdI2B
78nQ3JMhETAVE8D7Aqh93XN12o9vJC26REzncOAADrVIGNAaXifd2k7Ys7mRvJv8
prxgkwKOYzB3VAf5ju0Xwm6sxds2uyuZ6wBvzWNoYvBt4yYttCeC1219aRJMP2Wg
XHXlmSzK864oliNzI1kT
=8RI2
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
