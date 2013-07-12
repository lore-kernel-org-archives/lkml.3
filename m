Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab3GLRPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:15:41 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42508 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3GLRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:15:38 -0400
Date: Fri, 12 Jul 2013 10:15:30 -0700
From: Thierry Reding <thierry.reding@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
Message-ID: <20130712171529.GA9620@dhcp-172-17-186-34.nvidia.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <20130711154121.GC2198@dhcp-172-17-186-34.nvidia.com>
 <000301ce7e8e$4b7d9420$e278bc60$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <000301ce7e8e$4b7d9420$e278bc60$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2013 at 08:28:05AM +0900, Jingoo Han wrote:
> On Friday, July 12, 2013 12:41 AM, Thierry Reding wrote:
> > On Thu, Jul 11, 2013 at 02:49:43PM +0900, Jingoo Han wrote:
> > [...]
> > > diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
> > [...]
> > >  obj-$(CONFIG_PCI_MVEBU) +=3D pci-mvebu.o
> > >  obj-$(CONFIG_PCIE_DW) +=3D pcie-designware.o
> > > +obj-$(CONFIG_PCI_EXYNOS) +=3D pcie-exynos.o
> >=20
> > I think we should keep these sorted alphabetically. Also Tegra and
> > Marvell are PCIe controllers but they still use the pci- prefix instead
> > of pcie-. Perhaps it'd be good to keep consistency here? I initially
> > chose pci- because from a software point of view it doesn't matter all
> > that much whether it's PCI or PCIe and because the drivers are part of
> > the PCI subsystem. However if Exynos now uses the pcie- prefix it makes
> > it look like Tegra and Marvell are plain old PCI.
> >=20
>=20
> Hi Thierry,
>=20
> I initially chose 'pci-' prefix such as 'pci-designware.c'.
>=20
> However, Pratyush Anand suggested as below:
> "I would suggest to rename it as pcie-designware.c,
> because synopsis pcie and pci controllers are different."
>=20
> If you have a good idea, please give it to me. :)

Alternatively the plain old PCI variant could be suffixed -legacy or
similar, but I guess pcie- as a prefix works okay in this case.

However I still think you should sort them properly:

	obj-$(CONFIG_PCIE_DW) +=3D pcie-designware.o
	obj-$(CONFIG_PCI_EXYNOS) +=3D pci-exynos.o
	obj-$(CONFIG_PCI_MVEBU) +=3D pci-mvebu.o

Thierry

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJR4DmxAAoJEN0jrNd/PrOhGOQP/imUsGAyq5MAn4zc9TdGO3hP
bMgEV2mNaq+VQp7y8BmV+LOaFQW4JfPZQBV0P+De75dce2eO7ZoYq8wIObXGLxt7
9AcZOMSJFeyUixJ9WzP24ZpHJSej7kwytMPGgATphdRBS7epOMSvZTT7jwW9sfQL
ajzmcGpYDh7gH1kW7WrGhpfcrQ/9AdhM5PoswgSHw//HCENNpXgpZrcHHacvDZD9
/YU9U4bzQXnAjKZ641fAZUKh0VOhJVrdeSWQATCIB2aQ1jKCJKYa3uiEjftiQRtK
oJJJAJF+5+8ZzNkzDerBAPmLBhzonPrkjXUryY5J5zA3a31jG5sEwZmcmauGlExx
y3ajrFYdQ8JR4da/JTuc6Epnrixi7JSiCBuC8fwKE8uhhGje3TlDkgBlaPjgzPrP
w6KS2XySrlW87slBFztakY+e9rL2pzoMb3VUxsDlTslSD4jO3dNPYa69uSSjT5bd
LdqnkLvfE7OZLaTM16MHIs03CWNamd5zikfaUcQtAGjtjdjo2uen8fUdViDG8AZQ
rpJvJkiwrZ/aqWAWCirjPIiWb5Xupn+RpMzY8U16e14NioDJoLWmwacqKhtBPo1/
09Msm/2Ffev79pNEGTX05FwdgFGLd9s6m2Bjqwx8XY/uQOEkdlv8DjTlkQy/o5Li
OPjO4ADhaF1QVHP0wqXv
=tPL6
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
