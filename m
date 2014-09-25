Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaIYI2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:28:50 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34695 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIYI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:28:48 -0400
Message-ID: <5423D23C.5010204@gmail.com>
Date: Thu, 25 Sep 2014 10:28:44 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Kukjin Kim <kgene@kernel.org>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>, daniel.lezcano@linaro.org
Subject: Re: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
References: <5230569.XLlNbB5NvF@amdc1032> <018e01cfd885$770dd940$65298bc0$@kernel.org> <20140925081704.GA20841@e102568-lin.cambridge.arm.com> <5423D19B.1040203@samsung.com>
In-Reply-To: <5423D19B.1040203@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 25.09.2014 10:26, Kukjin Kim wrote:
> On 09/25/14 17:17, Lorenzo Pieralisi wrote:
>> [CC'ed Daniel to make him aware this patch goes through your tree]
>>
> Thanks and just note the branch  which is including this change actually
> v4 is just rebased not v3 will be sent out to arm-soc last tonight or
> tomorrow.

Could you keep this patch in a separate stable branch, so I could pull
it as a dependency for Thomas Abraham's cpufreq series?

Best regards,
Tomasz
