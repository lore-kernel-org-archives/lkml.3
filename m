Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaIYJCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:02:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32900 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIYJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:02:08 -0400
Message-ID: <5423DA0D.9030100@linaro.org>
Date: Thu, 25 Sep 2014 11:02:05 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kukjin Kim <kgene@kernel.org>
CC: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>
Subject: Re: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
References: <5230569.XLlNbB5NvF@amdc1032> <018e01cfd885$770dd940$65298bc0$@kernel.org> <20140925081704.GA20841@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140925081704.GA20841@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 10:17 AM, Lorenzo Pieralisi wrote:
> [CC'ed Daniel to make him aware this patch goes through your tree]

Thanks for the head up. I was about to send the PR to Rafael.

[ ... ]

> That's great, now my Exynos CPUidle DT patch should be rebased on top
> of this patch so that thanks to the testing carried out by Bart it can be
> merged too.

Ok, I am getting confused. How can I rebase the latest patch of your 
series with a patch no yet available in my tree ?

I propose just to drop the last patch and wait for the next merge to 
reintegrate it into the cpuidle tree. Does it make sense ?

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

