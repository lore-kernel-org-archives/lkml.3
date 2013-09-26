Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3IZIdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:33:06 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:65222 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3IZIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:33:04 -0400
Message-ID: <5243F13C.7020409@linaro.org>
Date: Thu, 26 Sep 2013 10:33:00 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/21] cpuidle: don't calculate time-diff if entered_state
 == 0
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<acd1cc837f969a50582d2b25a73c5e247f40f843.1379779777.git.viresh.kumar@linaro.org>	<524365FA.4090108@linaro.org>	<CAKohpong15qzFg_sZVB77wVm4gu-4Se1E=eqvJOv96fgnyMXDA@mail.gmail.com>	<5243EF7F.4000606@linaro.org> <CAKohpongU4GpoEp5-WQJwxSbVFgAyWWcRDWo2zD+C8CGNhWwYQ@mail.gmail.com>
In-Reply-To: <CAKohpongU4GpoEp5-WQJwxSbVFgAyWWcRDWo2zD+C8CGNhWwYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:28 AM, Viresh Kumar wrote:
> On 26 September 2013 13:55, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Yes I agree, but why are you saying "If entered_state == 0, we don't need to
>> ..." ?
>
> Ahh.. that's a mistake.. s/==/< :)

Ah ok.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

