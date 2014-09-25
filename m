Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaIYHhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:37:08 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59013 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIYHhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:37:05 -0400
Date: Thu, 25 Sep 2014 09:37:01 +0200
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
Subject: Re: [PATCH v2 15/22] MIPS/Xlr/MSI: Use MSI chip framework to
 configure MSI/MSI-X irq
Message-ID: <20140925073700.GL12423@ulmo>
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
 <1411614872-4009-16-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrM5Z5VIJgwP9LWp"
Content-Disposition: inline
In-Reply-To: <1411614872-4009-16-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nrM5Z5VIJgwP9LWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 11:14:25AM +0800, Yijing Wang wrote:
[...]
> diff --git a/arch/mips/pci/pci-xlr.c b/arch/mips/pci/pci-xlr.c
[...]
> @@ -214,11 +214,11 @@ static int get_irq_vector(const struct pci_dev *dev)
>  }
> =20
>  #ifdef CONFIG_PCI_MSI
> -void arch_teardown_msi_irq(unsigned int irq)
> +void xlr_teardown_msi_irq(unsigned int irq)
>  {
>  }
> =20
> -int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
> +int xlr_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)

Can both of these now be static?

Thierry

--nrM5Z5VIJgwP9LWp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI8YcAAoJEN0jrNd/PrOhmbYP/ikLBs/f/C3q0Ah+1wm0yIQ9
biLioTIcSkRAsIfmKvheDIwFqrlfVwxThhAFT1+1x9N/KgeZ0hTm7/ZzogCQEn9J
J90nv0Y1KRdY/exT1wfgVEFtITGMGqDKTScawCJSoqc/4iswAtYkap3QdftgmyDU
acFImPmiT5rTaF3oQXhgNTgRcMMsdGOYJg/64K0snGcBGCNDYr4ZutMiEzof/G7O
w5KUk61xP+tvpYWRebsG/ivvFVWXNwVnpAOPAq+j6ziVxLlFLvY/r7QZ0Z95kSTj
AqufUg6h2cePrzW3VGxKJ5HL0eLS43pMofUkRFqcNv/BEeE8ZEg5wd2mNCtAroXb
fG5+KClUrEYZ28WO5d7Bagvekb00O2SYJ6HQW9WoASguiLfMMGa0g9w8SxmES0Gv
axepd0VObagoL/0lUjvSs73S39kzWsShRysZ9hCEsox1Xt3kinX3wwIP+k97dsKC
LAyXKNzxzU5xtlsZONRwRx2SsBRnUApH6CgDE5SOBgSAM+Juuk/e4NES7iTHW1iA
7DrbU7XWcMc/SLbIanZv3gig1WuNUR011kUZ9cerQpTMZ5JX+pR/f59jbtgexuEt
2lqvEs5pj2RZfiZy+pl21B1hMz7UPuQm8Hw0NMsXQP9wPcDwLzYAqT7uhHdaBhLV
4rVgrCyYNcw+4+MK/Nhv
=crca
-----END PGP SIGNATURE-----

--nrM5Z5VIJgwP9LWp--
