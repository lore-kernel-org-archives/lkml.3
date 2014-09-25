Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaIYI5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:57:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36144 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaIYI51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:57:27 -0400
Message-ID: <5423D8F3.104@gmail.com>
Date: Thu, 25 Sep 2014 10:57:23 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        daniel.lezcano@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
References: <5230569.XLlNbB5NvF@amdc1032> <018e01cfd885$770dd940$65298bc0$@kernel.org> <20140925081704.GA20841@e102568-lin.cambridge.arm.com> <5423D19B.1040203@samsung.com> <5423D23C.5010204@gmail.com> <5423D5E8.1050008@samsung.com>
In-Reply-To: <5423D5E8.1050008@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25.09.2014 10:44, Kukjin Kim wrote:
> On 09/25/14 17:28, Tomasz Figa wrote:
>> Hi Kukjin,
>>
>> On 25.09.2014 10:26, Kukjin Kim wrote:
>>> On 09/25/14 17:17, Lorenzo Pieralisi wrote:
>>>> [CC'ed Daniel to make him aware this patch goes through your tree]
>>>>
>>> Thanks and just note the branch  which is including this change actually
>>> v4 is just rebased not v3 will be sent out to arm-soc last tonight or
>>> tomorrow.
> 
> v3 is correct :) sorry, I confused the version...
> 
>>
>> Could you keep this patch in a separate stable branch, so I could pull
>> it as a dependency for Thomas Abraham's cpufreq series?
>>
> It's possible, but would be better that DT changes are sent to upstream
> through samsung/arm-soc tree?...we suffered ugly conflicts between
> arm-soc and driver before and then we decided DT changes should be
> handled in arm-soc...Hmm...

The only other option I can see is splitting the series and sending
mach/dts patches through arm-soc and clock/cpufreq patches through clock
tree. This would break cpufreq support in both trees, until they both
hit Linus's tree. If this is not a problem, then I can proceed this way.

Please correct me if I'm missing something.

Best regards,
Tomasz
