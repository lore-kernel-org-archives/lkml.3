Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3JCKr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:47:56 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39934 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3JCKry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:47:54 -0400
Message-ID: <524D4B58.8070206@linaro.org>
Date: Thu, 03 Oct 2013 12:47:52 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] cpuidle: create list of registered drivers
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<7e9565e323c1e065eeb2a2a1075967bd21ee6066.1379779777.git.viresh.kumar@linaro.org>	<5243641B.6050604@linaro.org>	<CAKohpo=3qFQ+gD+3u__NtZEL4xu51FBN+og+_UE7aTR26XvRng@mail.gmail.com>	<5243EE02.9020207@linaro.org>	<20130928213343.GA19582@linux.vnet.ibm.com>	<5249C4FB.1060705@linaro.org> <CAKohpomcnRrkKmBtrVDyCUx0E00roD2R=XMS3WH9QTpOF9AJjQ@mail.gmail.com>
In-Reply-To: <CAKohpomcnRrkKmBtrVDyCUx0E00roD2R=XMS3WH9QTpOF9AJjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 06:38 AM, Viresh Kumar wrote:
> On 1 October 2013 00:07, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Interesting, thanks for the pointer.
>
> So, should I keep this patch with SRCU?

IMHO, we should, for now, keep the code as it is and then focus on the 
lock/refcount for drivers in a separate series.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

