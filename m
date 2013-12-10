Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3LJObD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:31:03 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43118 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3LJOa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:30:56 -0500
Message-ID: <52A7259D.5080609@linaro.org>
Date: Tue, 10 Dec 2013 15:30:53 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] clocksource/clockevents fixes for 3.13
References: <52A0AC37.5010006@linaro.org> <20131210122051.GD30001@gmail.com> <52A71027.4000902@linaro.org> <20131210133633.GB31366@gmail.com>
In-Reply-To: <20131210133633.GB31366@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 02:36 PM, Ingo Molnar wrote:
>
> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
>> On 12/10/2013 01:20 PM, Ingo Molnar wrote:
>>>
>>> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>>>
>>>>
>>>> Hi Thomas,
>>>>
>>>> here are the fixes for 3.13 based on timers/urgent
>>>
>>> Please generally also post the patches to make it easier to review
>>> them.
>>
>> Hi Ingo,
>>
>> what do you mean by "also post the patches" ? The patches were
>> posted in the mailing lists and I picked them up after people
>> reviewed them.
>
> For example I found none of Dinh Nguyen's two patches on lkml.
>
> Even if they were on lkml it's generally good practice to post patches
> for pull requests even if they are mostly resends of existing patches,
> especially for an urgent tree. That makes it easier for people to
> chime in on patches.
>
>> Or shall I give a combined diff when sending the PR ?
>
> Individual patches posted as a threaded reply to the pull request mail
> would be nice - those are easy for other people to ignore, yet they
> are informative to people who are interested in the series.

Ah, ok I see. Will do next time.

Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

