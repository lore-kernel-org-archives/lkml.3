Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3GKPld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:41:33 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:65036 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3GKPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:41:31 -0400
Date: Thu, 11 Jul 2013 08:41:22 -0700
From: Thierry Reding <thierry.reding@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
Message-ID: <20130711154121.GC2198@dhcp-172-17-186-34.nvidia.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
In-Reply-To: <001201ce7dfa$716b3370$54419a50$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 11, 2013 at 02:49:43PM +0900, Jingoo Han wrote:
[...]
> diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
[...]
>  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
>  obj-$(CONFIG_PCIE_DW) += pcie-designware.o
> +obj-$(CONFIG_PCI_EXYNOS) += pcie-exynos.o

I think we should keep these sorted alphabetically. Also Tegra and
Marvell are PCIe controllers but they still use the pci- prefix instead
of pcie-. Perhaps it'd be good to keep consistency here? I initially
chose pci- because from a software point of view it doesn't matter all
that much whether it's PCI or PCIe and because the drivers are part of
the PCI subsystem. However if Exynos now uses the pcie- prefix it makes
it look like Tegra and Marvell are plain old PCI.

Thierry

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJR3tIhAAoJEN0jrNd/PrOhCCMP/iGDcDc81Sii7T3D2sYloq4s
uzIcMm0j0eVD2q6B3vPjZRSV7KiMMLxRHw3HeKGSlLc5xNXGquacI3uh2MImqe1K
f6Zb6F52DvuzJ1c2Y2yWqzYTEA+X80T/zb2i0fM5R4dB4Ijf0V+R1dFpV0+IWR9x
S2BJM9dHJ9xrWZ1tf6h+oBFPq0bq5QTNfB5V8j6GkG9SCC8fnvsfPTa8jh5zkv2k
jiN28T4vAiRj8Xn67X47SZ3bfdvqBUQpKE9i35+F5pULF9K1d9oxqIRLzRMd7hw6
TLpYv09h7fMhHjfOp9kGA9jf9CFbiIM795RmEfgEcsqoRX+wd0cltmGkb3Pt2Cai
edB9RF6aXWO1CYrdDF4JRa3OyjZqlSgmWW0rHR6lBlyTFW57FK4OdFUe/wzBUOyD
996hU8vi33vCkLwSKerKi1CC9qpoq7SVxGoB+JcGzBZIuZIQVjBkGssGPMLJhswf
vFmujloMw62uSsw4Yb+T6+qYdxb+shKdlY7Ml7aX/RelhWO5K0FpKxCWa/cc6/UF
i696/K1xFO9Xkm8sQa+bi9/Prql01p8bL+Hq+bymco/tIfC/rK2DsgoXHRPFHie0
X23RiKHxUDMr1pOMiYjUG3a721Z4YdL86P6X8n57R5l3yDRYwKex+lN0AeSt+9O/
R8YFMVAW6NYbfZiS72y5
=ezQU
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
