Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaBMHqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:46:09 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55158 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaBMHqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:46:07 -0500
Message-ID: <52FC7835.1090509@linaro.org>
Date: Thu, 13 Feb 2014 15:45:57 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti Murthy <preeti.lkml@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 2/3] sched: Fix race in idle_balance()
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>	<1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pMEFTe6pQVDFzaXmqt_A3vw3tyj7Ewqib6zbzH++YzY3w@mail.gmail.com> <52FA0577.6080607@linaro.org>
In-Reply-To: <52FA0577.6080607@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 07:11 PM, Daniel Lezcano wrote:
> On 02/10/2014 10:24 AM, Preeti Murthy wrote:
>> HI Daniel,
>>
>> Isn't the only scenario where another cpu can put an idle task on
>> our runqueue,
> 
> Well, I am not sure to understand what you meant, but I assume you are
> asking if it is possible to have a task to be pulled when we are idle,
> right ?
> 
> This patch fixes the race when the current cpu is *about* to enter idle
> when calling schedule().

Preeti said the she didn't see a possible to insert a task on the cpu.

I also did a quick check, maybe task come from wakeup path?

-- 
Thanks
    Alex
