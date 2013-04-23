Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3DWWE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:04:29 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54501 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3DWWEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:04:24 -0400
Message-ID: <5177055D.1060307@linaro.org>
Date: Wed, 24 Apr 2013 00:04:13 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 07/21] ARM: tegra: unify tegra_idle_device definitions
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-8-git-send-email-arnd@arndb.de> <5176BD29.1000405@linaro.org> <201304232057.37055.arnd@arndb.de>
In-Reply-To: <201304232057.37055.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:57 PM, Arnd Bergmann wrote:
> On Tuesday 23 April 2013, Daniel Lezcano wrote:
>> the patch sounds good but I think the side effect of the consolidation
>> patchset [1] fixed that.
>>
>> You can find these fixes in Rafael's tree:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=4c637b2175a0dc65d533494225525c6c82d73293
>>
>> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=e158f9da6974cc11bfab2246a9b10021af0e0d8a
>>
>> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=c5106c9dea9a6022ab84c6cb1d4a0b19fc5af0e2
>>
>> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&amp;id=f040c26ffaa5e56f2bca427c719c9601a02e70e5
>>
>> [1] http://www.spinics.net/lists/arm-kernel/msg239811.html
>>
> 
> Ah. Is that not in linux-next? I created the patch today based on the latest
> linux-next from today (Tuesday).

Ah, ok. Actually the patches were taken by Rafael right today. So it is
possible the changes were not reflected in linux-next yet.


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

