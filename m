Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCMMt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:49:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46646 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaCMMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:49:57 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-bc-5321a9706f04
Message-id: <1394714991.20773.5.camel@AMDC1943>
Subject: Re: [PATCH v2 2/3] mfd: sec-core: Add of_compatible strings for MFD
 cells
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Lee Jones <lee.jones@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 13 Mar 2014 13:49:51 +0100
In-reply-to: <5321A6A2.9070509@samsung.com>
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
 <1394703425-6462-3-git-send-email-k.kozlowski@samsung.com>
 <53219F80.9000300@samsung.com> <1394712996.20773.1.camel@AMDC1943>
 <5321A6A2.9070509@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xa7oFKxWDDWZvlbfYOGM9q8XZpjfs
	Fve/HmW02PT4GqvF5V1z2CxmnN/HZLH2yF12i6cTLrJZnPzTy2hxupvV4uKKL0wW62e8ZrFo
	/7uXzWLO9HdMDnwed67tYfOYdzLQY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DK6Lu6
	jqlgoUjFjZ2PGRsYt/F3MXJySAiYSEw9fYAVwhaTuHBvPVsXIxeHkMBSRok5qxayQDifGSV+
	71vEDlLFK6AvsWvWOkYQW1ggRKJtz3k2EJtNwFhi8/IlQDYHh4iAm8T9TT4gYWaBn8wSe76B
	lbMIqEr0TvsHVs4poC1x6+l8Voj5Lxklvh06wQLRoC4xad4iZoiLlCR2t3eyQ8TlJTavecsM
	cYOgxI/J91gmMArMQtIyC0nZLCRlCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExMmX
	HYyLj1kdYhTgYFTi4V2xXCFYiDWxrLgy9xCjBAezkghv4SLFYCHelMTKqtSi/Pii0pzU4kOM
	TBycUg2MFo36aY2zvz6suHW88dyB0G2ChY//1z5VX8m9yWeC0NGwU28mi6TfMOt4E+4QN2GK
	d2cL/7Y3Mge+vPeelfiyOGObdx3/2cPHud9yHL5bfWr1rr9FN1Li724J3v5Y+0PuxADDc6vs
	lmbqLeJ3/7rdiVdNTWhfxknhb6siSroXXU3qc/B6eDCLV4mlOCPRUIu5qDgRAMLAcxdxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 13:37 +0100, Tomasz Figa wrote:
> On 13.03.2014 13:16, Krzysztof Kozlowski wrote:
> > On Thu, 2014-03-13 at 13:07 +0100, Tomasz Figa wrote:
> >> Hi Krzysztof,
> >>
> >> On 13.03.2014 10:37, Krzysztof Kozlowski wrote:
> >>> Add of_compatible strings for MFD cells for regulator, clock and RTC
> >>> drivers in S5M8767, S2MPS11 and S2MPS14 PMIC-s.
> >>>
> >>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>> ---
> >>>    drivers/mfd/sec-core.c |    8 ++++++++
> >>>    1 file changed, 8 insertions(+)
> >>>
> >>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> >>> index d163c66edebb..c5b9b95b2099 100644
> >>> --- a/drivers/mfd/sec-core.c
> >>> +++ b/drivers/mfd/sec-core.c
> >>> @@ -55,28 +55,36 @@ static const struct mfd_cell s5m8763_devs[] = {
> >>>    static const struct mfd_cell s5m8767_devs[] = {
> >>>    	{
> >>>    		.name = "s5m8767-pmic",
> >>> +		.of_compatible = "samsung,s5m8767-regulators",
> >>>    	}, {
> >>>    		.name = "s5m-rtc",
> >>> +		.of_compatible = "samsung,s5m8767-rtc",
> >>>    	}, {
> >>>    		.name = "s5m8767-clk",
> >>> +		.of_compatible = "samsung,s5m8767-clk",
> >>>    	}
> >>>    };
> >>>
> >>>    static const struct mfd_cell s2mps11_devs[] = {
> >>>    	{
> >>>    		.name = "s2mps11-pmic",
> >>> +		.of_compatible = "samsung,s2mps11-regulators",
> >>>    	}, {
> >>>    		.name = "s2mps11-clk",
> >>> +		.of_compatible = "samsung,s2mps11-clk",
> >>>    	}
> >>>    };
> >>>
> >>>    static const struct mfd_cell s2mps14_devs[] = {
> >>>    	{
> >>>    		.name = "s2mps14-pmic",
> >>> +		.of_compatible = "samsung,s2mps14-regulators",
> >>>    	}, {
> >>>    		.name = "s2mps14-rtc",
> >>> +		.of_compatible = "samsung,s2mps14-rtc",
> >>>    	}, {
> >>>    		.name = "s2mps14-clk",
> >>> +		.of_compatible = "samsung,s2mps14-clk",
> >>>    	}
> >>>    };
> >>
> >> Are these compatible strings documented anywhere?
> >
> > The "-clk" compatible strings are (in next patch). The "-rtc" and
> > "-regulators" are not.
> 
> Hmm, this doesn't sound good.
> 
> > Actually they aren't also used by child driver (each child driver parses
> > from parent of_node).
> 
> Do you need to add compatible strings to mfd_cell entries of such cells 
> then?

>From my point of view there isn't any special need for them (except for
clk).

Dear Lee,

Do you wish to have these compatibles for all of child drivers even when
they aren't used directly by them? If yes then probably I should
document them.


Best regards,
Krzysztof

