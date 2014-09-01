Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaIAKZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:25:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:36458 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbaIAKZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:25:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="584511186"
Message-ID: <1409567105.30155.49.camel@linux.intel.com>
Subject: Re: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
 chipset info struct
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Date: Mon, 01 Sep 2014 13:25:05 +0300
In-Reply-To: <20140901091607.GH7374@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408705096-31286-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140901091607.GH7374@lee--X1>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 10:16 +0100, Lee Jones wrote:
> On Fri, 22 Aug 2014, Andy Shevchenko wrote:
> 
> > Introduce additional struct to hold chipset info. This chipset
> > info will be used to store features that are supported by specific
> > processor or chipset. LPC_SCH supports SMBUS, GPIO and WDT features.
> > As this code base might expand further to support more processors,
> > this implementation will help to keep code base clean and manageable.
> > 
> > Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[]


> The first patch would look a great deal cleaner if it had these
> changes in too.  Unless you have a really good reason not to, please
> consider squashing them.

The only reason behind is that this patch (in other form) was written by
Rebecca in the first place. I recommended to clean up before, and
actually did that clean up and amended Rebecca's patch.

So, if Rebecca has now objections I could squash it.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

