Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaJXORd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:17:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32124 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaJXORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:17:31 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-76-544a5f774742
Message-id: <544A5F69.7080406@samsung.com>
Date: Fri, 24 Oct 2014 16:17:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, kgene.kim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1414148828-23719-1-git-send-email-cw00.choi@samsung.com>
 <1414148828-23719-2-git-send-email-cw00.choi@samsung.com>
 <544A402F.1010207@samsung.com> <544A5D2D.2040501@samsung.com>
In-reply-to: <544A5D2D.2040501@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7rl8V4hBp+mW1hc//Kc1eLPhFY2
	i0n3J7BY9C64ymZxtukNu8XlXXPYLGac38dkMWPySzaLVbv+MDpweuycdZfdo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDI6Hl5gLejiqtjefJC1gXEFRxcjJ4eEgIlE65OnjBC2mMSFe+vZ
	uhi5OIQEljJKvH84ix3C+cQo8frJOyaQKl4BLYm+ztPMIDaLgKrE98szweJsAoYSvUf7wCaJ
	CkRInLy7hx2iXlDix+R7LCC2iICGxMy/VxhBhjILXGeU+PNrHtggYYE4ibe32lkhth1klPh+
	4hFYglNAW2LfipNAHRxAHXoS9y9qgYSZBeQlNq95yzyBUWAWkh2zEKpmIalawMi8ilE0tTS5
	oDgpPddIrzgxt7g0L10vOT93EyMkzL/uYFx6zOoQowAHoxIP748tniFCrIllxZW5hxglOJiV
	RHj9/b1ChHhTEiurUovy44tKc1KLDzEycXBKNTCKPGx3qpP6/mOl+RYTtqCXi6X+WMotved9
	cnb5h77H0T1cjg8/JK10OSfoLBk5LSfCb45L/0K3dRUVwZP7erZd6wkLeHntSEvr7/z/zbtZ
	AqYIrG3fb3TqcPZ/4wNZx6KkHHfIX/psvL/yRaPXbOH8HDmululyrss5S2b/0PM5IT95JWfr
	4kQlluKMREMt5qLiRABl2i1PUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 24/10/14 16:07, Chanwoo Choi wrote:
[...]
>> How about prefixing the table names below with "exynos4415", rather than
>> "samsung" ?
> 
> 'struct samsung_fixed_factor_clock' is common for Exynos SoC.
> 
> Do you means that add 'exynos4415' prefix as following:
> - fixed_factor_clks -> exynos4415_fixed_factor_clks

Yes, it makes sense IMHO, even though those symbols are static.
It's done like that in other SoC drivers, e.g. exynos3250.

>>> +static struct samsung_fixed_factor_clock fixed_factor_clks[] __initdata = {
>>
>>> +};
>>> +
>>> +static struct samsung_fixed_rate_clock fixed_rate_clks[] __initdata = {
>>> +	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
>>> +};
>>> +
>>> +static struct samsung_mux_clock mux_clks[] __initdata = {
>>
>>> +};
>>> +
>>> +static struct samsung_div_clock div_clks[] __initdata = {
>>
>>> +};
>>> +
>>> +static struct samsung_gate_clock gate_clks[] __initdata = {
> 
> Do you want to change structure naming as following?
> fixed_factor_clks -> exynos4415_fixed_factor_clks
> fixed_rate_clks -> exynos4415_fixed_rate_clks
> mux_clks -> exynos4415_mux_clks
> div_clks -> exynos4415_div_clks
> gate_clks -> exynos4415_gate_clks

Yes, please.

-- 
Thanks,
Sylwester
