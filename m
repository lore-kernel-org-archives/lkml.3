Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3BUPLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:11:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46520 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab3BUPLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:11:43 -0500
Message-ID: <51263975.20906@ti.com>
Date: Thu, 21 Feb 2013 20:42:53 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Jason Liu <liu.h.jason@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos> <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302211436300.22263@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thursday 21 February 2013 07:18 PM, Thomas Gleixner wrote:
> Jason,
>
> On Thu, 21 Feb 2013, Jason Liu wrote:
>> 2013/2/21 Thomas Gleixner <tglx@linutronix.de>:
>>> Now your explanation makes sense.
>>>
>>> I have no fast solution for this, but I think that I have an idea how
>>> to fix it. Stay tuned.
>>
>> Thanks Thomas, wait for your fix. :)
>
> find below a completely untested patch, which should address that issue.
>
After looking at the thread, I tried to see the issue on OMAP and could
see the same issue as Jason.

Your patch fixes the retries on both CPUs on my dual core machine. So
you use my tested by if you need one.
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Thanks for the patch.
And thanks to Jason for spotting the issue.

Regards,
Santosh

