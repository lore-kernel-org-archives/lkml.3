Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaF0EdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:33:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8490 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0EdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:33:07 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-dd-53acf401955b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chen, Alvin'" <alvin.chen@intel.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>,
        "'David Laight'" <David.Laight@ACULAB.COM>,
        "'Boon Leong Ong'" <boon.leong.ong@intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403868276-12558-1-git-send-email-alvin.chen@intel.com>
 <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
In-reply-to: <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
Subject: Re: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Date: Fri, 27 Jun 2014 13:33:04 +0900
Message-id: <000401cf91c0$e3a98600$aafc9200$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+Rt9/9zWiRva72R+WEYUnwzn5RXwABGaNA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zA13GL2uCDVouGlu82bmC0eLJ+kVs
	FjuWbmayaF68ns3i8sJLrBaXd81hs1i0rJXZ4syqW+wWE35fYHPg9OifPYXN48HU/0wei/e8
	ZPLYP3cNu8fsuz8YPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj9dt/zAUX1StevatvYFyp
	0MXIySEhYCJxe/JTJghbTOLCvfVsXYxcHEICyxgl+va3AyU4wIoetYZCxBcxSuw8uJQVwvnN
	KNG0qJ8VpJtNQE3iy5fD7CC2iECYxNmFT5hBbGaBlUwSk2/pgNhCAvUSs7rPgNVwCrhKnN17
	ggXEFhaIkmjt7QCLswioSqzqeMsMsphXwFbieosFSJhXQFDix+R7LBAjtSTW7zzOBGHLS2xe
	A1EuIaAu8eivLsQFRhJbFl5ngygRkdj34h0jyMkSAq0cEjvb57JCrBKQ+Db5EAtEr6zEpgPM
	kHCQlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cT
	IyTCe3cw3j5gfYgxGWj9RGYp0eR8YILIK4k3NDYzsjA1MTU2Mrc0I01YSZw36WFSkJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQZGO8ddt9xv3HmodK+s591ugTW+twVqLbeVra16WfNnY0V3
	zyLn/DP+q+z8lvouuKG11/n/0bb8c1YX501tVPazUTa9/nj6n1rFdA230xePr56QadYVsXrD
	7S1Jq5dZMZY1yJ+Zd3DqsiPrVYvszDzjT90X9twT5FqXpLtee6nhjhdfDY2nun3lV2Ipzkg0
	1GIuKk4EACskq5wGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAV3GL2uCDda907N4s3MFo8WT9YvY
	LHYs3cxk0bx4PZvF5YWXWC0u75rDZrFoWSuzxZlVt9gtJvy+wObA6dE/ewqbx4Op/5k8Fu95
	yeSxf+4ado/Zd38wevRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QbUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjNVv/zEXXFSvePWuvoFxpUIXIweHhICJxKPW0C5GTiBTTOLCvfVsXYxcHEICixgl
	dh5cygrh/GaUaFrUzwpSxSagJvHly2F2EFtEIEzi7MInzCA2s8BKJonJt3RAbCGBeolZ3WfA
	ajgFXCXO7j3BAmILC0RJtPZ2gMVZBFQlVnW8ZQY5glfAVuJ6iwVImFdAUOLH5HssECO1JNbv
	PM4EYctLbF4DUS4hoC7x6K8uxAVGElsWXmeDKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBk
	WcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnD6eSe9gXNVgcYhRgINRiYe3w2tNsBBrYllx
	Ze4hRgkOZiUR3pf3gEK8KYmVValF+fFFpTmpxYcYTYH+nMgsJZqcD0xteSXxhsYmZkaWRmYW
	Ribm5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGFtmXXCXq5s5h1fe4pHT7tJDXwOMpFON
	TU4UXA1TjTzroTpf4pB6g5ue/9UqQzPv0BdBs7dleKS+E3UPm9f4ZpWy+zKbs90vp007tnD2
	Qv+nWg/Cl6umnOBdt3n33GjxS33aouW7v4q9SqtWyejccYuZ4aiHar34xzlH37fMvGypuUnX
	TlxtohJLcUaioRZzUXEiAHuJB541AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2014 8:25 PM, Alvin Chen wrote:
> 
> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000 USB host
> controller, and the default value is 0x20 dwords. The in/out threshold can be programmed
> to 0x80 dwords, but only when isochronous/interrupt transactions are not initiated by
> the USB host controller. This patch is to reconfigure the packet buffer in/out threshold
> as maximal as possible, and it is 0x7F dwords since the USB host controller initiates
> isochronous/interrupt transactions.

So, what is the reason to set the value as 0x80?
  1. The default value 0x20 makes some problems such as...
  2. To maximize the performance, ...
  3. Both
Please add the reason why 0x80 is necessary, as possible.

Then, 0x7F means 508 bytes? 'Intel Quark X1000 USB host controller'
can support 0x80 (512bytes), however, in this case, isochronous/interrupt
transactions cannot be initiated by 'Intel Quark X1000 USB host controller'.
Right?

So, 0x79 (508bytes?) should be used, because the isochronous/interrupt
transactions can be initiated by 'Intel Quark X1000 USB host controller'.
Right?

> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
> changelog v2:
> *Change the function name from 'usb_is_intel_qrk' to 'usb_is_intel_quark_x1000'.
> *Move the functions 'usb_is_intel_quark_x1000' and 'usb_set_qrk_bulk_thresh'
>  from 'pci-quirks.c' to 'ehci-pci.c'.
> *Remove unnecessary kernel message in the function of 'usb_set_qrk_bulk_thresh'.
> *Remove 'unlikely' in the functions of 'ehci_pci_reinit'.
> *Add white space after 'if'.
> *Update the descriptions to make it more clearly.
> *Add Micros to avoid magic number.
> 
>  drivers/usb/host/ehci-pci.c |   45 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..ca29f34 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -35,6 +35,47 @@ static const char hcd_name[] = "ehci-pci";
>  #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
> 
>  /*-------------------------------------------------------------------------*/
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +static inline bool usb_is_intel_quark_x1000(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +

Please don't add this unnecessary line.

> +}
> +
> +/* Register offset of in/out threshold */
> +#define EHCI_INSNREG01		    0x84
> +/* The maximal threshold is 0x80 Dword */
> +#define EHCI_MAX_THRESHOLD      0X80

s/0X80/0x80

0x80 means 512 bytes. So, how about mentioning '0x80 means 512 bytes'
in this comment or the commit message?

Maybe, how about the following?

/* The maximal threshold value is 0x80, which means 512 bytes */
#define EHCI_THRESHOLD_512BYTES		0x80

> +/* Lower word is 'in' threshold, and higher word is 'out' threshold*/
> +#define EHCI_INSNREG01_THRESH \
> +	((EHCI_MAX_THRESHOLD - 1)<<16 | (EHCI_MAX_THRESHOLD - 1))

Um, how about the following?

/* Register offset of in/out threshold */
#define EHCI_INSNREG01			0x84
/* The maximal threshold value is 0x80, which means 512 bytes */
#define EHCI_THRESHOLD_512BYTES		0x80
#define EHCI_THRESHOLD_508BYTES		0x79
#define EHCI_THRESHOLD_OUT_SHIFT		16
#define EHCI_THRESHOLD_IN_SHIFT		0

	......

	/*
	 * In order to support the isochronous/interrupt transactions,
	 * 508 bytes should be used as max threshold values */
	 */
	val = 	((EHCI_THRESHOLD_512BYTES - 1) << EHCI_THRESHOLD_OUT_SHIFT |
		(EHCI_THRESHOLD_512BYTES - 1) << EHCI_THRESHOLD_IN_SHIFT);
	writel(val, op_reg_base + EHCI_INSNREG01);


> +static void usb_set_qrk_bulk_thresh(struct pci_dev *pdev)

Please, use usb_set_qrk_bulk_threshold().
The 'threshold' looks better than 'thresh'.

> +{
> +	void __iomem *base, *op_reg_base;
> +	u8 cap_length;
> +	u32 val;
> +	u16 cmd;
> +
> +	if (!pci_resource_start(pdev, 0))
> +		return;
> +
> +	if (pci_read_config_word(pdev, PCI_COMMAND, &cmd)
> +		|| !(cmd & PCI_COMMAND_MEMORY))
> +		return;
> +
> +	base = pci_ioremap_bar(pdev, 0);
> +	if (base == NULL)
> +		return;
> +
> +	cap_length = readb(base);
> +	op_reg_base = base + cap_length;
> +
> +	val = EHCI_INSNREG01_THRESH;
> +	writel(val, op_reg_base + EHCI_INSNREG01);
> +
> +	iounmap(base);
> +}
> 
>  /* called after powerup, by probe or system-pm "wakeup" */
>  static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
> @@ -50,6 +91,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  	if (!retval)
>  		ehci_dbg(ehci, "MWI active\n");
> 
> +	/* Reset the threshold limit */
> +	if (usb_is_intel_quark_x1000(pdev))
> +		usb_set_qrk_bulk_thresh(pdev);
> +
>  	return 0;
>  }
> 
> --
> 1.7.9.5

