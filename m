Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaD2E3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:29:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55527 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaD2E3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:29:49 -0400
Message-ID: <535F2A74.9060908@ti.com>
Date: Tue, 29 Apr 2014 09:58:36 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <davem@davemloft.net>,
        <jeffrey.t.kirsher@intel.com>, <dborkman@redhat.com>,
        <ast@plumgrid.com>, <tklauser@distanz.ch>, <mpa@pengutronix.de>,
        <bhutchings@solarflare.com>, <zonque@gmail.com>, <balbi@ti.com>,
        <mugunthanvnm@ti.com>, <t-kristo@ti.com>, <mturquette@linaro.org>,
        <linux@arm.linux.org.uk>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH 5/6] ARM: AM43xx: clk: Change the cpts ref clock source
 to dpll_core_m5 clk
References: <1398658225-25873-1-git-send-email-george.cherian@ti.com> <1398658225-25873-6-git-send-email-george.cherian@ti.com> <20140428071034.GB4380@netboy> <535E4FDC.70306@ti.com> <20140428161856.GB4266@netboy>
In-Reply-To: <20140428161856.GB4266@netboy>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 4/28/2014 9:48 PM, Richard Cochran wrote:
> On Mon, Apr 28, 2014 at 06:25:56PM +0530, George Cherian wrote:
>> In beagle bone white (AM335x)  CPTS has a choice of 2 clocksource
>> -dpll_core_m5_ck
>> -dpll_core_m4_ck
>> and by default  dpll_core_m5_ck is used. Where as in AM437x the
>> default clocksource used is dpll_core_m4_ck .
> Is your patch changing the default clock for am335x?
No
>
> If yes, it shouldn't.
> If no, then the patch description should say so.
I am modifying the file

drivers/clk/ti/clk-43xx.c for am33xx its drivers/clk/ti/clk-33xx.c

> Thanks,
> Richard
>
>   


-- 
-George

