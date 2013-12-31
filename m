Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3LaRTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:19:09 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:35157 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3LaRTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:19:07 -0500
Message-ID: <52C2FC88.6040903@linaro.org>
Date: Tue, 31 Dec 2013 18:19:04 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/7] sched: cleanup trigger_load_balance
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org> <20131231162821.GE16438@laptop.programming.kicks-ass.net>
In-Reply-To: <20131231162821.GE16438@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 05:28 PM, Peter Zijlstra wrote:
> On Mon, Dec 30, 2013 at 02:44:46PM +0100, Daniel Lezcano wrote:
>> This patchset does a cleanup on the parameters passed from the function
>> 'trigger_load_balance' to the underneath functions.
>
> Doesn't actually apply right.. will maybe spend more time next week :-)

I understand. Happy new year !

   -- Daniel

ps : the patchset is based on tip/sched/core


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

