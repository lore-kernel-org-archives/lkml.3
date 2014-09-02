Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaIBHZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:25:23 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62710 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaIBHZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:25:21 -0400
Date: Tue, 2 Sep 2014 08:25:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Cc: "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
 chipset info struct
Message-ID: <20140902072516.GB17117@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <20140901091607.GH7374@lee--X1>
 <1409567105.30155.49.camel@linux.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBD15FE@PGSMSX108.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50B33AC5ED75F74F991980326F1C438D0FBD15FE@PGSMSX108.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, Chang, Rebecca Swee Fun wrote:

> 
> 
> > -----Original Message-----
> > From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> > Sent: 01 September, 2014 6:25 PM
> > To: Lee Jones
> > Cc: Bjorn Helgaas; linux-kernel@vger.kernel.org; Samuel Ortiz; Chang, Rebecca
> > Swee Fun
> > Subject: Re: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
> > chipset info struct
> > 
> > On Mon, 2014-09-01 at 10:16 +0100, Lee Jones wrote:
> > > On Fri, 22 Aug 2014, Andy Shevchenko wrote:
> > >
> > > > Introduce additional struct to hold chipset info. This chipset info
> > > > will be used to store features that are supported by specific
> > > > processor or chipset. LPC_SCH supports SMBUS, GPIO and WDT features.
> > > > As this code base might expand further to support more processors,
> > > > this implementation will help to keep code base clean and manageable.
> > > >
> > > > Signed-off-by: Chang Rebecca Swee Fun
> > > > <rebecca.swee.fun.chang@intel.com>
> > > > Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > []
> > 
> > 
> > > The first patch would look a great deal cleaner if it had these
> > > changes in too.  Unless you have a really good reason not to, please
> > > consider squashing them.
> > 
> > The only reason behind is that this patch (in other form) was written by
> > Rebecca in the first place. I recommended to clean up before, and actually did
> > that clean up and amended Rebecca's patch.
> > 
> > So, if Rebecca has now objections I could squash it.
> 
> I have no objections. Thanks.

Thanks Rebecca.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
