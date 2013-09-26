Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3IZIZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:25:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63287 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3IZIZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:25:03 -0400
Message-ID: <5243EF5C.6060908@linaro.org>
Date: Thu, 26 Sep 2013 10:25:00 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/21] cpuidle: use cpuidle_disabled() instead of "off"
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<19979ce88726285c72dd6fe3d7b370d53669443c.1379779777.git.viresh.kumar@linaro.org>	<52435B05.9030201@linaro.org> <CAKohpon6fgCp2StW1=6JUua1xuZW8iS=0VLVCTsTD6JS027meg@mail.gmail.com>
In-Reply-To: <CAKohpon6fgCp2StW1=6JUua1xuZW8iS=0VLVCTsTD6JS027meg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 07:06 AM, Viresh Kumar wrote:
> On 26 September 2013 03:22, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> On 09/22/2013 03:21 AM, Viresh Kumar wrote:
>>> We have a routine for getting value of "off", better call that instead of using
>>> "off" directly.
>>
>> We are in the fast path, I am not sure invoking a function here is
>> better than using directly the static variable.
>
> I only did it for consistency as we have this routine specifically for reading
> value of "off" and so we better don't use off directly..
>
> Probably we can make it static inline and move it into
> drivers/cpuidle/cpuidle.h?

If you move it to cpuidle.h, you will have to move the 'off' variable in 
the header hence increasing the scope of it.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

