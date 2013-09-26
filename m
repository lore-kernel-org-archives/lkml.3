Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3IZHz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:55:26 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59762 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3IZHzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:55:22 -0400
Message-ID: <5243E866.1000909@linaro.org>
Date: Thu, 26 Sep 2013 09:55:18 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/21] cpuidle: replace multiline statements with single
 line in cpuidle_idle_call()
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<c79ae2ab0a5a3946fcd0e68c855742f06f695f0f.1379779777.git.viresh.kumar@linaro.org>	<52435DA4.3080204@linaro.org> <CAKohpokM2JLyjq3cTw=GMDx8S+_fZU1qxxavKoZ-roC2PXukNA@mail.gmail.com>
In-Reply-To: <CAKohpokM2JLyjq3cTw=GMDx8S+_fZU1qxxavKoZ-roC2PXukNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 07:51 AM, Viresh Kumar wrote:
> On 26 September 2013 03:33, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> I splitted these lines because they have 81 cols.
> 
>>> -             clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
>>> -                                &dev->cpu);
>>> +             clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
> 
> This one comes in 80 columns
> 
>>> -             clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
>>> -                                &dev->cpu);
>>> +             clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> 
> And this one in 79..
> 
> And so I did this change.. I have checked it again now..

Well I have 81 with Vi and 80 with Emacs :)

May be some tabs converted to spaces ...

Anyway if it fits 80 cols then it is ok.

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

