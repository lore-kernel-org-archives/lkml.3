Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaKZSKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:10:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39629 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaKZSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:10:38 -0500
Date: Wed, 26 Nov 2014 18:08:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Weike Chen <alvin.chen@intel.com>
Cc: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20141126180828.GN7712@sirena.org.uk>
References: <1416998110-4856-1-git-send-email-alvin.chen@intel.com>
 <1416998110-4856-3-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eOTraLL9VkO9n9NK"
Content-Disposition: inline
In-Reply-To: <1416998110-4856-3-git-send-email-alvin.chen@intel.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2 v4] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eOTraLL9VkO9n9NK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 26, 2014 at 02:35:10AM -0800, Weike Chen wrote:
> There are two SPI controllers exported by PCI subsystem for Intel Quark X1000.
> The SPI memory mapped I/O registers supported by Quark are different from
> the current implementation, and Quark only supports the registers of 'SSCR0',
> 'SSCR1', 'SSSR', 'SSDR', and 'DDS_RATE'. This patch is to enable the SPI for
> Intel Quark X1000.

Applied, thanks.  Please use subject lines matching the style for the
subsystem.

--eOTraLL9VkO9n9NK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdhcbAAoJECTWi3JdVIfQ9MwIAIG/4vAmMdwfrUUGIW5XQwg9
xSmuzqlWiEIyUk3UnylBn5ye1BfwomKZImMY2+stkGdv9pOFp1eFGGSzC3apwS+C
pfUgOksgBoBa7ULE/1W4c0OUdmmsrY/zvlYy5SNhz+ASVK4ppt7C3gwcS8e7ujT9
sQ727QkkBFMrLb6Fk5xAcoWhEijI0sfYutrnMcxnkAmQopl2ilA8hQi/sMZyzjAb
qbVfKYcazecBG93chigqiNhecoTctU75Z4ojlnH6FMji+XqVmhNv7/vkjKQVnTWZ
nyWiFAukx7iKufWIh8rB450m7qLHihbioz+sxR4ApM8y9FZ0V01kzPjI2oUk2CY=
=JQVL
-----END PGP SIGNATURE-----

--eOTraLL9VkO9n9NK--
