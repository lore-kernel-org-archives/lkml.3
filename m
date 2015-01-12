Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbbALVkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:40:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37506 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbbALVkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:40:33 -0500
Date: Mon, 12 Jan 2015 15:39:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 05/11] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150112213905.GI2858@saruman>
Reply-To: <balbi@ti.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417606330-17753-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Content-Disposition: inline
In-Reply-To: <1417606330-17753-6-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 12:32:04PM +0100, Boris Brezillon wrote:
> Since non-DT board support has been removed from the at91 architecture we
> can safely remove non-DT handling code.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

doesn't apply cleanly:

checking file drivers/usb/gadget/udc/Kconfig
checking file drivers/usb/gadget/udc/at91_udc.c
Hunk #1 succeeded at 1710 (offset 13 lines).
Hunk #2 succeeded at 1722 (offset 13 lines).
Hunk #3 succeeded at 1958 (offset 13 lines).
Hunk #4 FAILED at 1960.
1 out of 4 hunks FAILED

please rebase on testing/next which I just pushed.

--=20
balbi

--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtD75AAoJEIaOsuA1yqREnL0P/0ZdPB46Byvm2oj9t56CEeZk
R2kBsJhznYqBJzUXMaccvjcP1HXr4HVQQhTR/dF52cus4nXHvNK2p9NQ/9Ja8Qf9
PhyPAoAryTrhQvc50JSOs9z1DsIE3uRwvRIRyVJrplMp04M+Bs6BVHj7s0BXkXOV
NkZJqcjKIonBxyHZ7+/4P1/cWCPoJ/JeE6F7Zs+Az6eOcH7KSphtVFRAULV6lC10
TaH5xJcEWPDljOzIgRKcAUljopldnnBo22+KJW2ErZf3EdIwTCZPL3Ae+4rlG1L0
4JAOOrYL4OaGACb5NdJ3j1dEx5/dJyF+jAUNq4JfgPyr0UzmZOc6bQ6u5h30LLNJ
Y49Ppgz2ohe3PydGi4cjrlwoVp0UrQzTa6E2s/EmPs0c39Omz9RrR5px8sSAyZQc
YBuP2a1qi83Kx6ftdeFoP8NQ6s4vOCO3ZjD7JwF08SSCYI1jqBebSX50/fSx7vIe
t1IURJqbXVOxnA7FCf5g5p6IeDxKjEtIL7W5JuRXT89CXz4z5IoSOxNOH13+J6iq
sSS7WygyBz+9QQQXCyqrbNyus7HNDSfCoOWPQPcKlHLMkkutsNPlcTBCEUM+I4pN
Lx7XQW7AFNtIzM41qdOQfROzYOfJCZDeA7zpBgjSHHQe2oehgow5gkDTQuLQQAa0
qZxv5X3Vq1za1z9rfY+C
=uDD9
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
