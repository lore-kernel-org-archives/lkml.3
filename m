Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3HLQdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:33:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50998 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3HLQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:33:47 -0400
Message-ID: <52090E67.1080703@wwwdotorg.org>
Date: Mon, 12 Aug 2013 10:33:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: linaro-kernel@lists.linaro.org, Stephen Warren <swarren@nvidia.com>,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, rjw@sisk.pl,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 35/35] cpufreq: tegra: use cpufreq_table_validate_and_show()
References: <cover.1375964117.git.viresh.kumar@linaro.org> <568f3dbd414b050bb2319d960fb5044a5aed8ee3.1375964117.git.viresh.kumar@linaro.org> <5203BCDD.40809@wwwdotorg.org> <CAKohpomr8kwDitAFD7FKvHo3zNWz8qT5bkd3yOVEnC_k16o=Dw@mail.gmail.com> <CAKohpo=Gy7D2LYmdFU1p+eL-nMoPE18YXWvE2M8t-fb-a5HBgg@mail.gmail.com> <5205167F.1070906@wwwdotorg.org> <CAKohponQDAqHiRD7Aw5Wk6fEE-d8H=Svg0oBRyb9SKGdqYxGhw@mail.gmail.com> <52056842.8060109@wwwdotorg.org> <CAKohpon=j=NANLQzYuBdoFVLxQzETy5JDu2vORaAgK3NuEpeAg@mail.gmail.com>
In-Reply-To: <CAKohpon=j=NANLQzYuBdoFVLxQzETy5JDu2vORaAgK3NuEpeAg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 08:53 PM, Viresh Kumar wrote:
> On 10 August 2013 03:38, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> Well, I don't see any issues running this, although the cpufreq sysfs
>> files seem to have disappeared on Tegra, even without your changes, so
>> I'm not sure how to really verify cpufreq.
>>
>> Did the sysfs files go away, or do I need to investigate why/when the
>> disappeared?
> 
> It wasn't enabled by default in your defconfig... So enable it first with
> your menuconfig.

It's in defconfig OK; I think the driver simply isn't initializing since
some of the clocks it requests don't exist. I'll have our clock driver
author look into it. In the meantime, I assume that your change is
likely fine.

