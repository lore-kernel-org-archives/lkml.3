Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaK1B6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:58:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36476 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaK1B56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:57:58 -0500
X-AuditID: cbfee68d-f79296d000004278-8f-5477d67e0a39
Message-id: <5477D67D.2080407@samsung.com>
Date: Fri, 28 Nov 2014 10:57:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de,
        olof@lixom.net, catalin.marinas@arm.com, will.deacon@arm.com,
        s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [03/19] clk: samsung: exynos5433: Add clocks using common clock
 framework
References: <1417073716-22997-4-git-send-email-cw00.choi@samsung.com>
 <54770FA2.9090804@samsung.com>
In-reply-to: <54770FA2.9090804@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWyRsSkWLfuWnmIwe4JQhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1ks2vqF3eLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6Mdxd2sxRM46t43bCCqYFxD3cXIyeHhICJxN1F11khbDGJC/fWs3UxcnEICSxllLjxfAcT
	TNGqbxsZIRLTGSXun7wH5bxmlPh37g5QFQcHr4CWxMc2B5AGFgFViT0NN5hBbDag8P4XN9hA
	bFGBMImV06+wgNi8AoISPybfA7NFBLQlOi/fYwWZySwwl0ViwZq/jCAJYYEIiR9tV8GahQTS
	JF6uPsMIsosTqOHjQlYQk1lAT+L+RS2QCmYBeYnNa94yQ9x8g0PiUXcdxDkCEt8mH2IBKZcQ
	kJXYdACqRFLi4IobLBMYxWYhOWgWwtBZSIYuYGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7
	iRGYIE7/e9a7g/H2AetDjAIcjEo8vBYHykKEWBPLiitzDzGaAh0xkVlKNDkfmIbySuINjc2M
	LExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgXL32slOy0fINuqLn
	UmwmfZ29w+TlcrfWc53p/JKsz57dC20V/Jix7XTi3i2lEwV2Xcmckhez9dgDheaF/0sKT3F1
	/Z6arCpw6pf/TiOxGXm57W+Sv3FoVP99rWt0ZY2X1dRCxV1fzoqplX1VsRe7/eW66K6dgUtS
	A59vO+NyVmCp5MPbTL9uBiixFGckGmoxFxUnAgBzIRV/CwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQd26a+UhBo8XcVg8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbTPmznMli0+NrrBaX
	d81hs5hxfh+TxdLrF5ksTl3/zGaxaOsXdovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZry7sJulYBpfxeuGFUwNjHu4uxg5OSQETCRWfdvI
	CGGLSVy4t56ti5GLQ0hgOqPE/ZP3GCGc14wS/87dYepi5ODgFdCS+NjmANLAIqAqsafhBjOI
	zQYU3v/iBhuILSoQJrFy+hUWEJtXQFDix+R7YLaIgLZE5+V7rCAzmQXmskgsWPMXbLOwQITE
	j7arYM1CAmkSL1efYQTZxQnU8HEhK4jJLKAncf+iFkgFs4C8xOY1b5knMArMQrJhFkLVLCRV
	CxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ6BnUjsYVzZYHGIU4GBU4uG1OFAWIsSa
	WFZcmXuIUYKDWUmEd8H58hAh3pTEyqrUovz4otKc1OJDjKZA/09klhJNzgcmx7ySeENjEzMj
	SyNzQwsjY3Mlcd4bN3NDhATSE0tSs1NTC1KLYPqYODilGhj5GEI0Ipykmx6fvK0jmh57/BDH
	7LTidcIPZfglrFp+vreMjauJWrHUYM2u0owFKZ+26O86va+VcZ3M4wSx5/vffm9ecPXYvTPh
	Mjr1QkpHX9sL5u5oYayLdJrb98w54/iSBK7Win8Fn44IFwR/zbJke79N9lTcsdns6Qs/bC9s
	EQyRcX58wViJpTgj0VCLuag4EQCUeQTVVgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 11/27/2014 08:48 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Thursday 27 November 2014 01:05 PM, Chanwoo Choi wrote:
>> This patch adds the support for CMU (Clock Management Units) of Exynos5433
>> which is 64bit SoC and has Octa-cores. This patch supports necessary clocks
>> for kernel boot as following:
>> - PLL/MMC/UART/MCT/I2C/SPI
>>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>>
>> ---
>> drivers/clk/samsung/Makefile           |   1 +
>>   drivers/clk/samsung/clk-exynos5433.c   | 971 +++++++++++++++++++++++++++++++++
>>   include/dt-bindings/clock/exynos5433.h | 200 +++++++
>>   3 files changed, 1172 insertions(+)
>>   create mode 100644 drivers/clk/samsung/clk-exynos5433.c
>>   create mode 100644 include/dt-bindings/clock/exynos5433.h
>>

(snip)

>> +
>> +static struct samsung_div_clock top_div_clks[] __initdata = {
>> +    /* DIV_TOP2 */
>> +    DIV(CLK_DIV_ACLK_FSYS_200, "div_aclk_fsys_200", "mout_bus_pll_user",
>> +            DIV_TOP2, 0, 3),
>> +
>> +    /* DIV_TOP3 */
>> +    DIV(CLK_DIV_ACLK_IMEM_SSSX, "div_aclk_imem_sssx",
>> +            "mout_bus_pll_user", DIV_TOP3, 24, 3),
> 
> Isn't this clock name should be div_aclk_imem_sssx_266 as per UM?

You're right. So, I fxied clock name on patch11[1] for CMU_BUSx domains.
- [1] [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains

 	/* DIV_TOP3 */
-	DIV(CLK_DIV_ACLK_IMEM_SSSX, "div_aclk_imem_sssx",
+	DIV(CLK_DIV_ACLK_IMEM_SSSX_266, "div_aclk_imem_sssx_266",
 			"mout_bus_pll_user", DIV_TOP3, 24, 3),

Best Regards,
Chanwoo Choi




