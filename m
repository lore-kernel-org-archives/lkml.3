Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaAQFoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:44:09 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63729 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAQFoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:44:05 -0500
Message-ID: <52D8C25B.6080409@linaro.org>
Date: Fri, 17 Jan 2014 13:40:43 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched: select_idle_sibling macro optimize
References: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>	 <52D7DAF5.4020506@linaro.org> <1389880335.5418.46.camel@marge.simpson.net>	 <52D891FB.9020308@linaro.org> <1389929776.5409.27.camel@marge.simpson.net>
In-Reply-To: <1389929776.5409.27.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 11:36 AM, Mike Galbraith wrote:
>>>>> +
>>>>> > >>> +		/* skip single group domain */
>>>>> > >>> +		if (sg == sg->next)
>>>>> > >>> +			continue;
>>> > > 
>>> > > When is that gonna happen?
>> > 
>> > I had seen this in a Intel platform, you may have both CPU domain and MC
>> > domain layer, because the domain flag is different, then they can not be
>> > merged. and then the CPU domain just has one group.
> But sd starts at MC.

That's true. Sorry for noise.

-- 
Thanks
    Alex
