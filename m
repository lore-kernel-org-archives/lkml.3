Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaALTVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:21:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53182 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaALTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:21:22 -0500
Date: Sun, 12 Jan 2014 19:20:40 +0000
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
Message-ID: <20140112192040.GU29039@sirena.org.uk>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZsW/usBbx2ObC9TW"
Content-Disposition: inline
In-Reply-To: <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 01/10] ARM: s3c64xx: pm: Use name field of
 generic_pm_domain
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZsW/usBbx2ObC9TW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 11, 2014 at 08:42:43PM +0100, Tomasz Figa wrote:

>  static struct s3c64xx_pm_domain s3c64xx_pm_irom = {
> -	.name = "IROM",
>  	.ena = S3C64XX_NORMALCFG_IROM_ON,
>  	.pd = {
> +		.name = "domain_irom",

This is nitpicking a bit but are you sure this is actually a
beautification of the name?  It's mainly the domain_ bit, mostly since
I'd expect that if it's not obvious that this is a power domain the core
logging would be changed rather than tweaking the name of every power
domain user.

--ZsW/usBbx2ObC9TW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS0usFAAoJELSic+t+oim9J4cP/355BDK0edL3yVcbZhSZCCEs
rokjY/iVA12n8zQ5Pd87VFRI0YoObmeoXp60jdWBO44pJ7jcvmuFkoCOsg4smiE9
4AVf8qxNOlHB8NVAqqGQUqpL7fqOR4bgIBHZ861KdpByWuI5emxw/u2wOJ1+G9xg
CdKhlfRZajTplGPycRxqvex0thQPts6BJrCQLEyUONSTeLCAghvEMTFWzV1quTOx
Xntkti5D/qQtEb+9Lgi1efHPgDMGSJ9Wqzjgc1ycomWRmMDz+u0rgMjceR59xTzL
1xr3k5Yy0FlrO+k7xv9S0SnLDPIm/S2tUTHwnmGuB3XaHgbKupu0MJmyTLJndgi4
2ut0UMBv8kbxFHolLGad3pwtIR5cdUcShJiPCqs3QFjYMJ74AcGSPBfnrAw4gDsm
nIW74owUC4FV3/iy5/yjtN9tpihUSevlEN+FF+WfDYM8/j+jmEV0cHcgYxURFkK2
SPFdWEtKxXYNoC0UDYCvwEOrL6tObgCWQDMRMJQnJria6g950S8EmqULXQIZOeJo
OGEN7VWZvloqJLQDYyzN35mnBKrc6YNfUDHfgyrrrW1W//4JrLLSHcuNmJCWC4D3
0DCmL0go/BKLfAs6WacBOuYqMUJC3K9+hwsdntXtSl9+yHaVOFU+aRdsjwgpjkDz
/TxCT1vEED226aREsQWF
=P4l9
-----END PGP SIGNATURE-----

--ZsW/usBbx2ObC9TW--
