Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaCKV4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:56:05 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52288 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaCKVzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:50 -0400
Message-ID: <531F865C.8050407@linaro.org>
Date: Tue, 11 Mar 2014 22:55:40 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, khilman@linaro.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH V7 0/3] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
References: <1392897287-11614-1-git-send-email-wsa@the-dreams.de> <5305FA60.7040904@linaro.org> <20140307154532.GE28943@katana>
In-Reply-To: <20140307154532.GE28943@katana>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 04:45 PM, Wolfram Sang wrote:
> Hi Daniel,
>
> On Thu, Feb 20, 2014 at 01:51:44PM +0100, Daniel Lezcano wrote:
>> On 02/20/2014 12:54 PM, Wolfram Sang wrote:
>>> This is V7 of the SH and ARM mach-shmobile clocksource Kconfig consolidation
>>> series. It is a rebased version of V5 on top of timers/core. This series is not
>>> just an optimization, it also makes it possible to enable the clocksource for
>>> the r7s72100 platform. I successfully tested the patches on r7s72100 and
>>> r8a7791 platforms. The branch can be found here:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/rework-clock-config-for-daniel
>>
>> Thanks Wolfram,
>>
>> applied to my tree for 3.15
>
> I see the patches in your tree, but not in linux-next?

Hi,

I updated my next branch and pushed it in my repo.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

