Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbaGAJj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:39:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51083 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbaGAJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:39:23 -0400
Message-ID: <53B28124.40509@ti.com>
Date: Tue, 1 Jul 2014 15:06:36 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Jason Cooper <jason@lakedaemon.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>, <linux@arm.linux.org.uk>,
        <rnayak@ti.com>, <santosh.shilimkar@ti.com>, <joe@perches.com>,
        <tglx@linutronix.de>
Subject: Re: [PATCH V4 00/16] irqchip: crossbar: Driver fixes
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com> <20140630192910.GA23978@titan.lakedaemon.net> <20140701075930.GN28884@atomide.com>
In-Reply-To: <20140701075930.GN28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tuesday 01 July 2014 01:29 PM, Tony Lindgren wrote:
> * Jason Cooper <jason@lakedaemon.net> [140630 12:30]:
>>
>> Whole series applied to irqchip/crossbar, I'll give it a day or two in
>> -next, then I'll merge it into irqchip/core.
>>
>> Tony: Right now, it's immutable unless you tell me I applied something
>> incorrectly.  Once it goes into irqchip/core, it's immutable no matter
>> what you say. ;-)
> 
> Thanks, looks good to me. Sricharan and Nishant, can you please
> check that we can now apply the related .dts changes on top of
> Jason's branch at:
> 
> git://git.infradead.org/users/jcooper/linux.git irqchip/crossbar
> 

I applied the dts patches on top of this and it worked fine for
me on dra72 evm

Regards,
 Sricharan
