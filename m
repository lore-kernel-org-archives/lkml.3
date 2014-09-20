Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaITJYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 05:24:44 -0400
Received: from sauhun.de ([89.238.76.85]:58336 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaITJYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 05:24:42 -0400
Date: Sat, 20 Sep 2014 11:24:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, atull@opensource.altera.com,
        baruch@tkos.co.il, grant.likely@linaro.org, robh+dt@kernel.org,
        skuribay@pobox.com, alan@linux.intel.com, devicetree@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com, Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [PATCH] i2c designware add support of I2C standard mode
Message-ID: <20140920092456.GD1612@katana>
References: <20140820124231.GD21734@leverpostej>
 <1408544948-22339-1-git-send-email-romainba@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <1408544948-22339-1-git-send-email-romainba@abilis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 04:29:08PM +0200, Romain Baeriswyl wrote:
> From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
>=20
> Some legacy devices support ony I2C standard mode at 100kHz.
> This patch allows to select the standard mode through the DTS
> with the use of the existing clock-frequency parameter.
>=20
> When clock-frequency parameter is not set, the fast mode is selected.
> Only when the parameter is set at 100000, the standard mode is selected.
>=20
> Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
> Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>

Applied to for-next, thanks to all involved!


--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHUfnAAoJEBQN5MwUoCm2t9QP/12DCp+hYOUOhe3RXptqazuS
CemJ/K01ugpHiL6/VS8iqFZ6WHNp6+1sz/rAf6xJqf65HaWDvAX5BKRQpJW37EH6
/GcxYDfsPlDFZbGcCd3kR3r+i5KBrCeWdlBHQIbWo1IiLD0OElsCJdAEothT2wZC
llXjAHJYNBYXUQbyVoeyt6HDdWvJVZdjrBi5eT5EL5oP+w3Fl5sh3vnEdHFi88cw
IYhqcUP/9MpRSsQ+4LpsNe6fGBZ6ss49ELKKnAfNPdurYAZy/X4Vv9vJZwJh6zly
c89lIfBtSikVjBq/utMXqh35Wgeb15HLaw0qxW7q7mqOLYxEYlpVTv+p9kXQrvxk
rKXwQqpkPi2SYfTmxQFEvrhbFSBZiHwCI77BZA7WZ1AbysnagCtPx5mWVNMx0q2t
jB4TVGo/hHmkDkvWKOpKxFN80Bnga8iwTZpVY2eKeXkh6MUniVrkhUnpvWSGMqRz
z+GCCLShW8mokEDCk6esPMyLR2GQzYrUDGACiglbEagxyorHncnXypBAeo+XpSwK
vjTsUXigsQGgA98fGZGWVWP8eQqUHFJIbUg42sSkHwoHKkSk1wVGwFRg/DDP3C+U
bR13tjmM9CzuGbuHSVszh9JnSYHCfAuLzgCmaxD7fnF4MuQ4EVwqz7v1b3EYxWHo
XfNsKTZIirQPmgDsgG1P
=7Dl/
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
