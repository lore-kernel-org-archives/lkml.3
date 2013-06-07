Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3FGD5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:57:24 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47382 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3FGD5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:57:22 -0400
Message-ID: <51B15A19.2020403@linaro.org>
Date: Fri, 07 Jun 2013 09:27:13 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, thomas.abraham@linaro.org, patches@linaro.org
Subject: Re: [PATCH 0/2] Clock changes for supporting CPUFreq on Exynos5250
References: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org> <51A442E4.90307@linaro.org> <20130529224203.6058.75266@quantum> <51B0501A.8070004@linaro.org> <20130606195156.10233.37021@quantum>
In-Reply-To: <20130606195156.10233.37021@quantum>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Would it be possible for you to queue them for 3.10-rc? These two
>> patches are sufficient for cpufreq to work on Arndale board. It would be
>> nice to have cpufreq working on 3.10 kernel.
>>
> 
> I only want to take bug fixes into the -rc's.  Did cpufreq work on
> Arndale in v3.10?  If it did then this is a regression and can be fixed.
> If this is a new feature however I'll keep the patches in clk-next.
> 

This fixes a regression as cpufreq was working for EXYNOS5250 based
systems before migration to CCF.

Though Arndale support was added during 3.10, this holds good for other
EXYNOS5250 based systems.

-- 
Tushar Behera
