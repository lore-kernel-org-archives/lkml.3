Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaEMSwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:52:12 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37053 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaEMSv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:51:27 -0400
Message-ID: <53725FDE.30006@gmail.com>
Date: Tue, 13 May 2014 20:09:34 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/3] sched: sched_setattr/sched_getattr fixes and improvements
References: <536CEAEE.4010609@gmail.com> <20140509171640.GA30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140509171640.GA30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 07:16 PM, Peter Zijlstra wrote:
> On Fri, May 09, 2014 at 04:49:18PM +0200, Michael Kerrisk (man-pages) wrote:
>> Peter,
>>
>> While looking at your sched_setattr()/sched_getatr() documentation, 
>> I noticed a bug in the handling of -EFBIG, and a couple of places 
>> in the code where the error handling logic could be streamlined.
>> Patches follow.
> 
> Thanks!

Hi Peter,

I was a little unclear on what "Thanks" meant... Does it mean
you plan to apply all 3 patches in your tree to go upstream?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
