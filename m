Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3HIRJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:09:45 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52222 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3HIRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <5205167F.1070906@wwwdotorg.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
	<568f3dbd414b050bb2319d960fb5044a5aed8ee3.1375964117.git.viresh.kumar@linaro.org>
	<5203BCDD.40809@wwwdotorg.org>
	<CAKohpomr8kwDitAFD7FKvHo3zNWz8qT5bkd3yOVEnC_k16o=Dw@mail.gmail.com>
	<CAKohpo=Gy7D2LYmdFU1p+eL-nMoPE18YXWvE2M8t-fb-a5HBgg@mail.gmail.com>
	<5205167F.1070906@wwwdotorg.org>
Date: Fri, 9 Aug 2013 22:39:42 +0530
Message-ID: <CAKohponQDAqHiRD7Aw5Wk6fEE-d8H=Svg0oBRyb9SKGdqYxGhw@mail.gmail.com>
Subject: Re: [PATCH 35/35] cpufreq: tegra: use cpufreq_table_validate_and_show()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linaro-kernel@lists.linaro.org, Stephen Warren <swarren@nvidia.com>,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, rjw@sisk.pl,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 August 2013 21:49, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/08/2013 10:04 PM, Viresh Kumar wrote:
>> On 8 August 2013 21:37, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> Its useless and the correct routine isn't called at all :) .. I will add that
>>> additional patch and send it to you and will get this change out of this
>>> commit.
>>
>> The two commits look like this now attached too in case you want
>> to test:
>
> I'd be happy to test, but those changes cause build failures on top of
> next-20130809. Which other patches do I need to apply first?

None.. You applied all three attached patches? I have given it a try
on my side now and it worked without any issues..

Just pushed out a branch for you as well:

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/tegra-test
