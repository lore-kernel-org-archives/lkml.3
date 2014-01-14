Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaANN2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:28:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54954 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751329AbaANN2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:28:00 -0500
Message-ID: <52D53B52.1030201@sgi.com>
Date: Tue, 14 Jan 2014 05:27:46 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PATCH: UV/NMI Fix tip/bot/kbuild test robot problems
References: <20140114042407.913800664@asylum.americas.sgi.com> <20140114042408.283595833@asylum.americas.sgi.com> <20140114110021.GV7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140114110021.GV7572@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/14/2014 3:00 AM, Peter Zijlstra wrote:
> On Mon, Jan 13, 2014 at 10:24:09PM -0600, Mike Travis wrote:
>> Fix some problems found by the kbuild test robot.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Reviewed-by: Hedi Berriche <hedi@sgi.com>
> 
> In general it is best to actually mention the issues the patch cures,
> otherwise review is impossible, /me stares hard at Hedi.
> 

I can send an updated patch if required?  The issues were
pretty trivial so I didn't think more info than the patch
itself was needed.

Hopefully I don't get a lot more in the future (this was my
first time), should I include the actual tipbot messages?

Thanks.

