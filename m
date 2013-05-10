Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3EJJap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:30:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43333 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3EJJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:30:43 -0400
Date: Fri, 10 May 2013 10:30:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Ming Lei <tom.leiming@gmail.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130510093007.GL3200@sirena.org.uk>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
 <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
 <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
 <20130509135017.GD3200@sirena.org.uk>
 <20130509141444.GV18614@n2100.arm.linux.org.uk>
 <CACxGe6sO7kEZgg6km4bzP1cq+2MqGb=D4cZbuWELoz+yhaO6KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HLsZ5Z1opAQvdr2J"
Content-Disposition: inline
In-Reply-To: <CACxGe6sO7kEZgg6km4bzP1cq+2MqGb=D4cZbuWELoz+yhaO6KQ@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HLsZ5Z1opAQvdr2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2013 at 05:39:03PM +0100, Grant Likely wrote:

> +1. You can /minimize/ up-down cycles with the kind of optimization
> that is being attempted here, but the driver still *must* deal with
> bringing resources back up if they get requested "later than you would
> otherwise like".

Now that I think about it we should probably have a debug option like
the shared IRQ testing one which does actually disable all resources as
soon as the kernel gains control of them in order to help with test
coverage for this.

--HLsZ5Z1opAQvdr2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjL4cAAoJELSic+t+oim9Wy4P/3iT9w1V4E0k+yOyhkOWpr4X
Xx7djaLRTi0STCqeyGJcJIeWKPfFfKUd2xutVYZ9jeMo973rFZGoO5MlIAaBT5SQ
diyIpFZ0X/P1kA7oKP9HMAUbg99LSpOcoiqX1mFaarpNwt/r0d4/3atFhp5N9zEe
xDv25bNjCLEo8mgISmsjUJtJYkLg9PZt19AcL2k+XWDSlGkH7EuVil54Q6GJP82v
1NWjUSnd7BoHqwyOBnJKtHS8h+i4MRWnq7aCfcpTlrQPi33TTW8TkfxGbXspKs4u
qWHNI+rpBXHNg0s4cO+1sBAFyUd/rpg5juyNwmuiaOOzSRejVFItVFnV4J8jKYxy
qbK/dSGoxR/eDGGghAZoLGfeudbmTumAI3/4xeex7PSGRpsULH64i4S8NXRNhG8L
Pws8zZ4fSvk5f2IKuvfAxbIPft/3Jk+2V8rkuDt2uHNzi4ctRekCWd/7K9WcX186
H41Zu376gZO6XFve6zBExpRiGEhKPj+1ReNruvHbtLp+ZXCDYkB5s7XhfqHM/gxe
6v/wd/OfN8v5D8rPlc2xj5D21CU/F20/O7TkBY+d4PQhhHG2j8sA5CgGxl2oPvQU
bN/IoqqkxPKJ/WqgHk+arCN9P30TVwPrHuys/Q8EdlvUxV6QqMBSBdp3el0xthUQ
09+O3HkVjRzYw+cDfJRu
=PbeG
-----END PGP SIGNATURE-----

--HLsZ5Z1opAQvdr2J--
