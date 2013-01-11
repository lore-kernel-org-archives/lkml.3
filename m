Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3AKEIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:08:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3AKEIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:08:46 -0500
Date: Fri, 11 Jan 2013 05:08:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/14] ARM: tegra: Move pmc.h to include/mach
Message-ID: <20130111040823.GE28094@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-10-git-send-email-thierry.reding@avionic-design.de>
 <50EF598B.2030307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0ZfoUVt4BxPQnbU"
Content-Disposition: inline
In-Reply-To: <50EF598B.2030307@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3eU7JZ1NYn/vJId/7RUbq65pU663qssUs7ZzUUr6VHu
 zcHjD1MuSj+UV+zs5xLEYWo/Q+kqA3jIQRXF0YzeKi8cEpOphY
 TUzD622mcv0OBrlFjvgYRohi3DF6MXiAPGBKoI1TrFAdPGwNGc
 ykRn3xHXZR9JttPKK5dLNQmVNBBkrHW05FLQ14bQ/Lum3rgUht
 zXM5Xtp49nNXjMnQJMD4t1EeUfVi3GzWyqAGRNCNOd/NVmRaU6
 +So/P0rNCeprj51/5eNItV/SpysKd7M6lPk5k8gZnEDWXkbpzj
 sPvQU0bKOscMsMXv2ZAO4Y+SVgRnv9li3BElspa3zBRkRgq1Bm
 ABNSWJ+rvYE7ky1a+z+m4swvFsI4S7j7GzLH5pdARNihUcjjtz
 WKX9hGP6aL2zH0hp7LCOTiu0nnESX6CcnQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o0ZfoUVt4BxPQnbU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 05:15:07PM -0700, Stephen Warren wrote:
> On 01/09/2013 01:43 PM, Thierry Reding wrote:
> > In preparation for moving the PCIe driver into the drivers/pci/host
> > directory, this header, which contains prototypes that are required by
> > the PCIe driver, needs to be moved to a globally visible location.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > Note that eventually the code in pmc.c and powergate.c should probably
> > be split out into a separate driver. The PMC registers are also directly
> > accessed from tegra20_clocks.c and tegra30_clocks.c, so that it might be
> > required to provide that functionality through the new driver as well.
> > ---
> >  arch/arm/mach-tegra/common.c           |  2 +-
> >  arch/arm/mach-tegra/include/mach/pmc.h | 24 ++++++++++++++++++++++++
> >  arch/arm/mach-tegra/pmc.h              | 24 ------------------------
>=20
> On IRC, we'd talked about putting the public functionality in
> include/linux/tegra-pmc.h so that we wouldn't add to include/mach, which
> would make it harder to make Tegra support ARM multi-platform. Perhaps
> that IRC discussion happened after you posted this series?

I'm not sure, it's equally possible that I just forgot. Will fix it up.

Thierry

--o0ZfoUVt4BxPQnbU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ75A3AAoJEN0jrNd/PrOhUdAP/jx4poxyVjj6V33Sz/v8nlnQ
1U4BlJxgUTOrRfu1h5bgGRRRyRszW8Umdlb8YYJzSwgivam1DMuVyylxuSbseP+T
rokEN5r7XKpzZ4M26HGeOWZN9xi8eQyGyESUN2lPrXjtCYmVleGrOWoWMNtmGiZg
DaA67Jn0a4bqa6IpKOgxvG5Hu7HqgaJXLW87Ht/kCvWIJPM+vkDSM76fygQYwXj1
0h7/zX0yOJlW/yENJA/1CZzaE5CR8xmzcyB2EtmelTLhLpTi0L9rnPvbua1dKyO4
15sQ/6VeHScjKNYh7jNQtTIdouwwLFRUbvdM9dXaxfeKuuW2fSBvci54WbApeXGI
vmGR1iXaF1ObcxDFjBcKkS/UWyU8fU/Tx/CuXRen690wTAZt4irsb0NR8kH432BA
QbfrBYV1b8ytLrnTvqaNMHJHCy3A1FiSJ28ywUyC8daWtWQBTbFa9M3Dh0KaOuNq
1HdIzn7C1YzUgSUJsO5uaWNt3XOMGfJvds1RCFpqAhXvQLklfZA/Nv/Gx4uET62N
BxMUjsqE0oiQzZ+xGnHFH6JbT9M99n7EGAZJ2BG40iUX9TWSoOEqum3zABHCPZ41
ZbsJ5FN+MMd7scYeV5fQY0Fl+JCEbzzS4XNH7RUrl0/ulTWQgEGZ7SXdZaf3ZnDf
aXb7TNK63K0pUTsgpniV
=ykwn
-----END PGP SIGNATURE-----

--o0ZfoUVt4BxPQnbU--
