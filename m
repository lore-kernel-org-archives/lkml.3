Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaCQB6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:58:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:58:20 -0400
X-AuditID: cbfee68f-b7f156d00000276c-ca-532656b0a339
Message-id: <532656B1.2010907@samsung.com>
Date: Mon, 17 Mar 2014 10:58:09 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <5323432E.5060005@samsung.com>
In-reply-to: <5323432E.5060005@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkUHdDmFqwwbSH8hYdPb9ZLOYfOcdq
	ce7VSkaLs01v2C0Wti1hsbi8aw6bxefeI4wWM87vY7JYev0ik8XtxhVsFm9+nGWymDB9LYvF
	4xVv2S1eHWxjsVg/4zWLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mp4tnklc8FeqYrFPxazNjD2iHYxcnJICJhItKw7xQJhi0lc
	uLeerYuRi0NIYCmjxMUJl1hhipbsvscKkZjOKLHiZSMLhPOKUeLFogdg7bwCWhKdG1qBqjg4
	WARUJU7/jQAJswGF97+4wQZiiwqESaycfgWqXFDix+R7YLaIgIrE5VPTGUFsZoGvTBI35zGB
	2MICIRK3Dh0B6xUSSJNY2dMAFucU0JZ4tmoGO0S9jsT+1mlsELa8xOY1b5khjp7JIbHhlgSI
	zSIgIPFt8iEWkNMkBGQlNh2AKpGUOLjiBssERrFZSC6ahWTqLCRTFzAyr2IUTS1ILihOSi8y
	1itOzC0uzUvXS87P3cQIjPDT/57172C8e8D6EGMy0MqJzFKiyfnABJFXEm9obGZkYWpiamxk
	bmlGmrCSOO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiT9TZbe3xnPrr5/vlX1XMK
	rm7XE/GecSqzk2eTrdFhOzeb2Z17ZOV8EheuL5oTvq5j0qK3crZ/TlRvfWZ781PRHIHsiQbe
	PBlBtzYqcYtVijeZHrOdrCB88+Li2smKs7oyJrS/Xy8npSU6138W+yuhjCmt++4eMzO+Jufy
	yOKk/67WU5NOatoosRRnJBpqMRcVJwIAkElhQQYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsVy+t9jQd0NYWrBBm2fxCw6en6zWMw/co7V
	4tyrlYwWZ5vesFssbFvCYnF51xw2i8+9RxgtZpzfx2Sx9PpFJovbjSvYLN78OMtkMWH6WhaL
	xyveslu8OtjGYrF+xmsWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx49nmlcwFe6UqFv9Y
	zNrA2CPaxcjJISFgIrFk9z1WCFtM4sK99WxdjFwcQgLTGSVWvGxkgXBeMUq8WPSABaSKV0BL
	onNDK1AHBweLgKrE6b8RIGE2oPD+FzfYQGxRgTCJldOvQJULSvyYfA/MFhFQkbh8ajojiM0s
	8JVJ4uY8JhBbWCBE4tahI2C9QgJpEit7GsDinALaEs9WzWCHqNeR2N86jQ3ClpfYvOYt8wRG
	gVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEJ5Jn0DsZVDRaHGAU4
	GJV4eCcoqwULsSaWFVfmHmKU4GBWEuFNMAcK8aYkVlalFuXHF5XmpBYfYkwGBsBEZinR5Hxg
	cssriTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsa8qeZ+nzP4
	eTQu6odFzNSaLGCcKG99elXdhn3sOV7sYqYXrTQ7bnVOWDeVS3Cv45F9mtU2goxPdEp4/YI0
	pr9VOHWoo5onvvdw08zuYwszmmoZWDPnFFvqCCktfbfs78+POR+EJ5365Jb2v+OTb2J7ZP7d
	CRtW6FnEeKkcOSsmPvnu9cD/0UosxRmJhlrMRcWJAKQN9UVkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/15/2014 02:58 AM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 13.03.2014 09:17, Chanwoo Choi wrote:
>> This patchset support devicetree and use common ppmu driver instead of
>> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
>> get the resources for busfreq from dt data by using DT helper function.
>> - PPMU register address
>> - PPMU clock
>> - Regulator for INT/MIF block
>>
>> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
>> To remove power-leakage in suspend state, before entering suspend state,
>> disable ppmu clocks.
>>
>> Changes from v1:
>> - Add exynos4_bus.txt documentation for devicetree guide
>> - Fix probe failure if CONFIG_PM_OPP is disabled
>> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
>> - Add additionally comment for PPMU usage instead of previous PPC
>> - Split separate patch to remove ambiguous of patch
>>
>> Chanwoo Choi (8):
>>    devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>>    devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>>    devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>>    devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>>    devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
>>    devfreq: exynos4: Fix power-leakage of clock on suspend state
>>    devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>>    devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
>>
>>   .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
>>   drivers/devfreq/Kconfig                            |   1 +
>>   drivers/devfreq/exynos/Makefile                    |   2 +-
>>   drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
>>   4 files changed, 341 insertions(+), 126 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>
> 
> I have reviewed this series and there are several comments that I'd like to ask you to address. Please see my replies to particular patches.

OK, I'll fix it about your comment.

> 
> However, this driver, even after applying your series, is still far from a state that would allow it to be enabled. The most important issue is direct access to CMU registers, based on static mapping, which is not allowed on multiplatform kernels and multiplatform-awareness for drivers is currently a must.
> 
> To allow this driver to be enabled, it needs to be converted to use common clock framework functions to configure all clocks, e.g. clk_set_rate(), clk_set_parent(), etc., without accessing CMU registers directly.
> 
> Of course as long as the driver is effectively unusable, to keep development, we can proceed with refactoring it step-by-step and your series would be basically the first step, after addressing the review comments.
> 

I agree your opinion. When setting frequency of memory bus, this driver access
directly to CMU registers. I know it should be modified by using common clk
framework as your comment.

I'll send patch set about using common clk framework instead of CMU register
based on static mapping after finished the review and apply of this patch set as next step.

Thanks for your review.

Best Regards,
Chanwoo Choi

