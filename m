Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaFSE0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:26:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37373 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaFSE0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:26:39 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-b8-53a2667da27c
Message-id: <53A2667C.9060604@samsung.com>
Date: Thu, 19 Jun 2014 13:26:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Thomas Abraham <ta.omasab@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/3] cpufreq: Use cpufreq-cpu0 driver for Exynos3250
References: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
 <CAJuA9aiYGXYYORkbB66ZJs3rTjAu4a7HcPhMSOZs_qUJyy_o7g@mail.gmail.com>
In-reply-to: <CAJuA9aiYGXYYORkbB66ZJs3rTjAu4a7HcPhMSOZs_qUJyy_o7g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkQLc2bVGwweZrKha9C66yWZxtesNu
	senxNVaLy7vmsFl87j3CaDHj/D4mi6cTLrJZPF23hNli/YzXLBabJ2xks9j41cOB22PnrLvs
	Hneu7WHz2Lyk3qNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgypvTvYyno5a6Ys6eJrYGxj7OL
	kZNDQsBE4tbVC4wQtpjEhXvr2boYuTiEBJYySszadZ69i5EDrKhhixdEfBGjxNF7fSwgDUIC
	rxklntyKBLF5BbQkfs6czAxSzyKgKvH8QC5ImA0ovP/FDTYQW1QgTGLl9CssEOWCEj8m3wOz
	RQQ0JFbe+cMKMp9Z4AGzxO6pu5hAEsICXhIzzl1ngVjczSix58ZJVpAEp0CwxPtjU8GuZhZQ
	l5g0bxEzhC0vsXnNW2aQBgmBj+wSN/5cBkuwCAhIfJt8iAXiG1mJTQeYIT6WlDi44gbLBEax
	WUiOmoVk7CwkYxcwMq9iFE0tSC4oTkovMtIrTswtLs1L10vOz93ECIzN0/+e9e1gvHnA+hBj
	MtDKicxSosn5wNjOK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2MExVb5gto62v43/BqnpW4fJv9msXOCdxRfRO1dqmekp7QzeeW+bS9bEJwfMlb
	zVV192uvvfymNle69oHddBuTME6pOwcqXCNKbptIvDy14wKvhqZU1Nzg/yFe264tdVnqWLzS
	fd8195SXUU+vBSkdd7aUtnQVLv4o8mq1rbyGXtlm9ZDpU1OVWIozEg21mIuKEwH3/OoN4wIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAd3atEXBBk8vylj0LrjKZnG26Q27
	xabH11gtLu+aw2bxufcIo8WM8/uYLJ5OuMhm8XTdEmaL9TNes1hsnrCRzWLjVw8Hbo+ds+6y
	e9y5tofNY/OSeo++LasYPT5vkgtgjWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmDGlfx9LQS93xZw9TWwNjH2cXYwcHBICJhINW7y6GDmBTDGJC/fWs3UxcnEICSxilDh6
	r48FJCEk8JpR4smtSBCbV0BL4ufMycwgvSwCqhLPD+SChNmAwvtf3GADsUUFwiRWTr/CAlEu
	KPFj8j0wW0RAQ2LlnT+sIPOZBR4wS+yeuosJJCEs4CUx49x1FojF3YwSe26cZAVJcAoES7w/
	NpURxGYWUJeYNG8RM4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgiP/mdQOxpUNFocYBTgYlXh4PS4uDBZiTSwrrsw9xCjBwawkwiv/CyjEm5JY
	WZValB9fVJqTWnyIMRkYBBOZpUST84FJKa8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGMsL9KeL5C/NUJzKNLF9tSWfwifHW4uPK/3flJup3dquYLDhdNP+
	w92fSqb7Re/Yv+rx8+Z01vbJU/PNbRbLt82ZqP7CW1P610yDZ5ycZSVGOZZOjldvNP78UhVw
	/v6r7h8eOX/rjgo3pWuIXzO8MK32SMeiGS9+mlpdaprXvOp99uedyiWnjJVYijMSDbWYi4oT
	AbYrybRAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 06/19/2014 01:21 PM, Thomas Abraham wrote:
> On Wed, Jun 18, 2014 at 2:09 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patchset use cpufreq-cpu0 driver to support Exynos3250 cpufreq. So, this
>> patchset is based on following patchset[1] by Thomas Abraham.
>>  [1] http://www.spinics.net/lists/arm-kernel/msg339392.html
>>
>> Changes from v1:
>> - Rebased on new patchset[1] by Thomas Abraham
>> - Modify clk-cpu.c to support Exynos3250
>> - Drop documentation patch on previous patchset[2]
>>  [2] http://www.spinics.net/lists/cpufreq/msg10265.html
>> - Add only operating-points for Exynos3250 without armclk-divider-table
>>
>> Chanwoo Choi (3):
>>   clk: samsung: cpu: Add support for cpu clocks of Exynos3250
>>   clk: samsung: exynos3250: Use cpu-clock provider type to support cpufreq
>>   ARM: dts: Exynos: Add cpu clock table for Exynos3250
>>
>>  arch/arm/boot/dts/exynos3250.dtsi    | 15 +++++++++++++++
>>  drivers/clk/samsung/clk-cpu.c        | 31 +++++++++++++++++++++++++++++++
>>  drivers/clk/samsung/clk-exynos3250.c | 14 ++++++++++----
>>  3 files changed, 56 insertions(+), 4 deletions(-)
> 
> Hi Chanwoo,
> 
> I have reviewed this series and it looks fine. If the cpu clock type
> is merged without any further changes, please add
> Reviewed-by: Thomas Abraham <thomas.ab@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi

