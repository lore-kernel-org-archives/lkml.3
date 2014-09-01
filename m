Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaIAJOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:14:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:39355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbaIAJOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:14:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="584485350"
Message-ID: <1409562842.30155.45.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] pci_ids: add support for Intel Quark ILB
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Josef Ahmad <josef.ahmad@intel.com>
Date: Mon, 01 Sep 2014 12:14:02 +0300
In-Reply-To: <CAErSpo42SMnWrTJceuR1cdhUU7rwiBgSHD75k4rwKkaC6sc5JQ@mail.gmail.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408705096-31286-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAErSpo42SMnWrTJceuR1cdhUU7rwiBgSHD75k4rwKkaC6sc5JQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 08:27 -0600, Bjorn Helgaas wrote:
> On Fri, Aug 22, 2014 at 4:58 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > From: Josef Ahmad <josef.ahmad@intel.com>
> >
> > This patch adds the PCI id for Intel Quark ILB.
> > It will be used for GPIO and Multifunction device driver.
> >
> > Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Assuming that this will actually be used in more than one place:

Yes, look for the other IDs in the same driver (lpc_sch).

The question is will we have the update for sch_gpio in time to be
included to v3.18? I think Rebecca can answer to this one.

> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> > ---
> >  include/linux/pci_ids.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 6ed0bb7..4e82195 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2557,6 +2557,7 @@
> >  #define PCI_DEVICE_ID_INTEL_MFD_EMMC0  0x0823
> >  #define PCI_DEVICE_ID_INTEL_MFD_EMMC1  0x0824
> >  #define PCI_DEVICE_ID_INTEL_MRST_SD2   0x084F
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB    0x095E
> >  #define PCI_DEVICE_ID_INTEL_I960       0x0960
> >  #define PCI_DEVICE_ID_INTEL_I960RM     0x0962
> >  #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB      0x0c60
> > --
> > 2.1.0
> >


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

