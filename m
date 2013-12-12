Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3LLSTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:19:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41800 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3LLSTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:19:39 -0500
Date: Thu, 12 Dec 2013 12:18:18 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v5 1/9] phy: add phy_get_bus_width()/phy_set_bus_width()
 calls
Message-ID: <20131212181818.GI1939@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386854770-2173-1-git-send-email-mporter@linaro.org>
 <1386854770-2173-2-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PMULwz+zIGJzpDN9"
Content-Disposition: inline
In-Reply-To: <1386854770-2173-2-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PMULwz+zIGJzpDN9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 12, 2013 at 08:26:02AM -0500, Matt Porter wrote:
> This adds a pair of APIs that allows the generic PHY subsystem to
> provide information on the PHY bus width. The PHY provider driver may
> use phy_set_bus_width() to set the bus width that the PHY supports.
> The controller driver may then use phy_get_bus_width() to fetch the
> PHY bus width in order to properly configure the controller.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>

Kishon, I need your Acked-by here, if you're ok with the change.

--=20
balbi

--PMULwz+zIGJzpDN9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSqf3qAAoJEIaOsuA1yqREIh8P/j7kXjr/8/nG/9VkH3Ob/SMx
v+/meeBDhloMdwJQPpfZtt2UuR5bOcNW2Nndk4NHBZY8rI9JyllyMYG1V9C3AOsP
B+fnADY8MTuP6wSogWcHb7e8aCRIqfRoFT++eQboQSIy7rYO4rBfsAzqf9nlgQ6h
9mmGoNZmFDVCFqfkBI6YiU3GJpxI9Z5w20y9+5Xf+0ukwRdA2CjdIt2s87MsROty
a84c9BWN0oO9xL6Jy7nZvftln0DtuKdxdQ9pFhw1Str8cLN+IZXvemRgRYrEmWA7
JgnVbrFgMqdRnmG5sZCcCgE5bGElihUvqpWcTF8BjR1S/ZwiqdGOh13phnL0BQYE
wlKSquVDERbjWtafNmds6C9dRnYBcMIRi0Xk2lkuc4eof2XFsthb3YNqpBysu6RI
Tg9hE3dg+nCHztdwdfbzCVFtJTas1i+fKXW9vRLIWDZgqtDMxv6BDpQct3hLouRI
kGWhmteB2veiUHCUaleNX1Amevwe18YcD1ByLNu9hPkDPjDE4Iejcrr3g7w3ZHu2
qbwRO8BOOsoZ5hIdyoQxpZN1etGpLFK/rS3p4fk/yKyliGGqlv+NGULjGuiRkO4i
IB7e5FSAPO90t5Htf6+D2odGiX5U55tV02K+pD4puU9LZnvXuJyca/3yOItUBpr8
rEx/jVopri0tii77zmNc
=SzAj
-----END PGP SIGNATURE-----

--PMULwz+zIGJzpDN9--
