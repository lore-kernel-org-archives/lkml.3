Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbbALKJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:09:48 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54068 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbbALKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:09:46 -0500
Date: Mon, 12 Jan 2015 11:01:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 05/16] pci: introduce common pci config space accessors
Message-ID: <20150112100131.GA27700@ulmo>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
 <1420857290-8373-6-git-send-email-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1420857290-8373-6-git-send-email-robh@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 08:34:39PM -0600, Rob Herring wrote:
> Many PCI controllers' configuration space accesses are memory mapped
> varying only in address calculation and access checks. There are 2 main
> access methods: a decoded address space such as ECAM or a single address
> and data register similar to x86. This implementation can support both
> cases as well as be used in cases that need additional pre or post access
> handling.
>=20
> A new pci_ops member map_bus is introduced which can do access checks and
> any necessary setup. It returns the address to use for the configuration
> space access. The access types supported are 32-bit only accesses or
> correct byte, word, or dword sized accesses.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/access.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/pci.h  | 11 +++++++
>  2 files changed, 98 insertions(+)

Reviewed-by: Thierry Reding <treding@nvidia.com>
Tested-by: Thierry Reding <treding@nvidia.com>

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUs5t7AAoJEN0jrNd/PrOhpIQP/3QkOnAM62rtzWKkbvYGSvFw
wZyOfZPsp411pZdJKBV0fo2tCZmb3MFEdNhSGMIucSvB3bO1VJMQuuqunLbJGGvB
7/GVJi1zmz242nrkKMbCVcuSCozAk3lFnUdzwpU3ADl28EV5jwGHFjIYGSiOqqLR
fJLE0KhPdAoq/p7vkesP+FG1tVsVyiTNXPc3BnktNpHJxEpQoujJG+hRX8cTA7G8
FPLV12rdUt93Ahi9PlYPKrDfEjoZHvqlxUiG50dBVirebI2wl2xyYkp52/nmqFhD
fHzAy9aG+d86MakONP74ps6EFfKvs0ZzbJ0Y/MizdjMfCj8NKvqU5+oMec9DiNtn
eXim41gZxSIO0kKBomFkKTq6Ja9qP0vJ+5gRSitqSCsUrb1uA+YXNXJItMYpqttp
HzoHxHc8BqqJkmYsBCBvwT8AamFRVJNIi0dwcgGukv2UDrPy1HJcfiQTG4XTZO7b
YpOqxtvuNf9KWFVDnQiJar3W633Tn6e45YwJFgHVw2qbud+AXwRo5ypssDcPI59G
WCdaCjOzCP1Jnxc8kWOy0NVYZXdGo+mgbSp0PiwjEuxLEL0+eG9qxMmI5snYXad5
ywiHQ+FaNfFjjlwV7p9VbKCpSpnpwMl4iSIIaP7rmrWjIfIY1GBb6DEMHjgECseb
tFqCmTti4cXQHJVua6UP
=A6kk
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
