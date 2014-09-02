Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaIBAOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:14:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:59431 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaIBAOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:14:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,445,1406617200"; 
   d="scan'208";a="584790065"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Ahmad, Josef" <josef.ahmad@intel.com>
Subject: RE: [PATCH v1 3/5] pci_ids: add support for Intel Quark ILB
Thread-Topic: [PATCH v1 3/5] pci_ids: add support for Intel Quark ILB
Thread-Index: AQHPw5VxmNfvjdD8nk6yIqKzleCHy5vrfN0AgAGA4RA=
Date: Tue, 2 Sep 2014 00:14:18 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBCF5EF@PGSMSX108.gar.corp.intel.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408705096-31286-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAErSpo42SMnWrTJceuR1cdhUU7rwiBgSHD75k4rwKkaC6sc5JQ@mail.gmail.com>
 <1409562842.30155.45.camel@linux.intel.com>
In-Reply-To: <1409562842.30155.45.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s820EUCb008949



> -----Original Message-----
> From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> Sent: 01 September, 2014 5:14 PM
> To: Bjorn Helgaas
> Cc: Lee Jones; linux-kernel@vger.kernel.org; Samuel Ortiz; Chang, Rebecca
> Swee Fun; Ahmad, Josef
> Subject: Re: [PATCH v1 3/5] pci_ids: add support for Intel Quark ILB
> 
> On Fri, 2014-08-29 at 08:27 -0600, Bjorn Helgaas wrote:
> > On Fri, Aug 22, 2014 at 4:58 AM, Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > From: Josef Ahmad <josef.ahmad@intel.com>
> > >
> > > This patch adds the PCI id for Intel Quark ILB.
> > > It will be used for GPIO and Multifunction device driver.
> > >
> > > Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > Assuming that this will actually be used in more than one place:
> 
> Yes, look for the other IDs in the same driver (lpc_sch).
> 
> The question is will we have the update for sch_gpio in time to be included to
> v3.18? I think Rebecca can answer to this one.

Yes, we are working on updating sch_gpio but I can't give you a confirm answer whether it will be included in v3.18. Sch_gpio has been scheduled as my 2nd priority work currently. However, I will try to make it in time if possible.

Rebecca
> 
> >
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> >
> > > ---
> > >  include/linux/pci_ids.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h index
> > > 6ed0bb7..4e82195 100644
> > > --- a/include/linux/pci_ids.h
> > > +++ b/include/linux/pci_ids.h
> > > @@ -2557,6 +2557,7 @@
> > >  #define PCI_DEVICE_ID_INTEL_MFD_EMMC0  0x0823  #define
> > > PCI_DEVICE_ID_INTEL_MFD_EMMC1  0x0824
> > >  #define PCI_DEVICE_ID_INTEL_MRST_SD2   0x084F
> > > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB    0x095E
> > >  #define PCI_DEVICE_ID_INTEL_I960       0x0960
> > >  #define PCI_DEVICE_ID_INTEL_I960RM     0x0962
> > >  #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB      0x0c60
> > > --
> > > 2.1.0
> > >
> 
> 
> --
> Andy Shevchenko <andriy.shevchenko@intel.com> Intel Finland Oy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
