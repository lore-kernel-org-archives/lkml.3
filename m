Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3GBJdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:33:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40063 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GBJdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:33:16 -0400
Date: Tue, 2 Jul 2013 10:32:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        balbi@ti.com, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130702093247.GY27646@sirena.org.uk>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NpaPS9owJKTasCT/"
Content-Disposition: inline
In-Reply-To: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NpaPS9owJKTasCT/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 02:26:39PM +0530, Sourav Poddar wrote:

> 1. Placed pm specific calls in prepare/unprepare apis.
> 2. Put a mask to support upto 32 bits word length.

Does this hardware really support anything other than 8 bits per word?
There is no code in the driver which pays any attention to the word
size...

--NpaPS9owJKTasCT/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0p48AAoJELSic+t+oim9bE4P/0UQFX4/5QXH5LyjWfd44EN2
iurf/whFO9kWNUnzGoh689RnJTl7sQfnBPLiBTuan7qs10pIbzhSEmBNyzK5wUKd
jzvonHg3/gMKzZbEcALhzYB1dQb7OKspsq6aDk7kWZMvKP2JxjjeSJtfIay7LWSV
KLAFmtu2ujaM+NfS8iXb6+WGSbxqUlnjfR8KKvObj0IEEOn+o5TVFTomrI2p3krj
dIVTqaRM1bXKG2vk3tk2GbPE4GKOAsZvSrOSLaHJtT8Nsotzfinfl60Xhzo9xGAK
TTmFMDGQmoGiNESLI90LcJEAi6pXC4aG7s7zB0LUJVSdDUa3KuwFI+J/BemJ/HG+
5NQdBUngO82u/AosR36MnXhODlnI98pyHbOWFbhjYQs61CY7hbkhDUSVHLD4w3K3
sM73Nu92m3XaDBXbgBLZkGpEEy/5e3MeykFuSzenNbb/tR+rg+QHKXIg/KX3eu92
eM+fpmpuD2EwdsFjlT93dwZIGtM8XEksfz0AVCaiR52GIm20MDMMhnv9UrSBovSc
Bi18ZEJopDtwaKNEwjffY5HHiCuI9czWj5TXiXRgJQMpRPXbRpDfouIP/84rGHZN
3OQ0X4kEw7Qzc5LH5XDYNbSabeRHJ339UDHiipekWVtn2+w5mZAr6jSTlZ4SaTI+
1cxmtN09THWyfLd/3f62
=XLbc
-----END PGP SIGNATURE-----

--NpaPS9owJKTasCT/--
