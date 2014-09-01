Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaIALko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:40:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:57293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbaIALkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,442,1406617200"; 
   d="scan'208";a="566551154"
Message-ID: <1409571613.30155.57.camel@linux.intel.com>
Subject: Re: [PATCH v1 0/5] mfd: lpc_sch: Intel Quark support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Date: Mon, 01 Sep 2014 14:40:13 +0300
In-Reply-To: <20140829110043.GJ24579@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1409306274.30155.30.camel@linux.intel.com>
	 <20140829110043.GJ24579@lee--X1>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 12:00 +0100, Lee Jones wrote:
> On Fri, 29 Aug 2014, Andy Shevchenko wrote:
> 
> > On Fri, 2014-08-22 at 13:58 +0300, Andy Shevchenko wrote:
> > > This brings support of the LPC SCH device found on Intel Quark SoC. Patches
> > > were compile tested, and driver runs on actual hardware.
> > > 
> > > Please, note that PCI ID will be used in future in the gpio-sch driver.
> > 
> > Bjorn, could you Ack or comment patch 3/5?
> > 
> > Lee, do you have any comments on the series?
> 
> I have marked them as 'important' and will get round to them when I
> can.  This week has been hectic.  I will get round to it next week.

Thanks for your comments. I will fix everything we agreed about and send
v2. For now I'm waiting for Rebecca's comment regarding to squashing
patch 1/5 and 2/5.

> 
> > > Andy Shevchenko (4):
> > >   mfd: lpc_sch: reduce duplicate code
> > >   mfd: lpc_sch: better code manageability with chipset info struct
> > >   mfd: lpc_sch: Add support for Intel Quark X1000
> > >   mfd: lpc_sch: remove FSF address
> > > 
> > > Josef Ahmad (1):
> > >   pci_ids: add support for Intel Quark ILB
> > > 
> > >  drivers/mfd/lpc_sch.c   | 207 ++++++++++++++++++++++++++++--------------------
> > >  include/linux/pci_ids.h |   1 +
> > >  2 files changed, 122 insertions(+), 86 deletions(-)
> > > 
> > 
> > 
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

