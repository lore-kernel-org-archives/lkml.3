Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3GKHFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:05:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16645 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3GKHFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:05:52 -0400
X-AuditID: cbfee691-b7fef6d000002d62-58-51de594fa5ff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, Seungwon Jeon <tgih.jun@samsung.com>,
        "'Yulgon Kim'" <yulgon.kim@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <001201ce7dfa$716b3370$54419a50$@samsung.com>
 <51DE5359.90905@ti.com>
In-reply-to: <51DE5359.90905@ti.com>
Subject: Re: [PATCH V2] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Thu, 11 Jul 2013 16:05:50 +0900
Message-id: <000001ce7e05$13ab4210$3b01c630$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMw1eBP/VKXWuT2/qwqXEWC1QeRsgJOdEkSlofmdmA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zI13/yHuBBq9fClj8nXSM3WJJU4bF
	y0OaFpcXXmK16F1wlc3iwtMeNovLu+awWZydd5zNYsb5fUwWG6f+YrRov6Rs8eH+RWaLxqMP
	WC1anzxgtOg4e5Ddgd/j969JjB4LNpV6fF84n92jb8sqRo+nP/Yyexy/sZ3J4/MmuQD2KC6b
	lNSczLLUIn27BK6ML1s/sBdsFqzYsP0NYwPjSr4uRk4OCQETiUPffjJC2GISF+6tZ+ti5OIQ
	EljGKLF4wT0WmKKD9/oZIRLTGSVer+9nh3B+MUp8fv8YrIpNQE3iy5fD7CC2iICOxMLT65lB
	ipgF3jBL3Fr8DWyHkECwRNubB6wgNqeAisTCx73MILawQKLEv5UP2EBsFgFViU0P/oEN4hWw
	lNi5cRUbhC0o8WMyxEnMAloS63ceZ4Kw5SU2r3nLDHGqgsSOs68ZIY6wkmjeex+qXkRi34t3
	YC9ICGzhkJjee4AZYpmAxLfJh4CKOIASshKbDkDNkZQ4uOIGywRGiVlIVs9CsnoWktWzkKxY
	wMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkPUzcwXj/gPUhxmSg9ROZpUST84HpJa8k
	3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjFlc+rNm
	3z32L/uxm8j8V7yyzv9kZ3mmyn8odjBe/tR6mXe78Vcx6Vt5J08+qZ/Y2vGe4e+hMkOZP3sV
	/giFZtcIn067xrOOMeb//vuHf648L81z31HRJKb9fmb8ecP6KTqHnvpc/Lz36H6J3E1P+/Wl
	+z9ovJi9I7g69PpMQ7d704/0ega6nFdiKc5INNRiLipOBAAMLDzJJQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQV3/yHuBBj1/uCz+TjrGbrGkKcPi
	5SFNi8sLL7Fa9C64ymZx4WkPm8XlXXPYLM7OO85mMeP8PiaLjVN/MVq0X1K2+HD/IrNF49EH
	rBatTx4wWnScPcjuwO/x+9ckRo8Fm0o9vi+cz+7Rt2UVo8fTH3uZPY7f2M7k8XmTXAB7VAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q1UoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjC9bP7AXbBas2LD9DWMD40q+LkZO
	DgkBE4mD9/oZIWwxiQv31rN1MXJxCAlMZ5R4vb6fHcL5xSjx+f1jFpAqNgE1iS9fDrOD2CIC
	OhILT69nBiliFnjDLHFr8TewUUICwRJtbx6wgticAioSCx/3MoPYwgKJEv9WPmADsVkEVCU2
	PfgHNohXwFJi58ZVbBC2oMSPyffAljELaEms33mcCcKWl9i85i0zxKkKEjvOvmaEOMJKonnv
	fah6EYl9L94xTmAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GMHJ55n0DsZVDRaHGAU4GJV4eBvi7wYKsSaWFVfmHmKU4GBWEuF18rkXKMSbklhZlVqUH19U
	mpNafIgxGejTicxSosn5wMSYVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2M+VmSn5LOZwndL4/Y48qwY0nYl+grbH5GC863/6/9LZcfrawV77Fl/tmr128z
	c0pcT5I03+i7WjU5/vVvr9dn/vOIL2ZRs3dK3NWVN+/Ilp5vK8X839uLeta4L+W28dp8mr3M
	4E920oV3URc6HJRm+88P1T+/rvTfv/y73toJ6jsPF+qkb12vxFKckWioxVxUnAgAM6MDp4ID	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 11, 2013 3:40 PM, Kishon Vijay Abraham I wrote:
> On Thursday 11 July 2013 11:19 AM, Jingoo Han wrote:
> >
> >  drivers/pci/host/Makefile          |    1 +
> >  drivers/pci/host/pcie-designware.c |  963 +++++++++---------------------------
> >  drivers/pci/host/pcie-designware.h |   71 +++
> >  drivers/pci/host/pcie-exynos.c     |  523 ++++++++++++++++++++
> >  4 files changed, 822 insertions(+), 736 deletions(-)
> >  create mode 100644 drivers/pci/host/pcie-designware.h
> >  create mode 100644 drivers/pci/host/pcie-exynos.c
> >
> > diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
> > index 086d850..7e59864 100644
> > --- a/drivers/pci/host/Makefile
> > +++ b/drivers/pci/host/Makefile
> > @@ -1,2 +1,3 @@
> >  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
> >  obj-$(CONFIG_PCIE_DW) += pcie-designware.o
> > +obj-$(CONFIG_PCI_EXYNOS) += pcie-exynos.o
> > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
[...]
> 
> How about making this a separate driver in itself that does all the
> configurations for designware core? By this I mean we can have a separate dt
> node (child node of soc specific wrapper), that will have all the configuration
> space/IO space and memory space. pci_common_init/dw_pcie_host_init should be
> done in this driver.
> We just need to think about a way of passing the ops (since that looks like
> very much needed because of the sideband bits you have to enable before
> reading/writing).
> 

CC'ed Seungwon Jeon(DW-MMC Maintainer), Yulgon Kim (DW-USB Developer)


Um, maybe you mean dwc3 usb driver (./drivers/usb/dwc3/)'?

But, I referenced dw mmc driver (./drivers/mmc/host/dw_mmc*.c).

Now, Exynos PCIe driver, Spear PCIe driver[1], and i.MX PCIe driver[2]
are submitted to PCIe mailing-list, these are using designware PCIe core.

There are many differences between Exynos PCIe and Spear PCIe.
Also, for Exynos PCIe, platform specific part will be changed more.

Thus, the dw mmc driver model looked more suitable.


[1] http://permalink.gmane.org/gmane.linux.kernel.pci/18400
[2] http://www.spinics.net/lists/linux-pci/msg23489.html


Best regards,
Jingoo Han


