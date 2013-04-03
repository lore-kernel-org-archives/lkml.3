Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620Ab3DCRJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:09:23 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:65002 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762415Ab3DCRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130403.123843.317510603826206997.davem@davemloft.net>
References: <20130331.124040.1451284849991873230.davem@davemloft.net>
	<CAKohpok2Da4BFcKHu_yMZRNcvOGV1fNx0_shRwkrJwu0o77e=Q@mail.gmail.com>
	<CAKohpomNTb6G9XOyd+4AidQw+EcS63neVuL9FETdQDQY6emxPA@mail.gmail.com>
	<20130403.123843.317510603826206997.davem@davemloft.net>
Date: Wed, 3 Apr 2013 22:39:19 +0530
Message-ID: <CAKohpo=vDx+v6SFK9WFW=Db+URe+8jtWb6037w9054djUJ_QVg@mail.gmail.com>
Subject: Re: [PATCH 8/9] spark: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, arvind.chauhan@arm.com,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 22:08, David Miller <davem@davemloft.net> wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Wed, 3 Apr 2013 14:59:44 +0530
>
>> On 1 April 2013 10:11, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> On 31 March 2013 22:10, David Miller <davem@davemloft.net> wrote:
>>>>> On 26 March 2013 09:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>>>> From: Viresh Kumar <viresh.kumar@linaro.org>
>>>>>> Date: Mon, 25 Mar 2013 11:20:23 +0530
>>>>>> Subject: [PATCH] sparc: cpufreq:  move cpufreq driver to drivers/cpufreq
>>>
>>>> Subject line still has the "spark" typo.
>>>
>>> Your mail was scary, really... HOW can i do it??
>>>
>>> And then i saw how you got it wrong. I haven't sent a new mail, so mails subject
>>> remains the same... I copied V2 in the same mail.. Check above, subject looks
>>> fine :)
>>
>> Hi David,
>>
>> I think all pending issues are fixed now... Can i have your Ack please?
>> Or maybe more comments :)
>
> Acked-by: David S. Miller <davem@davemloft.net>

Adding everybody else in cc.
