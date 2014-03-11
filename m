Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaCKVws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:52:48 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43097 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaCKVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:52:44 -0400
Message-ID: <531F85AC.3000404@linaro.org>
Date: Tue, 11 Mar 2014 22:52:44 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuidle: add 'failed' statistic
References: <1394165650-6927-1-git-send-email-daniel.lezcano@linaro.org> <CAJvTdKmUKS82YxkQio2_bPqXv7kNnyFpHcuvfZ=ExBZrkEg1eA@mail.gmail.com>
In-Reply-To: <CAJvTdKmUKS82YxkQio2_bPqXv7kNnyFpHcuvfZ=ExBZrkEg1eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 03:00 AM, Len Brown wrote:
> Exactly what use-case do you have in mind for this attribute?

Nothing more than balance the c-state usage with the selection 
efficiency of this state. The current statistics do not give a lot of 
clues of what is happening.

> "failed" is a strong word.
> Some validation guy is going to send me e-mail when it is non-zero...
> I don't like that use-case.
>
> But even if re-named, I don't see see how it will be useful.
> When I want to see how C-state predictions are doing, I use ftrace,
> which can show me the actual expected and actual times, not just a count
> of how man times predicted was < actual.

Mmh, where do you retrieve the target_residency from userspace ? This 
information is not exported from ftrace neither sysfs.

> I would rather see some good tracepoints go upstream.

Ok, which tracepoints you would like to see ?

target residency=%lu, expected residency=%lu, measured residency=%lu

??

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

