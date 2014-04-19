Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaDSNvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 09:51:31 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43075 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaDSNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 09:51:24 -0400
Message-ID: <53527F54.5020601@gmail.com>
Date: Sat, 19 Apr 2014 15:51:16 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chanwoo Choi <cwchoi00@gmail.com>, Sachin Kamat <sachin.kamat@linaro.org>
CC: Chanwoo Choi <cw00.choi@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Abraham <ta.omasab@gmail.com>
Subject: Re: [PATCH 0/2] Support cpufreq driver for Exynos3250
References: <1397787634-9334-1-git-send-email-cw00.choi@samsung.com>	<CAK9yfHygoHZ7hnAcLuuaMEsPb8Tqw-QbcTrQ+b=2CD6kK3odmw@mail.gmail.com> <CAGTfZH1M9h3Sx73wJsD=_vnSyV-+fyOY041PN_7ea718B0mFoQ@mail.gmail.com>
In-Reply-To: <CAGTfZH1M9h3Sx73wJsD=_vnSyV-+fyOY041PN_7ea718B0mFoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo, Sachin,

On 19.04.2014 15:43, Chanwoo Choi wrote:
> Hi Sachin,
>
> On Fri, Apr 18, 2014 at 5:14 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> Hi Chanwoo,
>>
>> On 18 April 2014 07:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> This patchset support cpufreq driver for Exynos3250 which uses the Cortex-A7
>>> dual cores and has a target speed of 1.0 GHz and code clean using dev_err/info
>>> instead of pr_err/info function.
>>
>> Per SoC cpufreq driver which does not use CCF is no more encouraged for new
>> Exynos platforms. Thomas has already posted patches to make use of
>> generic cpu freq driver
>> on Exynos platforms. Please refer to [1] and try to utilize it for
>> this platform as well.
>>
>> [1] http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/26886
>
> OK, I'll refer to this new patch for cpufreq and rebase it.
>
> Thanks for your reply.

The last version posted by Thomas still had several comments to be 
addressed that could lead to quite big changes in the whole design in 
next version. According to the information from Thomas, the work on it 
is in progress and we should see updated patchset soon.

Best regards,
Tomasz
