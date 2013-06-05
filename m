Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3FEL6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:58:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56575 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3FEL6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:58:01 -0400
Date: Wed, 5 Jun 2013 12:57:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Message-ID: <20130605115734.GY31367@sirena.org.uk>
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
 <1370432398-7796-2-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sW3EvpYZ43JhLhGX"
Content-Disposition: inline
In-Reply-To: <1370432398-7796-2-git-send-email-illia.smyrnov@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: spi-omap2-mcspi.c: Add dts for slave device
 configuration.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sW3EvpYZ43JhLhGX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 05, 2013 at 02:39:57PM +0300, Illia Smyrnov wrote:

> +SPI Controller specific data in SPI slave nodes:
> +- The spi slave nodes can provide the following information which is used
> +  by the spi controller:
> +  - ti,spi-turbo-mode: Set turbo mode for this device.
> +

What is turb mode and why would we not want to just enable it all the
time?  Based on this documentation it's not really possible to tell...

--sW3EvpYZ43JhLhGX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRryeqAAoJELSic+t+oim9lj0QAINQ1Ap0ZL+76ujjUSr+gXGi
r//eyC1CLPnbUSl6d3lKZgwYicaU//IPib4CDinZERsR2dHaaq+FHX6TqwoHPPdU
BDFxzOc8V09DWcTo9TyXV58B0ruE/JxFQOsTsVl3SN4s9gMVKpLG3BLiw/C6Rdt6
/hV2kp7198v/jxXYGB2Q8g6GJNdyQKcoasR1syMtCfrmUWiK3tnfrJFV1U3Zw625
bQAzAj0FUKmghQcENXBojlcLWviHvs02vfWl6UmEv9nr0sPC7L0WKy3YAAvCkT6Z
falnolIAplq+lRQtv2sXRNzKr1qqK11p8hKetsT77RtzYzlGUpzVXznEO2JKu9gQ
L2o/FYdNZw6oJpFwFSN/Xqe49/fhpYiaUfgI63EKz3exIB+sarA5oQcGoPM0BhBS
dXQCdtyloTpTVnr5Uinqw4XdvS0zMcxamS9ECA5kGg9FHDALrH4umXA7qyYnigr/
1QGnWRCJhZ1ejMVsvIXhPhdUmL8+Gdrspr0+zsvuPMQJT061boQbz6oYUg4rL+3t
aMpW5GaMHvtKZIQK47FXD+wPbEE0WCqMN8wq82d0K6n3F00zKjExpFk/yaMUI73v
dR+scazZvyM8UcEo2Fj5viXPf55Bpt/Q0opEIqiScCyKgrUGdMx0D6nJ039sq9yY
ueaQq1YQVh6mPi4rmM+f
=k/vI
-----END PGP SIGNATURE-----

--sW3EvpYZ43JhLhGX--
