Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3DYHBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:01:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48348 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3DYHBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:01:43 -0400
Message-ID: <5178D4C2.7080400@ti.com>
Date: Thu, 25 Apr 2013 12:31:22 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V4 1/6] clk: OMAP: introduce device tree binding to kernel
 clock data
References: <1365807278-554-1-git-send-email-nm@ti.com> <1365807278-554-2-git-send-email-nm@ti.com> <20130412233142.GE10155@atomide.com> <20130412233900.GA1599@kahuna> <20130413172210.GM10155@atomide.com> <20130414211917.GA3275@snafu> <20130424162847.8998.73264@quantum>
In-Reply-To: <20130424162847.8998.73264@quantum>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013 09:58 PM, Mike Turquette wrote:
> Quoting Nishanth Menon (2013-04-14 14:19:17)
>> Overall strategy introduced here is simple: a clock node described in
>> device tree blob is used to identify the exact clock provided in the
>> SoC specific data. This is then linked back using of_clk_add_provider
>> to the device node to be accessible by of_clk_get.
>>
>> Based on discussion contributions from Roger Quadros, Grygorii Strashko
>> and others.
>>
>> Cc: Kevin Hilman <khilman@deeprootsystems.com>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> [tony@atomide.com: co-developed]
>> Signed-off-by: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> I can take this into clk-next after the merge window.  Please refresh it
> for -rc1 as we discussed on irc.
> 
> As an aside, will Tero's series for migrating to drivers/clk/omap[1] and
> Rajendra's patch for registering clocks late[2] be refreshed after the

[2] is already in mainline.

> merge window?  It would be nice to combine these efforts.
> 
> Thanks,
> Mike
> 
> [1] http://article.gmane.org/gmane.linux.ports.arm.omap/95948
> [2] http://www.spinics.net/lists/arm-kernel/msg231288.html
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

