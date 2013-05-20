Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3ETHwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:52:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:36376 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3ETHwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:52:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,706,1363158000"; 
   d="scan'208";a="340382411"
Message-ID: <1369036354.29283.115.camel@smile>
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
Date: Mon, 20 May 2013 10:52:34 +0300
In-Reply-To: <20130517141857.GM23112@mudshark.cambridge.arm.com>
References: <20130515152803.GL23869@mudshark.cambridge.arm.com>
	 <20130516153553.GI11706@mudshark.cambridge.arm.com>
	 <20130517123423.GR14863@intel.com>
	 <20130517141857.GM23112@mudshark.cambridge.arm.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 15:18 +0100, Will Deacon wrote: 
> On Fri, May 17, 2013 at 01:34:23PM +0100, Vinod Koul wrote:
> > On Thu, May 16, 2013 at 04:35:53PM +0100, Will Deacon wrote:
> > > Right, so I think I understand what's causing this, but I'll leave it to
> > > Andriy to suggest a fix.

Thanks for the report.

Unfortunately neither me nor other guys in the team could not reproduce
mentioned issue on our hardware.
Nevertheless I will try to allocate time and suggest possible fix if any
comes to my mind. So, your testing and analysis is appreciated.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
