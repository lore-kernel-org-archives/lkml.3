Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaALT3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:29:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53220 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALT3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:29:31 -0500
Date: Sun, 12 Jan 2014 19:29:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140112192910.GW29039@sirena.org.uk>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-7-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wt10+cXOThorkX0z"
Content-Disposition: inline
In-Reply-To: <1389469372-17199-7-git-send-email-tomasz.figa@gmail.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 06/10] ARM: s3c64xx: pm: Add device tree based power
 domain instantiation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wt10+cXOThorkX0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 11, 2014 at 08:42:48PM +0100, Tomasz Figa wrote:

> This patch adds support for registering power domains of S3C64xx SoCs
> and binding devices to them using device tree.

> +#ifdef CONFIG_OF
> +static struct of_device_id s3c64xx_pd_matches[] = {
> +	{ .compatible = "samsung,s3c6400-clock", },
> +	{ .compatible = "samsung,s3c6410-clock", },
> +	{ },
>  };

Looks like a rebasing issue?  Otherwise this looks nice.

--Wt10+cXOThorkX0z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS0u0DAAoJELSic+t+oim9bJoP/j3g3Ww60EYiniS/qpVDRKHZ
Y1FKvvuklY9EOgpeWnxUqophI3q/Xh4dv+hJ3eDy19LEKOJuevOg5chVSX6saAE3
hGMQIrhpS6gtike+t3aAJy3Nk7CbOjqHE3FZ+4dQj2icpygbrdgTvzxckK3N5kib
uNuqhInb9EkJx7jjKAsEfvUYogy6GK3aKav+bV7I/hOM6H2kZcYE6CmdrkSU6eBy
hDjY+8LBt3qcjQQbhiJMKineRRXhSehzIaBaLkB6sa+Vo5Z3yeh9BwrQ26uEpJg/
1PBstvYyvUBNLcvppcTS/TdVVlrfBqAWHtqSP4EVSy1VH+/utpQBB/yuZ83jIJGA
DMLvyIf7iR2nLFiYx6XCw1exDKc6x6iyxe+fPXRkIgQzIxUGwiHpcWMWgx+cGm14
WxOaRZvi0JR2KA5F2dLrc6c3Uxof5I/a9siZB1i2/LhNV3145F7c4z8XJugJIQVi
eNam3Dt8ofMZdMvA0KDHDrpo+ZEcEC5Rewr6wmTC9x7hZBeIcAtjClTG7/sP2wmV
N4XWiOKx8n9B34lhYgBIfnU9+NetspjJWl2A6oxpGx+/SQ5gnuSjiKHHJh76J9rl
5sNCBAZ7wN6x76VCLBElHuRx5PnFeTzlgFXP/+jxAoQdR+V/Bw9K8rHH2AlIVVwv
ZWR3MMQL4y2vaxiqHEkb
=VPpm
-----END PGP SIGNATURE-----

--Wt10+cXOThorkX0z--
