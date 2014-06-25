Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaFYJ0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:26:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:17341 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaFYJ0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="560661653"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Index: AQHPj6/C5BxdJArRXUevrLYTW6T4oZuBj0uw
Date: Wed, 25 Jun 2014 09:26:05 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E946EF1@SHSMSX101.ccr.corp.intel.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
 <20140624132527.GB1215@kroah.com>
In-Reply-To: <20140624132527.GB1215@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, June 24, 2014 9:25 PM
> To: Chen, Alvin
> Cc: Alan Stern; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Ong,
> Boon Leong
> Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel Quark
> X1000
> 
> On Tue, Jun 24, 2014 at 08:51:43AM -0700, Chen, Alvin wrote:
> > diff --git a/drivers/usb/host/pci-quirks.c
> > b/drivers/usb/host/pci-quirks.c index 00661d3..1ea8803 100644
> > --- a/drivers/usb/host/pci-quirks.c
> > +++ b/drivers/usb/host/pci-quirks.c
> > @@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask,
> u32 done,
> >  	return -ETIMEDOUT;
> >  }
> >
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +bool usb_is_intel_qrk(struct pci_dev *pdev) {
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(usb_is_intel_qrk);
> 
> There is no lack of vowels available to you, please use them.
> 

OK, I will change ' usb_is_intel_qrk ' to ' usb_is_intel_quark'.

> greg k-h
