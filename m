Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3BVK3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:29:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40706 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3BVK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:29:15 -0500
Message-ID: <512748BF.1060403@ti.com>
Date: Fri, 22 Feb 2013 16:00:23 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos> <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com> <alpine.LFD.2.02.1302212214020.22263@ionos> <5127436E.4040100@ti.com> <alpine.LFD.2.02.1302221122290.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302221122290.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013 03:54 PM, Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Santosh Shilimkar wrote:
>> BTW, Lorenzo off-list mentioned to me about warning in boot-up
>> which I missed while testing your patch. It will take bit more
>> time for me to look into it and hence thought of reporting it.
>>
>> [    2.186126] ------------[ cut here ]------------
>> [    2.190979] WARNING: at kernel/time/tick-broadcast.c:501
>> tick_broadcast_oneshot_control+0x1c0/0x21c()
>
> Which one is that? tick_broadcast_pending or tick_force_broadcast_mask ?
>
The force broadcast mask one coming from below.
"WARN_ON_ONCE(test_bit(cpu, tick_force_broadcast_mask));"

Regards,
Santosh
