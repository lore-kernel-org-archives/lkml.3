Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaFMGeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:34:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47965 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaFMGeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:34:01 -0400
Message-ID: <539A9ACB.7060208@ti.com>
Date: Fri, 13 Jun 2014 12:01:39 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Jason Cooper <jason@lakedaemon.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <nm@ti.com>, <rnayak@ti.com>, <linux@arm.linux.org.uk>,
        <tglx@linutronix.de>
Subject: Re: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from getting
 mapped to crossbar
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com> <1402574007-13987-4-git-send-email-r.sricharan@ti.com> <20140612125134.GS8664@titan.lakedaemon.net> <20140612135715.GE17845@atomide.com>
In-Reply-To: <20140612135715.GE17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2014 07:27 PM, Tony Lindgren wrote:
> * Jason Cooper <jason@lakedaemon.net> [140612 05:52]:
>> On Thu, Jun 12, 2014 at 05:23:11PM +0530, Sricharan R wrote:
>>> From: Nishanth Menon <nm@ti.com>
>>>
>>> When, in the system due to varied reasons, interrupts might be unusable
>>> due to hardware behavior, but register maps do exist, then those interrupts
>>> should be skipped while mapping irq to crossbars.
>>>
>>> Signed-off-by: Nishanth Menon <nm@ti.com>
>>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>>> Signed-off-by: Tony Lindgren <tony@atomide.com>
>>
>> Tony, have you applied these somewhere already?
> 
> I think some of these I had applied into a branch ready for
> merging but then it was discovered that further changes
> were needed and the branch was dropped.
> 
> Sricharan, please remove my Signed-off-by from this series.
> If I end up applying it for merging my scripts will add it
> automatically.
> 
 Ok, will remove it.

Regards,
 Sricharan
