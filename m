Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbbALKEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:04:53 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57256 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbALKEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:04:51 -0500
Date: Mon, 12 Jan 2015 11:04:48 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 05/16] pci: introduce common pci config space accessors
Message-ID: <20150112100447.GB27700@ulmo>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
 <1420857290-8373-6-git-send-email-robh@kernel.org>
 <20150112100131.GA27700@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20150112100131.GA27700@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 11:01:33AM +0100, Thierry Reding wrote:
> On Fri, Jan 09, 2015 at 08:34:39PM -0600, Rob Herring wrote:
> > Many PCI controllers' configuration space accesses are memory mapped
> > varying only in address calculation and access checks. There are 2 main
> > access methods: a decoded address space such as ECAM or a single address
> > and data register similar to x86. This implementation can support both
> > cases as well as be used in cases that need additional pre or post acce=
ss
> > handling.
> >=20
> > A new pci_ops member map_bus is introduced which can do access checks a=
nd
> > any necessary setup. It returns the address to use for the configuration
> > space access. The access types supported are 32-bit only accesses or
> > correct byte, word, or dword sized accesses.
> >=20
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  drivers/pci/access.c | 87 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  include/linux/pci.h  | 11 +++++++
> >  2 files changed, 98 insertions(+)
>=20
> Reviewed-by: Thierry Reding <treding@nvidia.com>
> Tested-by: Thierry Reding <treding@nvidia.com>

Although the subject could use the proper casing: "... common PCI ...".

Thierry

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUs5w/AAoJEN0jrNd/PrOhjGAQAKnq4k3R72rUgCE2MHLuAWGs
gpFxhOw1GiGD63fp1Rpj8fzHKMcobbiNpzCvwKAhHcT1B0gCe7+SDe4+IRbSX1k5
COHcSPFKsXt+wctZ/gXzphcOAGUk95cGiLSERNObHt30dT16/+O7b1O+10lODql8
DbjvBWtZCBhEnU7gfL8DVEaUPrT7QBKFH4Kl9gJr0KhIdDbl97zjwZakG8VLv4p1
v17hhP7okD0CjuWmHa9e3ncnKRRlVylW3y8X4MTyihoLE7QlMLBdrX7j4uL59GRP
xflHuq18W86v5TcGO0sMBjgwzoG2q+CqBWmCatNJESZqYpzVMA04ZlTZCtoBuvp6
lkqm2BlRvKqH9HTiovUTzCdhWK8tZOYn7RFchdylqKzKSVoCuc8jdRIBIZSRwdgE
xrqLLhA/F2+Uv39q6+DvimAjhjhfo6UQeVbhJjOl3xsUbNs2TQT9TKb2zuuZ06Y9
XIxZSTCnVBrCZ7x4l1L5TSnllkIWX/GDr/QRe3gr+zEi5hoWr3+un50pLDNyDB6S
f5xPSVEX4gEj6y2HLJZL25NhmJTrNxnHNkM7YEyZ02WydwPiuGo+hwZbvuR4IvLF
GKIybucnPaZ6XoXPeLpQeP0ngtguSylbTh/16A5KSk0/Cj5VVaD2ea/DdSlmi+es
L4/h+ATK0wqG8K2+5d1X
=d94c
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
