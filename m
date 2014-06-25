Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaFYBKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:10:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49024 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaFYBKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:10:46 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-04-53aa2194371b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chen, Alvin'" <alvin.chen@intel.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Boon Leong Ong'" <boon.leong.ong@intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
In-reply-to: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel Quark
 X1000
Date: Wed, 25 Jun 2014 10:10:43 +0900
Message-id: <000301cf9012$49d34f70$dd79ee50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+PgeFF1YiaX9w6Qmu3xxWSJImwAAAj3wJQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI90piquCDSZc5LR4s3MFo8WT9YvY
	LJoXr2ezuLzwEqvF5V1z2CwWLWtltpjw+wKbA7vH4j0vmTz2z13D7jH77g9Gj74tqxg9Pm+S
	C2CN4rJJSc3JLEst0rdL4Mp4+mEOa8Ek2YrfN86zNTD+Fu9i5OSQEDCR6G66zgRhi0lcuLee
	rYuRi0NIYBmjxIfmrUwwRX2rtrJDJBYxSkzZtIcRwvnNKPH7dA9YFZuAmsSXL4fZQWwRAS2J
	3RsuM4LYzALvGSXmNZmD2EIC9RK7mk4yg9icAq4SX1qWs4DYwgLhEi/m9bCB2CwCqhLX5i4C
	6+UVsJX4tGULE4QtKPFj8j0WiJlaEut3HmeCsOUlNq95CzSTA+hSdYlHf3UhTjCSeL5hEtQJ
	IhL7XrwDu1lC4CW7xJLPi5khdglIfJt8iAWiV1Zi0wFmiIclJQ6uuMEygVFiFpLNs5BsnoVk
	8ywkKxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECInfiTsY7x+wPsSYDLR+IrOUaHI+
	MP7zSuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGx
	WdYi4eLlWz5WLw2WdNidqd8cHLztWmhG/g7tDaWG5+4HvNwjxmCYb9m/Qs7p5Qs3yYsOqy0O
	yT7brByYozlb/Nmy5IC8vAflZjtWNx3PNS9Y28q7tPK9gatxpuX53StX8bysOaPspcLzpOOC
	hXP2hgscxS+mZP18v7xq18c9Ihs/+9RM81qgxFKckWioxVxUnAgA2jqFmfUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd0piquCDZpfsFq82bmC0eLJ+kVs
	Fs2L17NZXF54idXi8q45bBaLlrUyW0z4fYHNgd1j8Z6XTB77565h95h99wejR9+WVYwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMePphDmvBJNmK3zfOszUw
	/hbvYuTkkBAwkehbtZUdwhaTuHBvPVsXIxeHkMAiRokpm/YwQji/GSV+n+5hAqliE1CT+PLl
	MFiHiICWxO4NlxlBbGaB94wS85rMQWwhgXqJXU0nmUFsTgFXiS8ty1lAbGGBcIkX83rYQGwW
	AVWJa3MXgfXyCthKfNqyhQnCFpT4MfkeC8RMLYn1O48zQdjyEpvXvAWayQF0qbrEo7+6ECcY
	STzfMAnqBBGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjByeGZ9A7GVQ0WhxgFOBiVeHgvzF4ZLMSaWFZcmXuIUYKDWUmE99VroBBvSmJlVWpR
	fnxRaU5q8SFGU6BHJzJLiSbnAxNXXkm8obGJmZGlkZmFkYm5uZI478FW60AhgfTEktTs1NSC
	1CKYPiYOTqkGxh6NLeI9SoXXfSL9N9tky7u3P2NbWvFv8ySTisn6y23KbLN7RRhYG5i6TFq3
	h/+9t+ZbdNfDT4Y1HyNNBB9HP63o8nOt8mE4ceTSn9VhC1i25t168Ke8nulHfIuxzrI12Qvv
	iz9oPxtn/tRCtMsh5qdXC8sy63ieaYIhjw0qPat6G+bve7ZPiaU4I9FQi7moOBEAAYAdKiQD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 25, 2014 12:52 AM, Alvin Chen wrote:
> 
> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> This patch is to enable USB host controller for Intel Quark X1000. Add pci quirks
> to adjust the packet buffer in/out threshold value, and ensure EHCI packet buffer
> i/o threshold value is reconfigured to half.

Please add more detailed description. For example, why is it necessary to
reconfigure the threshold value?

> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
>  drivers/usb/host/ehci-pci.c   |    4 ++++
>  drivers/usb/host/pci-quirks.c |   42 +++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/pci-quirks.h |    2 ++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..33cfa23 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -50,6 +50,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  	if (!retval)
>  		ehci_dbg(ehci, "MWI active\n");
> 
> +	/* Reset the threshold limit */
> +	if(unlikely(usb_is_intel_qrk(pdev)))
> +		usb_set_qrk_bulk_thresh(pdev);
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 00661d3..1ea8803 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
>  	return -ETIMEDOUT;
>  }
> 
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +bool usb_is_intel_qrk(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +
> +}
> +EXPORT_SYMBOL_GPL(usb_is_intel_qrk);
> +
> +#define EHCI_INSNREG01		0x84
> +#define EHCI_INSNREG01_THRESH	0x007F007F	/* Threshold value */

What does this magic number mean?
Would you make it more readable?

> +void usb_set_qrk_bulk_thresh(struct pci_dev *pdev)
> +{
> +	void __iomem *base, *op_reg_base;
> +	u8 cap_length;
> +	u32 val;
> +
> +	if (!mmio_resource_enabled(pdev, 0))
> +		return;
> +
> +	base = pci_ioremap_bar(pdev, 0);
> +	if (base == NULL)
> +		return;
> +
> +	cap_length = readb(base);
> +	op_reg_base = base + cap_length;
> +
> +	val = readl(op_reg_base + EHCI_INSNREG01);
> +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
> +
> +	val = EHCI_INSNREG01_THRESH;
> +
> +	writel(val, op_reg_base + EHCI_INSNREG01);
> +
> +	val = readl(op_reg_base + EHCI_INSNREG01);
> +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);

As Alan Stern said, These INFO message are noisy.
DEBUG level looks better.

Best regards,
Jingoo Han

> +
> +	iounmap(base);
> +
> +}
> +EXPORT_SYMBOL_GPL(usb_set_qrk_bulk_thresh);
> +
>  /*
>   * Intel's Panther Point chipset has two host controllers (EHCI and xHCI) that
>   * share some number of ports.  These ports can be switched between either
> diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
> index c622ddf..617c22b 100644
> --- a/drivers/usb/host/pci-quirks.h
> +++ b/drivers/usb/host/pci-quirks.h
> @@ -14,6 +14,8 @@ void usb_amd_quirk_pll_enable(void);
>  void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev);
>  void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
>  void sb800_prefetch(struct device *dev, int on);
> +bool usb_is_intel_qrk(struct pci_dev *pdev);
> +void usb_set_qrk_bulk_thresh(struct pci_dev *pdev);
>  #else
>  struct pci_dev;
>  static inline void usb_amd_quirk_pll_disable(void) {}
> --
> 1.7.9.5

