Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428Ab3HIQTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:19:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40239 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934227Ab3HIQTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:19:15 -0400
Message-ID: <5205167F.1070906@wwwdotorg.org>
Date: Fri, 09 Aug 2013 10:19:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: linaro-kernel@lists.linaro.org, Stephen Warren <swarren@nvidia.com>,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, rjw@sisk.pl,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 35/35] cpufreq: tegra: use cpufreq_table_validate_and_show()
References: <cover.1375964117.git.viresh.kumar@linaro.org> <568f3dbd414b050bb2319d960fb5044a5aed8ee3.1375964117.git.viresh.kumar@linaro.org> <5203BCDD.40809@wwwdotorg.org> <CAKohpomr8kwDitAFD7FKvHo3zNWz8qT5bkd3yOVEnC_k16o=Dw@mail.gmail.com> <CAKohpo=Gy7D2LYmdFU1p+eL-nMoPE18YXWvE2M8t-fb-a5HBgg@mail.gmail.com>
In-Reply-To: <CAKohpo=Gy7D2LYmdFU1p+eL-nMoPE18YXWvE2M8t-fb-a5HBgg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 10:04 PM, Viresh Kumar wrote:
> On 8 August 2013 21:37, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Its useless and the correct routine isn't called at all :) .. I will add that
>> additional patch and send it to you and will get this change out of this
>> commit.
> 
> The two commits look like this now attached too in case you want
> to test:

I'd be happy to test, but those changes cause build failures on top of
next-20130809. Which other patches do I need to apply first?
