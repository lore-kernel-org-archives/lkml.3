Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaIYHiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:38:09 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38511 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaIYHiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:38:06 -0400
Date: Thu, 25 Sep 2014 09:38:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-arch@vger.kernel.org,
        arnab.basu@freescale.com, Bharat.Bhushan@freescale.com, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 17/22] s390/MSI: Use MSI chip framework to configure
 MSI/MSI-X irq
Message-ID: <20140925073800.GM12423@ulmo>
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
 <1411614872-4009-18-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W4pDZ/VvazBYHhxQ"
Content-Disposition: inline
In-Reply-To: <1411614872-4009-18-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W4pDZ/VvazBYHhxQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 11:14:27AM +0800, Yijing Wang wrote:
[...]
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
[...]
> @@ -358,7 +358,7 @@ static void zpci_irq_handler(struct airq_struct *airq)
>  	}
>  }
> =20
> -int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
> +int zpci_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)

static?

--W4pDZ/VvazBYHhxQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI8ZYAAoJEN0jrNd/PrOhT54QAIN9jc2i8zDFXQP0O2xLX151
K/0a6f2Ke1ts4th35u5jkXxtnjEubc8RMuU2k+Dft0pOk1wQqfi7CmdJtG+MrGqI
IZ78syU0TLzw2I2IhhCW/qIrc0eK9gcVpY5FnYxNGNsErYVOHB5w2lqj65UXkrK1
KuKTi4wk7SBfs7D0I7UVe9CjiGte3h4Wkm0FExDPekBjlb+NheufDExalF1vv5VW
Y/Ers3FW9kjTCLWHf+wS7Sg7a/uq8PfTG3hkn7ja7ykCouBoheB+pb1OmV5boizz
/H9TvN+P3WCd3TCe0pz5qI8icntR/5V09HiM3OM1sGqwWopvZgKiw8RSXwJMKdb3
4NsDxyu6glUOMpuFyDxzQ+iC94LeTq1L4C4oTfrdMdCQetJQm1DxWQYo4iPy1Luz
cyWf37Gr7RoNuPlx++ONPfub8xDPP6LpDm7Jf1ztIuHNRnN0D/EYNP/3W6s2en4w
0n4URoSBn7blmJQPOKQ+oNkw295vAc0bSU+NlqjdnpMhJq/Aq+olHB4Of97IKXtk
7lLqyJAX6ISNs302AVES9Wch7UW6MWrlpxiQk3HkGZBvFExbGCTD806d0wr9+V9Y
XcvfTABfe5ycOd28a4HwZx0BpglxbMRwarqwdwhpA9H0500K4lmTPrzZLVY+B0AB
UxhsWg3u+nU6NtiAWuwY
=lpw6
-----END PGP SIGNATURE-----

--W4pDZ/VvazBYHhxQ--
