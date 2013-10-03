Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3JCL6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:58:20 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55975 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3JCL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:58:19 -0400
Message-ID: <524D5BD9.6040807@linaro.org>
Date: Thu, 03 Oct 2013 13:58:17 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] cpuidle: change governor from within cpuidle_replace_governor()
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<5b758e21eeb97f5f68191819c0820673692b6b75.1379779777.git.viresh.kumar@linaro.org>	<524368CF.4030803@linaro.org>	<CAKohpom_BTYC4DZLP93VzFqfnCudPb9whugPigh-jO0MpHurtw@mail.gmail.com>	<5243EE3B.1050600@linaro.org> <CAKohpomiJtmpnudWQekc8A6kPPkVNVJw3fFHFiM_6fMiwkupcw@mail.gmail.com>
In-Reply-To: <CAKohpomiJtmpnudWQekc8A6kPPkVNVJw3fFHFiM_6fMiwkupcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 12:36 PM, Viresh Kumar wrote:
> On 26 September 2013 13:50, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Rafael is pretty busy ATM but may be he can give his feedback on this later.
>
> For now I will resend it and maybe later you can get it cleaned up even more..
> Or maybe I will do it once I have better hold on cpuidle core :)
>
> Can I have your Ack for now? (As discussed on IRC) :)

Actually the functions cpuidle_unregister_governor and 
cpuidle_replace_governor are dead code since the governors are no longer 
modules (commit 137b944e100278d696826cf25c83014ac17473fe), so you can 
remove the code instead.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

