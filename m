Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaDSNns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 09:43:48 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:48982 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDSNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 09:43:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHygoHZ7hnAcLuuaMEsPb8Tqw-QbcTrQ+b=2CD6kK3odmw@mail.gmail.com>
References: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>
	<CAK9yfHygoHZ7hnAcLuuaMEsPb8Tqw-QbcTrQ+b=2CD6kK3odmw@mail.gmail.com>
Date: Sat, 19 Apr 2014 22:43:20 +0900
Message-ID: <CAGTfZH1M9h3Sx73wJsD=_vnSyV-+fyOY041PN_7ea718B0mFoQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Support cpufreq driver for Exynos3250
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Fri, Apr 18, 2014 at 5:14 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Chanwoo,
>
> On 18 April 2014 07:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patchset support cpufreq driver for Exynos3250 which uses the Cortex-A7
>> dual cores and has a target speed of 1.0 GHz and code clean using dev_err/info
>> instead of pr_err/info function.
>
> Per SoC cpufreq driver which does not use CCF is no more encouraged for new
> Exynos platforms. Thomas has already posted patches to make use of
> generic cpu freq driver
> on Exynos platforms. Please refer to [1] and try to utilize it for
> this platform as well.
>
> [1] http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/26886

OK, I'll refer to this new patch for cpufreq and rebase it.

Thanks for your reply.

Best Regards,
Chanwoo Choi
