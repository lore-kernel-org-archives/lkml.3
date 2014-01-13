Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaAMMzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:55:52 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59807 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaAMMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:55:47 -0500
Message-ID: <52D3E253.9090901@linaro.org>
Date: Mon, 13 Jan 2014 13:55:47 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, preeti.lkml@gmail.com
Subject: Re: [PATCH V2 0/8] sched: cleanup trigger_load_balance
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org> <20140106123219.GI31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106123219.GI31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 01:32 PM, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 12:34:37PM +0100, Daniel Lezcano wrote:
>> This patchset does a cleanup on the parameters passed from the function
>> 'trigger_load_balance' to the underneath functions.
>
> Whee.. it applies ;-)

Hi Peter,

do you consider it for upstream ?


Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

