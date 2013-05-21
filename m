Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3EUMbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:31:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:3793 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3EUMbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:31:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="337584210"
Message-ID: <1369139460.29283.147.camel@smile>
Subject: Re: dmatest regression in 3.10-rc1
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Vinod Koul <vinod.koul@intel.com>, "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.jf.intel.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
Date: Tue, 21 May 2013 15:31:00 +0300
In-Reply-To: <20130520095857.GI31359@mudshark.cambridge.arm.com>
References: <20130515152803.GL23869@mudshark.cambridge.arm.com>
	 <20130516153553.GI11706@mudshark.cambridge.arm.com>
	 <20130517123423.GR14863@intel.com>
	 <20130517141857.GM23112@mudshark.cambridge.arm.com>
	 <1369036354.29283.115.camel@smile>
	 <20130520095857.GI31359@mudshark.cambridge.arm.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 10:58 +0100, Will Deacon wrote: 
> Sure. They way I trigger it is to unload the module whilst the DMA is
> ongoing (I'm using a software model, so I can make the DMA nice and slow --
> I guess you could try using some large buffers).

Thank you for the script. It looks like I managed to reproduce it with
help of your script. I'm about to send the patch. I will appreciate to
collect a Tested-by tags in case it solves the issue.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
