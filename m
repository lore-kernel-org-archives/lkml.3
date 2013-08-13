Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3HMIKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:10:08 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41675 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HMIKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:10:00 -0400
Date: Tue, 13 Aug 2013 10:09:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130813080956.GE9316@ulmo>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPYy/fEw/8QCHSq3"
Content-Disposition: inline
In-Reply-To: <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PPYy/fEw/8QCHSq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 08:46:50PM +0200, Sebastian Hesselbarth wrote:
> This patch adds a check for DT passed reset-gpios property and deasserts/
> asserts reset pin on probe/remove with configurable delay. Corresponding
> binding documentation is also updated.
>=20
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-pci@vger.kernel.org
> ---
>  .../devicetree/bindings/pci/mvebu-pci.txt          |    2 ++
>  drivers/pci/host/pci-mvebu.c                       |   33 ++++++++++++++=
+++++-
>  2 files changed, 34 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Docume=
ntation/devicetree/bindings/pci/mvebu-pci.txt
> index 638673a..f2fa261 100644
> --- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
> +++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
> @@ -76,6 +76,8 @@ and the following optional properties:
>  - marvell,pcie-lane: the physical PCIe lane number, for ports having
>    multiple lanes. If this property is not found, we assume that the
>    value is 0.
> +- reset-gpios: optional gpio to PERST#
> +- reset-delay-ms: delay in ms to wait after reset de-assertion

I remember some recent discussion about this, and we now have this reset
framework, so perhaps it makes more sense to use the reset binding for
this? Cc'ing Stephen (as part of the device tree bindings maintainers
team) who was involved in that recent reset bindings discussion.

Thierry

--PPYy/fEw/8QCHSq3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCenUAAoJEN0jrNd/PrOh0Y0P/R/Hmnc5rssTfrOALDwNF3EB
cOJoyEc4dYwFbyIAblONfy7x7HtMctmXMl1yFjPNiulimc18RcevGqCYJckxK9tx
RwWV2kNLvAMiYodOrDfWUTzQ1Z5zzagSI4nhNACGmj/Jt67YwpoFBFaN64FJ45UY
5XLRdkAeFoBDrfLagtQd3E2SRkhKdidTl1a2p2kBbnjQag9DgEwnQH8an4+KmAfq
tXY/PBDIWQuVv3t5rTiLkI/vvLIy27F1r6rgluiXOeThGV6ft65C3rhnCTcBIQlM
FVwb2Afnoa/mSSGHtviegt8zFai3O11PBmqFqFN9G3Hg4TmCLZzd3Kl6YP2LbY3W
aXc96OjoZI9M6MBSplj6upBgPJAx/v+ZPD3w8k4VSWP8/nXifIusj5r0m8q8zJKx
/VLejY0ZOnl+M6ybbECa8+l28o9sfhaoF9aXxyQJ1ltbQirSZFEqueqg+AQcweWL
8xCf0hjbYz2x/XgFNJ0UPa8+RIhYvXGsU7GRve0f+aF8/6/seVrMvMgVCaNKTt5u
ha7Hn1s00q873zh4cfCQajMxyK0ZNByYvyjTfdw2a3ztdh5dEMnBKICl1WDEJMv3
jlydbc+ZKpr2kmpC0C0NOWwpIymRgwssnjNFDqWPNnwFZA3Ib+EBYtqGMV55o8vD
UwYh0x5uVoa8JjTXEPTW
=69K1
-----END PGP SIGNATURE-----

--PPYy/fEw/8QCHSq3--
