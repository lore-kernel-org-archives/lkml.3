Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBOKHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:07:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35647 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaBOKHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:07:43 -0500
Date: Fri, 14 Feb 2014 20:44:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20140214204424.GS4451@sirena.org.uk>
References: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gh9b96O0vZdbsJLX"
Content-Disposition: inline
In-Reply-To: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/10] Documentation: Add device tree bindings for TI LMU
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gh9b96O0vZdbsJLX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 03:32:44PM +0900, Milo Kim wrote:
> Bindings for TI LMU, backlight, LM3631 regulator and LM3633 LED are added.

I don't see actual documentation for the regulators here?  They're there
in the examples but not in the binding section.

--gh9b96O0vZdbsJLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oAlAAoJELSic+t+oim91OIP/0v01vP3RZOAg8r0wJUUL0bz
TaP7yARbibvdosSvVS0e/pJtUEqAw3+hqgeFpPrl2h9zpaT/lmeam7/EajZKZJno
VntTVgLMyUHMq9hRuoof/g6fNRp74b6uDJyVgHXTEcmZL+TZ35S7jWfJJNhywBcX
vOqWyKOm9l/4dxISKXcOyCDAIZD6EbIcYKGIlUxplMGkISH1/O5rAlX8nau8oBTc
ECPhwSVKudb1B4GLI19TUFAoZ2/lyj+gDYhGcZ5m2ZIyGOgfhve0h2gTlwg7L1O+
WQEa7KAuWYbcgDW7zR8I1Hs9i7h1+NB7JiqePsWCCuR31MB6Eh9543hWYATNcY2Z
Z9Bpf8CzmJiDeKO3tWjNBxoHCLvPrPqcE+ZFzVcINOleByEnmlT7pN3yELeGenij
6gEfkdsAfb5la+4ILitqUwUBsbRkY/GeytOq1MFTM+dgvGoy/tZ+fsPY37DxEQkX
fa3l5L0r1TbHKK+7HzcUHpdVOVvMjyLA/9XM9qhvF5FcZPexEK1WRBUSpWtO1Mb0
v3ogQrv6tS4WzHa/UFud118omrI2WaWoXzRgz73rfkwNFeMU45s/D2q9+NnNNB2m
BcHmBSUbzK3HFzXa4+tyMswVu4cQZYYj3NqqsKHwwZXKaBY7nd7SGNG4VC+pB1CH
5dbKovTIRLz8YBTjIQBw
=ptHB
-----END PGP SIGNATURE-----

--gh9b96O0vZdbsJLX--
