Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaFJLqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:46:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40096 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaFJLqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:46:19 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-41-5396f009a843
Message-id: <5396EFFB.3040704@samsung.com>
Date: Tue, 10 Jun 2014 13:46:03 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com
Subject: Re: [PATCH v4 02/11] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-3-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399704998-13321-3-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7qcH6YFG1zo1rRYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vFzWfbmSx2tKxmceD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiuGxSUnMyy1KL9O0SuDKOb7jFWnCSreLBw0OMDYw7WbsYOTkkBEwkeqZvY4GwxSQu
	3FvP1sXIxSEksJRR4tPzm0wQzmdGiWMnNwNVcXDwCmhJrHgiAdLAIqAq8ej+bmYQm01ATeJz
	wyM2EJsfqGRN03WwclGBCInHF4RAwrwCghI/Jt9jARkpIjCFUeJizzJGkASzQI3Egs7NYEcI
	C2RKdKybBrW3nVFi18vtYJdyCnhKbL/5lhmiQUdif+s0NghbXmLzmrfMExgFZyFZMgtJ2Swk
	ZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETB1x2MS49ZHWIU4GBU4uE18J8WLMSa
	WFZcmXuIUYKDWUmE98tJoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGTsG/C67+sCq4mx58pJf5
	yJtMvckFiyV+NphIrbT49cqMY/ld3S7R7CbOX1+2JzCzdr9myY73Tk2zKp86odvG5LEJ26K2
	hZ9nvRU9eebRnjBtxwC/CpceoXLDqb/vTfZrkn2cphu6bZHKKbmLDx7cft7z2DmkzIFj9q5a
	IaWPTJUdJ76x7ZmsxFKckWioxVxUnAgANajeIGACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.05.2014 08:56, Pankaj Dubey wrote:
> As exynos_cpuidle_init and exynos_cpufreq_init function have just one lines
> of code for registering platform devices. We can move these lines to
> exynos_dt_machine_init and delete exynos_cpuidle_init and exynos_cpufreq_init
> function. This will help in reducing lines of code in exynos.c, making it
> more cleaner.
> 
> Suggested-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/exynos.c |   19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Btw. This and other simple clean-up patches from this series could be
applied separately, without re-spinning them every time with this series.

Best regards,
Tomasz
