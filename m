Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab3GPPz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:55:58 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61314 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3GPPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:55:45 -0400
Message-ID: <51E56CFD.9050508@linaro.org>
Date: Tue, 16 Jul 2013 17:55:41 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
References: <51B8D310.4050404@linaro.org> <51D9548B.9040907@gmail.com> <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de> <20130707144645.GA11908@titan.lakedaemon.net> <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de> <20130707235819.GB11908@titan.lakedaemon.net> <alpine.DEB.2.02.1307081041290.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307081041290.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 10:45 AM, Thomas Gleixner wrote:
> On Sun, 7 Jul 2013, Jason Cooper wrote:
>> On Sun, Jul 07, 2013 at 05:30:31PM +0200, Thomas Gleixner wrote:
>> I don't mind delaying half of a series so the drivers/ portion can land
>> in mainline, and the rest can land in the next cycle.  But when things
>> don't go according to that plan, I'd like a little consideration /
>> flexibility about solving the problem.  Especially considering I'm
>> *trying* to do the right thing by pushing to appropriate maintainers
>> first.
>>
>> Of course, this is a moot point since, as you clarified above, this
>> dependency doesn't have the hazards typically associated with
>> out-of-tree dependencies.
> 
> There is a very simple procedure for stuff like this.
> 
> Series has parts which go through tree A and B and another larger part
> for tree C which depends on the A and B parts.
> 
> So ask the maintainers of A and B to apply this to separate branches,
> which are based on some commit in Linus tree. These branches can be
> pulled into C and C can apply the depending stuff on top.
> 
> Now the maintainers of A and B merge these branches into their main
> devel branch, can do further fixups and stuff on top. And the whole
> thing just works without glitches during the merge window.
> 
> We do this all the time.

Ok, I was about to send to both of you a PR with a common ancestor [1]
for this patch but finally this patch has been taken for timers/urgent.

I don't have to send the PR, right ?

timers/urgent will be merged into timers/core, correct ?

Thanks
  -- Daniel

[1]
https://git.linaro.org/gitweb?p=people/dlezcano/clockevents.git;a=shortlog;h=refs/heads/timers/mvebu-deps-3.12


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

