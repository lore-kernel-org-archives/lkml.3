Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaF0Egd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:36:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9153 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaF0Egb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:36:31 -0400
X-AuditID: cbfee68f-b7fef6d000003970-64-53acf4cd82f6
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
 <000401cf91c0$e3a98600$aafc9200$%han@samsung.com>
In-reply-to: <000401cf91c0$e3a98600$aafc9200$%han@samsung.com>
Subject: Re: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Date: Fri, 27 Jun 2014 13:36:29 +0900
Message-id: <000601cf91c1$5d25fcc0$1771f640$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+Rt9/9zWiRva72R+WEYUnwzn5RXwABGaNAAAEzYAA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zA92zX9YEG3z6oGvxZucKRosn6xex
	WexYupnJonnxejaLywsvsVpc3jWHzWLRslZmizOrbrFbTPh9gc2B06N/9hQ2jwdT/zN5LN7z
	kslj/9w17B6z7/5g9OjbsorR4/MmuQD2KC6blNSczLLUIn27BK6MO+t3shds0q9Yv7+RuYHx
	h2oXIyeHhICJxIXdy1ghbDGJC/fWs3UxcnEICSxjlOj7PAEowQFWNPurAkiNkMAiRokVbSwQ
	Nb8ZJWa8f8wMkmATUJP48uUwO4gtIhAmcXbhE7A4s8BKJonJt3QgGjYzSjTP3glWxClgJ7Gl
	7STYZmGBKInW3g6wOIuAqsTpVz9ZQGxeAVuJBTvPsUPYghI/Jt9jgRiqJbF+53EmCFteYvOa
	t8wQh6pLPPqrC3GDlcTfVVuhSkQk9r14xwhyg4RAI4fEuqtTGSF2CUh8m3yIBaJXVmLTAWZI
	QEhKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kR
	EuX9OxjvHrA+xJgMtH4is5Rocj4wSeSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkanHd8rF2hKBnpLNkntr2P1tFR8/E98wwfjFyt0NeU/3VQx
	uMeSInBhsuvuqIe+E37Omyujm2hhqV3/cGmL0N35U5MWbTuYqSk+Tc3789dTXyezK1xf6u59
	WbO2tFXm4uWtTz8IqMlaCcbl6GYJXXpffmulkffSmQHRi63tpMwXeT+IF531qESJpTgj0VCL
	uag4EQCxGUqrCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd2zX9YEG6zq0bR4s3MFo8WT9YvY
	LHYs3cxk0bx4PZvF5YWXWC0u75rDZrFoWSuzxZlVt9gtJvy+wObA6dE/ewqbx4Op/5k8Fu95
	yeSxf+4ado/Zd38wevRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QbUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjDvrd7IXbNKvWL+/kbmB8YdqFyMHh4SAicTsrwpdjJxAppjEhXvr2UBsIYFFjBIr
	2li6GLmA7N+MEjPeP2YGSbAJqEl8+XKYHcQWEQiTOLvwCVicWWAlk8TkWzoQDZsZJZpn7wQr
	4hSwk9jSdpIVxBYWiJJo7e0Ai7MIqEqcfvWTBcTmFbCVWLDzHDuELSjxY/I9FoihWhLrdx5n
	grDlJTavecsMcbS6xKO/uhA3WEn8XbUVqkREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAp5Jr2DcVWDxSFGAQ5GJR7eDq81wUKsiWXFlbmH
	GCU4mJVEeF/eAwrxpiRWVqUW5ccXleakFh9iNAV6dCKzlGhyPjC95ZXEGxqbmBlZGplZGJmY
	myuJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYAyp/lGg6PnoA/O5unkbHQ6tNj+hcvj8rYSO
	fRxCC6/phsZ/9n2qM9PLL5kxXyRO8POlJIe9Z4PO9dUHGXL/yDFeVWT55H1tzJKDqkfnecye
	1R3dfo6lPPpnMqPMbT/DopfmN/l0v75/VKlWq+hhm+lfeOHJOeYDsgaRXl8zexoKopnt9ASZ
	lFiKMxINtZiLihMBhcOfwDcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2014 1:33 PM, Jingoo Han wrote:
> On Friday, June 27, 2014 8:25 PM, Alvin Chen wrote:
> >
> > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> >
> > The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000 USB host
> > controller, and the default value is 0x20 dwords. The in/out threshold can be programmed
> > to 0x80 dwords, but only when isochronous/interrupt transactions are not initiated by
> > the USB host controller. This patch is to reconfigure the packet buffer in/out threshold
> > as maximal as possible, and it is 0x7F dwords since the USB host controller initiates
> > isochronous/interrupt transactions.
> 
> So, what is the reason to set the value as 0x80?
>   1. The default value 0x20 makes some problems such as...
>   2. To maximize the performance, ...
>   3. Both
> Please add the reason why 0x80 is necessary, as possible.
> 
> Then, 0x7F means 508 bytes? 'Intel Quark X1000 USB host controller'
> can support 0x80 (512bytes), however, in this case, isochronous/interrupt
> transactions cannot be initiated by 'Intel Quark X1000 USB host controller'.
> Right?
> 
> So, 0x79 (508bytes?) should be used, because the isochronous/interrupt
> transactions can be initiated by 'Intel Quark X1000 USB host controller'.
> Right?
> 
> >
> > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> > ---
> > changelog v2:
> > *Change the function name from 'usb_is_intel_qrk' to 'usb_is_intel_quark_x1000'.
> > *Move the functions 'usb_is_intel_quark_x1000' and 'usb_set_qrk_bulk_thresh'
> >  from 'pci-quirks.c' to 'ehci-pci.c'.
> > *Remove unnecessary kernel message in the function of 'usb_set_qrk_bulk_thresh'.
> > *Remove 'unlikely' in the functions of 'ehci_pci_reinit'.
> > *Add white space after 'if'.
> > *Update the descriptions to make it more clearly.
> > *Add Micros to avoid magic number.
> >
> >  drivers/usb/host/ehci-pci.c |   45 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >
> > diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> > index 3e86bf4..ca29f34 100644
> > --- a/drivers/usb/host/ehci-pci.c
> > +++ b/drivers/usb/host/ehci-pci.c
> > @@ -35,6 +35,47 @@ static const char hcd_name[] = "ehci-pci";
> >  #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
> >
> >  /*-------------------------------------------------------------------------*/
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +static inline bool usb_is_intel_quark_x1000(struct pci_dev *pdev)
> > +{
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +
> 
> Please don't add this unnecessary line.
> 
> > +}
> > +
> > +/* Register offset of in/out threshold */
> > +#define EHCI_INSNREG01		    0x84
> > +/* The maximal threshold is 0x80 Dword */
> > +#define EHCI_MAX_THRESHOLD      0X80
> 
> s/0X80/0x80
> 
> 0x80 means 512 bytes. So, how about mentioning '0x80 means 512 bytes'
> in this comment or the commit message?
> 
> Maybe, how about the following?
> 
> /* The maximal threshold value is 0x80, which means 512 bytes */
> #define EHCI_THRESHOLD_512BYTES		0x80
> 
> > +/* Lower word is 'in' threshold, and higher word is 'out' threshold*/
> > +#define EHCI_INSNREG01_THRESH \
> > +	((EHCI_MAX_THRESHOLD - 1)<<16 | (EHCI_MAX_THRESHOLD - 1))
> 
> Um, how about the following?
> 
> /* Register offset of in/out threshold */
> #define EHCI_INSNREG01			0x84
> /* The maximal threshold value is 0x80, which means 512 bytes */
> #define EHCI_THRESHOLD_512BYTES		0x80
> #define EHCI_THRESHOLD_508BYTES		0x79
> #define EHCI_THRESHOLD_OUT_SHIFT		16
> #define EHCI_THRESHOLD_IN_SHIFT		0
> 
> 	......
> 
> 	/*
> 	 * In order to support the isochronous/interrupt transactions,
> 	 * 508 bytes should be used as max threshold values */
> 	 */
> 	val = 	((EHCI_THRESHOLD_512BYTES - 1) << EHCI_THRESHOLD_OUT_SHIFT |
> 		(EHCI_THRESHOLD_512BYTES - 1) << EHCI_THRESHOLD_IN_SHIFT);
> 	writel(val, op_reg_base + EHCI_INSNREG01);

Sorry, please refer to the following.

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
	val = 	(EHCI_THRESHOLD_508BYTES << EHCI_THRESHOLD_OUT_SHIFT |
		(EHCI_THRESHOLD_508BYTES << EHCI_THRESHOLD_IN_SHIFT);
	writel(val, op_reg_base + EHCI_INSNREG01);


> 
> 
> > +static void usb_set_qrk_bulk_thresh(struct pci_dev *pdev)
> 
> Please, use usb_set_qrk_bulk_threshold().
> The 'threshold' looks better than 'thresh'.
> 
> > +{
> > +	void __iomem *base, *op_reg_base;
> > +	u8 cap_length;
> > +	u32 val;
> > +	u16 cmd;
> > +
> > +	if (!pci_resource_start(pdev, 0))
> > +		return;
> > +
> > +	if (pci_read_config_word(pdev, PCI_COMMAND, &cmd)
> > +		|| !(cmd & PCI_COMMAND_MEMORY))
> > +		return;
> > +
> > +	base = pci_ioremap_bar(pdev, 0);
> > +	if (base == NULL)
> > +		return;
> > +
> > +	cap_length = readb(base);
> > +	op_reg_base = base + cap_length;
> > +
> > +	val = EHCI_INSNREG01_THRESH;
> > +	writel(val, op_reg_base + EHCI_INSNREG01);
> > +
> > +	iounmap(base);
> > +}
> >
> >  /* called after powerup, by probe or system-pm "wakeup" */
> >  static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
> > @@ -50,6 +91,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
> >  	if (!retval)
> >  		ehci_dbg(ehci, "MWI active\n");
> >
> > +	/* Reset the threshold limit */
> > +	if (usb_is_intel_quark_x1000(pdev))
> > +		usb_set_qrk_bulk_thresh(pdev);
> > +
> >  	return 0;
> >  }
> >
> > --
> > 1.7.9.5

