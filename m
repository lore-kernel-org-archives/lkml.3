Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaFMGdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:33:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58889 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaFMGc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:32:59 -0400
Message-ID: <539A9A87.6020004@ti.com>
Date: Fri, 13 Jun 2014 12:00:31 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jason Cooper <jason@lakedaemon.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <rnayak@ti.com>,
        <linux@arm.linux.org.uk>, <tglx@linutronix.de>
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>  <1402574007-13987-9-git-send-email-r.sricharan@ti.com>  <20140612131042.GU8664@titan.lakedaemon.net> <5399AC9C.4080602@ti.com>  <1402582711.9947.17.camel@joe-AO725>  <20140612153226.GE8664@titan.lakedaemon.net> <1402589159.12385.4.camel@joe-AO725>
In-Reply-To: <1402589159.12385.4.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thursday 12 June 2014 09:35 PM, Joe Perches wrote:
> On Thu, 2014-06-12 at 11:32 -0400, Jason Cooper wrote:
> 
> Hi Jason.
> 
>>> But bugfix backports haven't been much of an issue in
>>> other subsystems with fairly active whitespace/style
>>> changes.
>>
>> Most of the mvebu fixes we've had that failed to apply were generally
>> due to a large whitespace change (dts node shuffling, admittedly not
>> checkpatch-related).
> 
> So not due to this.
> 
>>   I've also frequently been stymied by code cleanups
>> when using git blame to find the commit introducing a regression.
> 
> git blame -w can frequently help there.
> 
>> So, my general rule is: If you're submitting a patch to make checkpatch
>> be quiet, re-assess the need.  If you're making changes and you can fix
>> some checkpatch items while you're there, then do so.
> 
> Decent rule.
> 
>> There are certainly legitimate checkpatch-only patches, I just don't
>> think this is one qualifies.
> 
> Of course it's the maintainer's choice (and last I saw,
> that's you) to ignore whatever doesn't fit the appropriate
> vision for the code.
> 
> $ ./scripts/get_maintainer.pl -f drivers/irqchip/irq-crossbar.c
> Thomas Gleixner <tglx@linutronix.de> (maintainer:IRQCHIP DRIVERS)
> Jason Cooper <jason@lakedaemon.net> (maintainer:IRQCHIP DRIVERS)
 
  Ok, if this is not qualifying as a separate patch then i will merge
  this with other patches in the series which touch them.

Regards,
 Sricharan

