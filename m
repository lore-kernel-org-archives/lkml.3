Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab3HHIb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:31:26 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51234 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743Ab3HHIbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1375886595.git.viresh.kumar@linaro.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
Date: Thu, 8 Aug 2013 16:31:22 +0800
Message-ID: <CANg6MZgqxF1GBOhtebZLuHBh_F6CxWT=YRsQunPR+wdCQRunPw@mail.gmail.com>
Subject: Re: [PATCH 0/6] Tegra: Use cpufreq-cpu0 driver
From: Richard Zhao <linuxzsc@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, Stephen Warren <swarren@nvidia.com>,
        linaro-kernel@lists.linaro.org, Mike Turquette <mturquette@linaro.org>,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 10:46 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Stephen,
>
> This is the first attempt to get rid of tegra-cpufreq driver. This patchset
> tries to add supporting infrastructure for tegra to use cpufreq-cpu0 driver.

If tegra has only 4-core fast cpu, I would agree with the patch set. But now
I'm not so sure. Tegra cpuquiet driver and cluster switch may need special
settings of cpufreq driver.

Thanks
Richard
