Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaDAK2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:28:31 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:57955 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:28:30 -0400
Date: Tue, 1 Apr 2014 12:28:26 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        kbuild-all@01.org, daniel.lezcano@linaro.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH] avr32: remove cpu_data macro to fix compiles
Message-ID: <20140401102826.GA12237@samfundet.no>
References: <53060d5d.XcmAdOiLt1MCo6Y5%fengguang.wu@intel.com>
 <1393057709-17925-1-git-send-email-wsa@the-dreams.de>
 <20140224072820.GA9069@samfundet.no>
 <20140401095521.GA3326@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401095521.GA3326@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 01 Apr 2014 11:55:22 +0200 or thereabout, Wolfram Sang wrote:
> On Mon, Feb 24, 2014 at 08:28:20AM +0100, Hans-Christian Egtvedt wrote:
>> Around Sat 22 Feb 2014 09:28:27 +0100 or thereabout, Wolfram Sang wrote:
>> > Having cpu_data as a parameterless macro can easily cause build failures
>> > because it can be a variable name like in linux/pm_domain.h [1]. So,
>> > remove the macro and convert its only user. Because this architecture
>> > cannot do SMP, remove the whole SMP block, too. Only compile tested due
>> > to no hardware.
>> 
>> Looks sane, AVR32 doesn't support SMP, so this change should be fine.
>> 
>> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> > 
>> 
>> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>> 
>> > [1] https://lists.01.org/pipermail/kbuild-all/2014-February/003252.html
>> >
>> 
>> clockevents/3.15 branch, mens what you have queued up for 3.15?
>> 
>> I can queue this in my linux-next, and send Linus an early pull request the
>> moment 3.14 is released.
> 
> Have you done this already? I can't find it, yet I see the pull request
> for the clocks is already out.

I sent a pull request to Torvalds some hours ago, the branch is available at
https://git.kernel.org/cgit/linux/kernel/git/egtvedt/linux-avr32.git/log/?h=for-linus

-- 
mvh
Hans-Christian Egtvedt
