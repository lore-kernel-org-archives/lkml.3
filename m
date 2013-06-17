Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3FQJQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:16:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58157 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3FQJQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:16:40 -0400
Date: Mon, 17 Jun 2013 10:16:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-omap@vger.kernel.org
Message-ID: <20130617091630.GZ1403@sirena.org.uk>
References: <1371226328-24147-1-git-send-email-illia.smyrnov@ti.com>
 <1371226328-24147-3-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i/mq3IMNEv8uWibA"
Content-Disposition: inline
In-Reply-To: <1371226328-24147-3-git-send-email-illia.smyrnov@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] spi: omap2-mcspi: Add FIFO buffer support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i/mq3IMNEv8uWibA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 14, 2013 at 07:12:08PM +0300, Illia Smyrnov wrote:
> The MCSPI controller has a built-in FIFO buffer to unload the DMA or interrupt
> handler and improve data throughput. This patch adds FIFO buffer support for SPI
> transfers in DMA mode.

This looks good but doesn't apply against my topic/omap branch - can you
please check and resend?  Probably something that applies against -next
will be fine.

--i/mq3IMNEv8uWibA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvtPqAAoJELSic+t+oim98jgP/RVFzo1lUH8F7aEumfJrjMAn
M6C8sli0qJLqDlPsAqctewNnu2E7FDKBUGvTLT+R6z91q7u8QVV0B2ZFwzAWl4wW
TYmTYpumFyMn1PhKxeBcoR09QdxWsBxybt0URJPw5+sLzyRmg1o8FckIqanzjnXb
yOC0gePj7s6WAymNwRahOnBY+kvUoYhzdbxswsl4HTPJicdjSBIJh2f1YiJkuNnX
IAxPtnVsHX9OdJaUZlRGkmnPVa5g0XusXXj+YHJz1VnRYE3/Wm3hWIbbnRlMeEJt
//GV3luxJexZbNwen4ihUtv5iXaKSrxP+VtfQjJFPakcSoPyYPkCU4B19ik9qUn4
EzLGqaHAti7+lN5r56Dt9Di/oNJyyyR8nJzfaUcUOYmP0FemHBB2AGo3jJg6IQD3
7AQUCye/28vE6+LMagU3eGJCNSlyQVsIRCqF/k2kTc+kPeuYPTaAtIlB+408qifH
OWo681oTHmwj2ok/4Migze+D0d1+3fLC2b9/dNAjxRfCQHSGQEwd52o67wLqsZfn
X+Sykutpl+ExQMxbsq0Czj8Tu5apqvvhhF+IMge2Q5QQCdLEhGT9VxWnak82qvNf
SChOM+oiux9ilbRtjONlEC1eS+1z25UbmvPhqTEGD6C9R+Vi4NwV6Lj/mNRtET1W
hKg0RnDZRlvnegfIGdSo
=S+oO
-----END PGP SIGNATURE-----

--i/mq3IMNEv8uWibA--
