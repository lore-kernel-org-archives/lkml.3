Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3JJJjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:39:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42389 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JJJjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:39:09 -0400
Date: Thu, 10 Oct 2013 10:38:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131010093839.GD21581@sirena.org.uk>
References: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
 <1381327461-10562-4-git-send-email-mika.westerberg@linux.intel.com>
 <20131009175528.GV21581@sirena.org.uk>
 <20131010061256.GB3521@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KYWjQn08oZ6edC5T"
Content-Disposition: inline
In-Reply-To: <20131010061256.GB3521@intel.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: attach/detach SPI device to the ACPI power
 domain
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KYWjQn08oZ6edC5T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 10, 2013 at 09:12:56AM +0300, Mika Westerberg wrote:
> On Wed, Oct 09, 2013 at 06:55:28PM +0100, Mark Brown wrote:
> > On Wed, Oct 09, 2013 at 05:04:21PM +0300, Mika Westerberg wrote:

> > > +	if (ACPI_HANDLE(&spi->dev))
> > > +		acpi_dev_pm_attach(&spi->dev, true);

> > Though I do wonder if it wouldn't be sensible to push the if () here
> > inside acpi_dev_pm_attach() and similarly for _detach().  Terribly
> > trivial either way.

> Actually, the check is already there in acpi_dev_pm_attach()/detach(). The
> above code follows what Rafael did for platform bus previously. I think the
> idea is to have visual hint that this is only for ACPI enumerated devices.

> If preferred, I can drop the if() checks, though.

It'd seem neater - the fact that the function is acpi_ ought to be
enough of a hint.

--KYWjQn08oZ6edC5T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVnWbAAoJELSic+t+oim9sREP/1JnCBcgJTvVWKSOAUXeA0bl
dt1hEUXoQbx18fGe5/PZgcnkhU8uEwnf76uvS5Pu2BXDHAifdz/jb2aa+I2gdPr8
2aSnEyo/A0hTkprxbECCudvLuKvB02idRG0N8ZS7xPycahL2i2du6zaRj5XACLuY
LvvxBJVecKz0HOEszbNdfGXHgqb9zK+TEDtw3vx+dT2w9BKff4j7mLFMjXDaVqo/
YfRrvvYFWPh9LWkLKZ8W68K45RWOCNXTgWq4KtfVZsFBT6KcRHqzIirvmiDo6Wt9
ij+yTkGTLQJo8C68ByXsMlXS/Rlz1tti0Xrf0DyB7nqDVcWSYKZDVQtSZt1jn2L3
KfC3QrRCy9RFyDwwqMSLyG3Uo5jPZG9tG4pcoCJoGEzZpgNpphrTLWmGE/IIkh9I
gnLhiLTrOG4h35cgBiQw4XPvp56CwwNYA2BsSY1nsw+zIU9R3Dv6m7oiCwpi/7A8
U//d3wbLnduEiF0QORyTYrQuyf1Aly7bIuushZYhlFIClJy6wwbUqNQzwnZdFYjj
4Ovh5c5dtirBpWu3hWwDJZyiy6O4SowfXXCQK+XhwcJGwqHgb+CD1IwD7WyzbVMJ
ZAnVCsFeW5+dqPuPDnyXgwfZF8MeIUZ2z5zkPPYVxldSpC3d3VGauPpzLoRDq7j8
Hn3w8vAzLO/8mUZAQg3p
=6Ea0
-----END PGP SIGNATURE-----

--KYWjQn08oZ6edC5T--
