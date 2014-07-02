Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbaGBAe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:34:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28395 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaGBAeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:34:50 -0400
X-AuditID: cbfee690-b7fb56d000003439-55-53b353a8d6c7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Chen, Alvin'" <alvin.chen@intel.com>
Cc: "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Boon Leong Ong'" <boon.leong.ong@intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404227734-14825-2-git-send-email-alvin.chen@intel.com>
 <Pine.LNX.4.44L0.1407011009240.874-100000@iolanthe.rowland.org>
In-reply-to: <Pine.LNX.4.44L0.1407011009240.874-100000@iolanthe.rowland.org>
Subject: Re: [PATCH v4] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Date: Wed, 02 Jul 2014 09:34:48 +0900
Message-id: <000d01cf958d$6dcaac40$496004c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+VNoIRuBzEm+xGQGeYQMYaSI2ungAVsPCw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY90VwZuDDbZclLV4s3MFo8WT9YvY
	LC4vvMRqcXnXHDaLRctamS3OrLrFbjHh9wU2B3aPB1P/M3ks3vOSyWP23R+MHn1bVjF6fN4k
	F8AaxWWTkpqTWZZapG+XwJWxa/liloIPAhVrHj5ga2A8x9vFyMkhIWAicWdTOzOELSZx4d56
	NhBbSGAZo8TZhUYwNb82zQOq4QKKT2eU2H6qmRXC+c0oMaPtKiNIFZuAmsSXL4fZQWwRgTCJ
	9i8H2UCKmAVOMEosb/vGAtHRxihx+kofUDsHB6eAj8STT2EgDcICURIvPj4GO4NFQFXi+Npz
	YGfwCthKnDg0kxnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCAjJQTUJR791YW4wUii9eZP
	ZogSEYl9L94xgpwgIfCRXWJf+3qoXQIS3yYfYoHolZXYdAAaEpISB1fcYJnAKDELyeZZSDbP
	QrJ5FpIVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExO+EHYz3DlgfYkwGWj+RWUo0
	OR8Y/3kl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wCjK7L75Let6q18HV39J3LU64t3DKKlrHsdW/V5lt2h3VPr0OFOz02uz5Ge+LTtkFHB4idD+
	Sa9edt+e2zf9Uv0m9mlXLr9ke7jl5rPWmie12+99+2LiEb5Ies1V1hPLeA3f3TGL87vAXvT4
	vcDB5nOBvq6zVDVb85JyFx35vnyFwBUm141BfRszlViKMxINtZiLihMBPT1g5PUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd0VwZuDDT4ekrR4s3MFo8WT9YvY
	LC4vvMRqcXnXHDaLRctamS3OrLrFbjHh9wU2B3aPB1P/M3ks3vOSyWP23R+MHn1bVjF6fN4k
	F8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0
	h5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY9fyxSwFHwQq1jx8wNbA
	eI63i5GTQ0LAROLXpnnMELaYxIV769m6GLk4hASmM0psP9XMCuH8ZpSY0XaVEaSKTUBN4suX
	w+wgtohAmET7l4NgHcwCJxgllrd9Y4HoaGOUOH2lD6idg4NTwEfiyacwkAZhgSiJFx8fg61j
	EVCVOL72HBuIzStgK3Hi0ExmCFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jKDjJQQUJd49FcX
	4gYjidabP5khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIEp4dnUjsYVzZYHGIU4GBU4uGNuLspWIg1say4MvcQowQHs5IIbzzP5mAh3pTE
	yqrUovz4otKc1OJDjKZAj05klhJNzgemrrySeENjEzMjSyMzCyMTc3Mlcd4DrdaBQgLpiSWp
	2ampBalFMH1MHJxSDYxzlQT5KvxDoiz3CTf59jr0TPJknriwc4763ht87tLqNtvDvr56cUKW
	XdVtptfn4KTo/MvvzvR6hX+X0Tz+7JyNfM3eXWtVKvUFnnCc7FComH6nRL/aJHb67D4xwYmn
	/3uK6X7cOuuHu9fxRfe6TGtOLbtluLclN/PB5CldHtqatzx7TrEJv1FiKc5INNRiLipOBAD4
	xQNKJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2014 11:12 PM, Alan Stern wrote: 
> On Tue, 1 Jul 2014, Chen, Alvin wrote:
> 
> > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> >
> > The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000
> > USB host controller, and the default value is 0x20 dwords. The in/out threshold
> > can be programmed to 0x80 dwords (512 Bytes) to maximize the perfomrance,
> > but only when isochronous/interrupt transactions are not initiated by the USB
> > host controller. This patch is to reconfigure the packet buffer in/out
> > threshold as maximal as possible to maximize the performance, and 0x7F dwords
> > (508 Bytes) should be used because the USB host controller initiates
> > isochronous/interrupt transactions.
> >
> > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> There's one error in the style...
> 
> > diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> > index 3e86bf4..429434d 100644
> > --- a/drivers/usb/host/ehci-pci.c
> > +++ b/drivers/usb/host/ehci-pci.c
> > @@ -35,6 +35,21 @@ static const char hcd_name[] = "ehci-pci";
> >  #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
> >
> >  /*-------------------------------------------------------------------------*/
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
> > +{
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +}
> > +
> > +/*
> > +	* 0x84 is the offset of in/out threshold register,
> > +	* and it is the same offset as the register of 'hostpc'.
> > +	*/
> 
> This comment isn't formatted right.  It should be like this:
> 
> /*
>  * blah blah blah
>  * blah blah blah
>  */
> 
> If you want to submit a corrected version, you can.  Or Greg may be
> willing to fix the style when he merges this patch.
> 
> Alan Stern


