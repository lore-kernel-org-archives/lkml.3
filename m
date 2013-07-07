Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3GGQpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 12:45:30 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61892 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3GGQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 12:45:19 -0400
Message-ID: <51D99B1B.7050106@linaro.org>
Date: Sun, 07 Jul 2013 18:45:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
References: <51B8D310.4050404@linaro.org> <51D9548B.9040907@gmail.com> <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de> <20130707144645.GA11908@titan.lakedaemon.net> <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2013 05:30 PM, Thomas Gleixner wrote:
> On Sun, 7 Jul 2013, Jason Cooper wrote:
>> Sure, but to be clear, Daniel, please drop this patch from your tree.  I
>> have no desire to create an out-of-tree dependency if we can avoid it.
>> It has a habit of going horribly wrong [1].
>>
>> I'll cherry-pick
>>
>>   0c1dcfd clocksource: Add Marvell Orion SoC timer
> 
> Don't do that. Do a git fetch on that branch and then git merge
> 0c1dcfd. The patches before that Marvel commit are already in Linus
> tree. That way it does not matter who sends first or not.
> 
> We don't force others to drop stuff and cherry picking is a nuisance
> as well as you end up with two different commits doing the same thing.
> 
> Also for the next merge window: Can we please let everything under
> drivers/clocksoure go through Daniels and my trees?
> 
> I'm starting to be grumpy about anyone thinking that this directory is
> a public dump ground with no rules.

Yes I agree. I will meet John this week and we will sort out this and
define a clear set of rules to prevent that to happen again.

  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

