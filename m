Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaH2LAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:00:50 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55896 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaH2LAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:00:48 -0400
Date: Fri, 29 Aug 2014 12:00:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH v1 0/5] mfd: lpc_sch: Intel Quark support
Message-ID: <20140829110043.GJ24579@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1409306274.30155.30.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409306274.30155.30.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014, Andy Shevchenko wrote:

> On Fri, 2014-08-22 at 13:58 +0300, Andy Shevchenko wrote:
> > This brings support of the LPC SCH device found on Intel Quark SoC. Patches
> > were compile tested, and driver runs on actual hardware.
> > 
> > Please, note that PCI ID will be used in future in the gpio-sch driver.
> 
> Bjorn, could you Ack or comment patch 3/5?
> 
> Lee, do you have any comments on the series?

I have marked them as 'important' and will get round to them when I
can.  This week has been hectic.  I will get round to it next week.

> > Andy Shevchenko (4):
> >   mfd: lpc_sch: reduce duplicate code
> >   mfd: lpc_sch: better code manageability with chipset info struct
> >   mfd: lpc_sch: Add support for Intel Quark X1000
> >   mfd: lpc_sch: remove FSF address
> > 
> > Josef Ahmad (1):
> >   pci_ids: add support for Intel Quark ILB
> > 
> >  drivers/mfd/lpc_sch.c   | 207 ++++++++++++++++++++++++++++--------------------
> >  include/linux/pci_ids.h |   1 +
> >  2 files changed, 122 insertions(+), 86 deletions(-)
> > 
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
