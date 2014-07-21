Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaGUBoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:44:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32996 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaGUBob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:44:31 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-03-53cc707cde96
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>,
        "'Rob Herring'" <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com>
 <1405696469-7172-5-git-send-email-m-karicheri2@ti.com>
 <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
 <53C9839C.5090604@ti.com>
In-reply-to: <53C9839C.5090604@ti.com>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
Date: Mon, 21 Jul 2014 10:44:28 +0900
Message-id: <006001cfa485$4f4fcff0$edef6fd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+ixyFs0Br5ziMPQJmpASfft7CzZgBviTgg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t8zQ92agjPBBj07rSz+TjrGbrGkKcPi
	5SFNi/43C1ktDvzZwWhx7tVKRovLCy+xWlx42sNmsenxNVaLy7vmsFmcnXeczeL2ZV6Lvt4D
	bBZv2hoZLZZev8hksXHqL0aLCdPXsli0X1K2eDxL2OLtneksFq17j7BbfP/2jc1BzGPNvDWM
	Hi3NPWwev39NYvS43NfL5DFv1gkWj3+H+5k8ds66y+6xYFOpx8rlX9g8Nq/Q8ti0qpPN4861
	PUDeknqPvi2rGD2e/tjL7HH8xnamAMEoLpuU1JzMstQifbsEroxr1zMLfvBXLL78ja2BcSVP
	FyMnh4SAicSS7w9YIGwxiQv31rN1MXJxCAksY5TYcWs/O0xR45Pr7BCJRYwSP08fgnJ+M0p8
	WvKCGaSKTUBN4suXw2AdIgKhEi+OLQcbxSxwj1Xi+JM/UHPvMUq8mvmeDaSKE6jj24WrYN3C
	Ap4SXxZsBTuERUBVYsOV40A2BwevgK3EsgUWIGFeAUGJH5PvgZUwC6hLTJq3iBnClpfYvOYt
	M0i5BFD80V9diBuMJK427GCFKBGR2PfiHSPICRICszklZl5uYYZYJSDxbfIhFoheWYlNB5gh
	PpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMj
	JGn17WC8ecD6EGMy0PqJzFKiyfnApJdXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhgN9rK5HxBcndypUCJkzaQov++wlUpVFo9LfePzl49C9ZvW
	pzFNjlzoXbxM9uBtWxlGYS125tlileockkEZGRs4mQ10HrqE2Mp/bJifuV57keVy3gabpsUL
	xCbGbdrIdlnIJtzrI6vpho9vXrbMPVezvOz4pGPlaht+z9Sc/r6z3iw76ILZSSWW4oxEQy3m
	ouJEAGrROgVwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSe0hTURzHObvb3VVcXafWwX8at7e1cmvqibKCHp6oyHxED2jd5mUbuUe7
	Kr2g2ZPMTC0TR4mVWdp6aZG9RJepYIW5UqEclD0srKCWmVp0t1VInb++vy/fz5dzDj+KkOeS
	kZTRnMHZzGw6QwaLW3/20Mqd1gfJ0V0vZqEfhU1SVL7bgN65pqIjfackqH64FqBH7ysBcp9q
	l6C217kkqu7pkCD3rRMkeljaTKJnbhnKO1xPor792QCd7XwsQleLBgHKL74oRgfax6MeRxj6
	8LxYjPbdbZSib/395IIx2FnqBHjvnlwSDw0WAuzOOyzCpY4WMf5574gI33R0S3FZdSauPOcl
	cc35KFxddZDEzzvuCFP5Lpx3rQrg1wN3CdzcdUOUGLrODuYaODaNsyk4s86SZjTr45llydqF
	2pjYaJVSNRvFMQoza+LimUXLE5VLjOnCFzCKLDY9U7ASWZ5nZs77vyE1ZYkS/QHXKFekJP1l
	1NH/nI2XgKGj02gdGL31jLuftIPKkBwQREFaA7NfdUoDegxs81wmc0AwJadPA/i91SUNDEMA
	fi7vJXwpkp4Evd57fiKcToW9Tef8BEF7JLD51fBv3APg+5JPpC8VJBD9bU/9dBi9FHrLrot9
	WkxPhFeeNAuaomR0PKwoQz5bRofCgaMef4SgJ8PC0tNEQI+DNc4PhC8OBf/lD2XgDmr41F4r
	CUTCYV3vR5AP5I4RTY4RTY4RTY4RSBkQV4EIzqqz8pv0JtUMnjXxmWb9DJ3FVA38m/gmshZU
	2pEL0BRgQmQYPEiWS9gsfpvJBSBFMOGyFoNgydLYbds5m0Vry0zneBeIEd5ZQERG6CzCXpsz
	tKpZmlj1bHUsUmvi4pixsvp9c1bJaT2bwW3mOCtn+8OJqKBIOyg+rteYh0q8m+5svz+25uTn
	JMuGC5M2xjCHtmqXH7TD/K5jpDe1a96EAmNDI3E7a7A1ryhBVzf/SgIIq2AXh2LdSvrr+t3D
	TWsb6zviWrqdc9pDEt62Fs+MmpbkUVAlnKYA7njzZUqPIntUH1uxfmj6/S2rrzO7Rqes6SYn
	5jQ4GTFvYFVRhI1nfwEWQf1KnwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 19, 2014 5:29 AM, Murali Karicheri wrote:
> On 07/18/2014 03:31 PM, Rob Herring wrote:
> > On Fri, Jul 18, 2014 at 10:14 AM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
> --- Cut ---
> >> +
> >> +Optional properties:-
> >> +       phys: phandle to Generic Keystone SerDes phy for PCI
> >> +       phy-names: name of the Generic Keystine SerDes phy for PCI
> >> +         - If boot loader already does PCI link establishment, then phys and
> >> +           phy-names shouldn't be present.
> >> +       ti,enable-linktrain - Enable Link training.
> >> +         - If boot loader already does PCI link establishment, then this
> >> +           shouldn't be present.
> >
> > Can't you read from the h/w if the link is trained?

I agree with Rob Herring's suggestion.

> 
> Yes.
> 
> There are customers who use this driver with PCI Link setup done in the
> boot loader. This property tells the driver to bypass Link setup
> procedure in that case. Is this undesirable and if so. how other
> platforms handle it? Check first if link is trained or start the link
> setup procedure? Let me know. If this is fine, please provide your Ack.

Please, check the following code of Exynos PCIe diver.

./drivers/pci/host/pci-exynos.c

static int exynos_pcie_establish_link(struct pcie_port *pp)
{
	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
	void __iomem *elbi_base = exynos_pcie->elbi_base;
	void __iomem *pmu_base = exynos_pcie->pmu_base;

	if (dw_pcie_link_up(pp)) {
		dev_err(pp->dev, "Link already up\n");
		return 0;
	}
	.....

In the case of Exynos PCIe, the Exynos PCIe driver checks the
h/w bit such as PCIE_ELBI_LTSSM_ENABLE bit of PCIE_ELBI_RDLH_LINKUP
offset register.

If the link is already set up by the boot loader or other reasons,
the driver will skip some initialization codes.

The first step is that you find such h/w bit for checking link up.
If so, please add the code for skipping, when the link is already
set up.

Best regards,
Jingoo Han

