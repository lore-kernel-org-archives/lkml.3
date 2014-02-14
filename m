Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaBOKJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:09:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60619 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBOKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:09:40 -0500
Date: Fri, 14 Feb 2014 20:59:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140214205915.GW4451@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <20140213192835.GD28112@sirena.org.uk>
 <1392365712.29133.16.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fw8vdPO5iEPGjqL+"
Content-Disposition: inline
In-Reply-To: <1392365712.29133.16.camel@AMDC1943>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fw8vdPO5iEPGjqL+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 09:15:12AM +0100, Krzysztof Kozlowski wrote:

> My initial idea was to do this similarly to the S5M8767 regulator (where
> there is also 4th mode: low power). The presence of GPIO in DTS can
> simplify the bindings but on the other hand it wouldn't be compatible
> with S5M8767 regulator driver. This may complicate the merge of these
> drivers.

They can always use separate ops.

> What is your opinion on this - should I abandon the "op_mode" idea and
> use presence of GPIO?

Yes, that's better - especially since the framework has support for
enable GPIOs.  It can do things like handle cases where the hardware has
tied the enables for several regulators together so they all need to be
enabled and disabled as one.

--Fw8vdPO5iEPGjqL+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oOgAAoJELSic+t+oim98x4P/0BkAcussMl6iaO7QENAuCkT
dS0CLxy1SoCnDxa+RWX8cB0hpBJEAAQ5zlUDVauRU9FfO9ijvhVzn9vZx5erjrKV
QEuMPmL2hiLZ6ymZ4T3qCkOdOnZ/i9b0y+AKIHopY/xwPL6cFxoO5P4FbOLhUMVn
o8qoEQQqGgwgxi/kGlCBecTUCT10B4tc924t0EpyJuDHNZA2kokYSkuoLQs84Z+A
6mW8a4lwsVt6afWwIXKQHBIRfO1Fj2gywSxsjFo3YhuFbPyX8bY67+78184dMcYV
EFD1yL9axOv59pIeYZmA8BtDiS2XqrL4szGcg4jpw7gZ6UR7kR0mIXe8ofJUoQoe
IF4ms1A2nMJKGRBhmOqhu2sRPRsmR62pjJVaym+efa7mSLzuIsbZEQHX0x/o8AM7
EGQtrkYK079W7aVePR5h1dEr17RMHN9wIHgnL+/YFW8MnP5Ybr6KdeRcQm0JTIDt
uXP1iIkAxSiWKhGNNIEm/FzXnw+m80wwWWBbhZk60agIoRMBgYNBvQvpeZ5KkvFD
EeRjLFzIuXcGqBXQSyo8BGoB7KwXN3oSFk1nVBCZBniqFfhNXORDZupgA2MMEkQE
JN3YDb7EKHXBx19jfy9JQ59cJNnO53pPZMQj4szVGZY0ra/ngC5Lo8SRFj9V+2Z3
9VJo1+5ushqnYOcVVu64
=iNyu
-----END PGP SIGNATURE-----

--Fw8vdPO5iEPGjqL+--
