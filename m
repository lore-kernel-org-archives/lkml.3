Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab3HHId6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:33:58 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54427 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab3HHIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <CANg6MZgqxF1GBOhtebZLuHBh_F6CxWT=YRsQunPR+wdCQRunPw@mail.gmail.com>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<CANg6MZgqxF1GBOhtebZLuHBh_F6CxWT=YRsQunPR+wdCQRunPw@mail.gmail.com>
Date: Thu, 8 Aug 2013 14:03:54 +0530
Message-ID: <CAKohpo=j1hCsMKgrtR0xkL3hZ3a5gi6tv_yDH7sg6790QNo-Dg@mail.gmail.com>
Subject: Re: [PATCH 0/6] Tegra: Use cpufreq-cpu0 driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Richard Zhao <linuxzsc@gmail.com>
Cc: rjw@sisk.pl, Stephen Warren <swarren@nvidia.com>,
        linaro-kernel@lists.linaro.org, Mike Turquette <mturquette@linaro.org>,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2013 14:01, Richard Zhao <linuxzsc@gmail.com> wrote:
> On Wed, Aug 7, 2013 at 10:46 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Hi Stephen,
>>
>> This is the first attempt to get rid of tegra-cpufreq driver. This patchset
>> tries to add supporting infrastructure for tegra to use cpufreq-cpu0 driver.
>
> If tegra has only 4-core fast cpu, I would agree with the patch set. But now
> I'm not so sure. Tegra cpuquiet driver and cluster switch may need special
> settings of cpufreq driver.

I am not familiar with the latest happenings.. This change should be good
enough for not breaking anything that is working with current tegra cpufreq
driver.. If there is a new SoC with different needs then we can talk about it
separately.. As that might not be able to use tegra-cpufreq driver anyway..
