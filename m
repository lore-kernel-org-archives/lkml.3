Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaGHMUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:20:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11080 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaGHMUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:20:34 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-e9-53bbe20f0b1d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Murali Karicheri'" <m-karicheri2@ti.com>,
        "'Mohit KUMAR DCG'" <Mohit.KUMAR@st.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush ANAND'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
 <1404164720-11066-3-git-send-email-m-karicheri2@ti.com>
 <2CC2A0A4A178534D93D5159BF3BCB661A17A3E4291@EAPEX1MAIL1.st.com>
 <53BAD07C.2010302@ti.com>
In-reply-to: <53BAD07C.2010302@ti.com>
Subject: Re: [PATCH v3 2/5] PCI: designware: refactor MSI code to work with
 v3.65 dw hardware
Date: Tue, 08 Jul 2014 21:20:30 +0900
Message-id: <000e01cf9aa7$02425030$06c6f090$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+aBB3ySCMOBZdSSuK0D9+VGJUjyQAorKdQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSfSzUcRzH973fwz00/Dx/Y1HXIw157Nui9U/bb2ttqdZaa+nwC+Fcd5j+
	KYlT5ikq7bJDSzl3MkcoMWHOKvKwYblZnYeKOxrCcIr71ebf/nt/P9/3+/t6f7cPD7P7TLjw
	YsSJjFQsihOSAvzD+qSPl42h6eyhXzVCZC7o5KJnadHoR5sHKunoIVCesYxArWuNAPVMqQAa
	KOsnUO9ENokG3hSTqFupI9HIgBXKzWklkVF+G6DyoT4Oqnm4AlB+URWOMvt3ozGFPTLpi3CU
	0dzBRdO5Guy4E61RagCdfiebpFdXCgA9kJvDoZWKLpxeb8/j0KXaJFr1YoGkays8aW3lPZLW
	D74l6dy6SkBPLDdjtG64gUPPa91O21wUBEcycTHJjNTn2BVBtP53Dlei809ZfDCFpQL9gSzA
	50EqAL4vKSRY7QR7R6vJLCDg2VHPASyeN3D/mUxNKpy9eApgufIllz2sAlhStWSJk9Q+uLDQ
	bkk4UOehIa2c2DRhlIGAn3oz/747AqB+yQw2XfyNxE+53KLtqTA42z6Bb2qc2gsnv+ktcysq
	BM51GElW28LlwlGLB6M8YfVrHYfV7rBWY8KyAG+j635oMHuxJfxgT+YMwVocYMv3GbDZAVJP
	+FAzd5dkWRRcLGzD2ewOqG3F2C9vh+8qhvF8ABVbyIotZMUWsmILohTglcCRkURIZOFRUl9v
	mSheliSO8o5IiNcCdq9yGsFI69E2ELGBv4+5OEYkbOydODHM1z/IDwUGBPr7HT4S9H9jobNV
	+NfwM3ZUlCiRiWUYCSMNkybFMbI2wOHxXVLBwatDuHrNteFmCqG27Q72sK5KdrvuXH9y27XB
	yFu1k+S55WHaJw6l6nbVVb6q5zd7jjRecL00H9O3mH5Z3jHeYjzKiQ3oDCmats7oiiy7ERpa
	OjZ7as9Mw7C75pGQUy9uj3q8ExedME0z3eWqRisYqzZ3h89r1eNfPOQqv49mIS6LFvl6YlKZ
	6A87KSWKbQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xgC7fo93BBsd2G1v8nXSM3WJJU4bF
	y0OaFvOPnGO16H+zkNXiwJ8djBbnXq1ktLi88BKrxYWnPWwWl3fNYbM4O+84m8Xty7wWfb0H
	2CzetDUyWiy9fpHJYuPUX4wWE6avZbFov6Rs8XiWsMXbO9NZLFr3HmG3eN23htlBzGPNvDWM
	Hi3NPWwev39NYvS43NfL5DFv1gkWj3+H+5k8Fmwq9Vi5/Aubx+YVWh6bVnWyedy5tofNo2/L
	KkaPpz/2Mnscv7GdyePzJrkA/qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
	JYW8xNxUWyUXnwBdt8wcoO+VFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1
	jBl3/veyFxw3rvg25RVzA+MdjS5GTg4JAROJt7tXskDYYhIX7q1n62Lk4hASWMQosXTeOnYI
	5zejxPy131lBqtgE1CS+fDnMDmKLCIRJPGpaygpSxCzwiFXi/IV2qPbbjBJ3vv9lBKniBOr4
	0NYGZgsLxEu8P/wUbB+LgKrEs+d3wOK8ArYSn468YYOwBSV+TL4HVsMsoCWxfudxJghbXmLz
	mrfMXYwcQLeqSzz6qwtxhJHEufZ3rBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYKT4TOpHYwrGywOMQpwMCrx8K44uCtYiDWxrLgy9xCj
	BAezkgjvl1O7g4V4UxIrq1KL8uOLSnNSiw8xmgI9OpFZSjQ5H5io80riDY1NzIwsjcwsjEzM
	zZXEeQ+0WgcKCaQnlqRmp6YWpBbB9DFxcEo1MJ6ZFHPI990LLr8L6f1BOzYIebr6fN/7cJaY
	T9CTacZcqoULN9hYL14obHjC4sGx6nNVKvGCKZv65icU1s+/95Z9w6fClWt4OZ13fko/duCE
	3OkDW1p+TtzarbxXIfCiNONynedaYnsf7vo9TVewvzJr1tON+3qVa+ScooNvq7C+POV9/OED
	i7dKLMUZiYZazEXFiQBYK8OxnAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2014 1:53 AM, Murali Karicheri wrote:
> On 07/07/2014 12:17 AM, Mohit KUMAR DCG wrote:
> > On Tuesday, July 01, 2014 3:15 AM, Murali Karicheri wrote:
> >>
> >> Keystone PCI controller is based on v3.65 version of the DW PCI h/w that
> >> implements MSI controller registers in application space compared to the
> >> newer version. This requires updates to the DW core API to support the PCI
> >> controller driver based on this old DW hardware. Add msi_irq_set()/clear()
> >> API functions to allow Set/Clear MSI IRQ enable bit in the application register.
> >> Also the old h/w uses MSI_IRQ register in application register space to raise
> >> MSI IRQ to the RC from EP. Current code uses the standard mechanism as
> >> per PCI spec. So add another API get_msi_data() to get the address of this
> >> register so that common code can be re-used on old h/w.
> >>
> >> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> >>
> >> CC: Santosh Shilimkar<santosh.shilimkar@ti.com>
> >> CC: Russell King<linux@arm.linux.org.uk>
> >> CC: Grant Likely<grant.likely@linaro.org>
> >> CC: Rob Herring<robh+dt@kernel.org>
> >> CC: Mohit Kumar<mohit.kumar@st.com>
> >> CC: Jingoo Han<jg1.han@samsung.com>
> >> CC: Bjorn Helgaas<bhelgaas@google.com>
> >> CC: Pratyush Anand<pratyush.anand@st.com>
> >> CC: Richard Zhu<r65037@freescale.com>
> >> CC: Kishon Vijay Abraham I<kishon@ti.com>
> >> CC: Marek Vasut<marex@denx.de>
> >> CC: Arnd Bergmann<arnd@arndb.de>
> >> CC: Pawel Moll<pawel.moll@arm.com>
> >> CC: Mark Rutland<mark.rutland@arm.com>
> >> CC: Ian Campbell<ijc+devicetree@hellion.org.uk>
> >> CC: Kumar Gala<galak@codeaurora.org>
> >> CC: Randy Dunlap<rdunlap@infradead.org>
> >> CC: Grant Likely<grant.likely@linaro.org>
> >> ---
> >>   drivers/pci/host/pcie-designware.c |   50 ++++++++++++++++++++++++++-
> >> ---------
> >>   drivers/pci/host/pcie-designware.h |    3 +++
> >>   2 files changed, 39 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
> >> designware.c
> >> index d8f3af7..905941c 100644
> >> --- a/drivers/pci/host/pcie-designware.c
> >> +++ b/drivers/pci/host/pcie-designware.c
> >> @@ -217,27 +217,47 @@ static int find_valid_pos0(struct pcie_port *pp, int
> >> msgvec, int pos, int *pos0)
> >>   	return 0;
> >>   }
> >>
> >> +static void dw_pcie_msi_clear_irq(struct pcie_port *pp, int irq) {
> >> +	unsigned int res, bit, val;
> >> +
> >> +	res = (irq / 32) * 12;
> >> +	bit = irq % 32;
> >> +	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4,&val);
> >> +	val&= ~(1<<  bit);
> >> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val); }
> >> +
> >>   static void clear_irq_range(struct pcie_port *pp, unsigned int irq_base,
> >>   			    unsigned int nvec, unsigned int pos)  {
> >> -	unsigned int i, res, bit, val;
> >> +	unsigned int i;
> >>
> >>   	for (i = 0; i<  nvec; i++) {
> >>   		irq_set_msi_desc_off(irq_base, i, NULL);
> >>   		clear_bit(pos + i, pp->msi_irq_in_use);
> >>   		/* Disable corresponding interrupt on MSI controller */
> >> -		res = ((pos + i) / 32) * 12;
> >> -		bit = (pos + i) % 32;
> >> -		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> >> 4,&val);
> >> -		val&= ~(1<<  bit);
> >> -		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> >> 4, val);
> >> +		if (pp->ops->msi_clear_irq)
> >> +			pp->ops->msi_clear_irq(pp, pos + i);
> >> +		else
> >> +			dw_pcie_msi_clear_irq(pp, pos + i);
> >>   	}
> >>   }
> >>
> >> +static void dw_pcie_msi_set_irq(struct pcie_port *pp, int irq) {
> >> +	unsigned int res, bit, val;
> >> +
> >> +	res = (irq / 32) * 12;
> >> +	bit = irq % 32;
> >> +	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4,&val);
> >> +	val |= 1<<  bit;
> >> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val); }
> >> +
> >>   static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)  {
> >> -	int res, bit, irq, pos0, pos1, i;
> >> -	u32 val;
> >> +	int irq, pos0, pos1, i;
> >>   	struct pcie_port *pp = sys_to_pcie(desc->dev->bus->sysdata);
> >>
> >>   	if (!pp) {
> >> @@ -281,11 +301,10 @@ static int assign_irq(int no_irqs, struct msi_desc
> >> *desc, int *pos)
> >>   		}
> >>   		set_bit(pos0 + i, pp->msi_irq_in_use);
> >>   		/*Enable corresponding interrupt in MSI interrupt controller
> >> */
> >> -		res = ((pos0 + i) / 32) * 12;
> >> -		bit = (pos0 + i) % 32;
> >> -		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> >> 4,&val);
> >> -		val |= 1<<  bit;
> >> -		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> >> 4, val);
> >> +		if (pp->ops->msi_set_irq)
> >> +			pp->ops->msi_set_irq(pp, pos0 + i);
> >> +		else
> >> +			dw_pcie_msi_set_irq(pp, pos0 + i);
> >>   	}
> >>
> >>   	*pos = pos0;
> >> @@ -353,7 +372,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip,
> >> struct pci_dev *pdev,
> >>   	 */
> >>   	desc->msi_attrib.multiple = msgvec;
> >>
> >> -	msg.address_lo = virt_to_phys((void *)pp->msi_data);
> >> +	if (pp->ops->get_msi_data)
> >> +		msg.address_lo = pp->ops->get_msi_data(pp);
> >> +	else
> >> +		msg.address_lo = virt_to_phys((void *)pp->msi_data);
> >>   	msg.address_hi = 0x0;
> >>   	msg.data = pos;
> >>   	write_msi_msg(irq,&msg);
> >> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-
> >> designware.h
> >> index 8121901..387f69e 100644
> >> --- a/drivers/pci/host/pcie-designware.h
> >> +++ b/drivers/pci/host/pcie-designware.h
> >> @@ -67,6 +67,9 @@ struct pcie_host_ops {
> >>   			unsigned int devfn, int where, int size, u32 val);
> >>   	int (*link_up)(struct pcie_port *pp);
> >>   	void (*host_init)(struct pcie_port *pp);
> >> +	void (*msi_set_irq)(struct pcie_port *pp, int irq);
> >> +	void (*msi_clear_irq)(struct pcie_port *pp, int irq);
> >> +	u32 (*get_msi_data)(struct pcie_port *pp);
> >>   };
> >>
> >>   int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> >
> > - Now MSI specific dw code can be shared b/w old Synopsys controller (ver<  3.70)
> > and newer controller that standardize the MSI settings inside design ware core itself.
> >
> > Jingoo,
> >
> > Pls let us know if you have any concern or comment over this.
> >
> > Acked-by: Mohit Kumar<mohit.kumar@st.com>
> >
> > Regards
> > Mohit
> >
> >> --
> >> 1.7.9.5
> >
> Mohit,
> 
> Thanks.
> 
> Jingoo, could you provide your response or Ack?

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> Thanks
> --

