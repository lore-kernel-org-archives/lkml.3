Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaCQB4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:56:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17125 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:56:28 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-a9-5326564a27ce
Message-id: <5326564C.5050407@samsung.com>
Date: Mon, 17 Mar 2014 10:56:28 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 0/8] devfreq: exynos4: Support dt and use common ppmu
 driver
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <2117336.08cyWySR1X@amdc1032> <532273FB.6040303@samsung.com>
 <2149456.oUDFM14jk3@amdc1032>
In-reply-to: <2149456.oUDFM14jk3@amdc1032>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkSNcrTC3YYM56a4uNM9azWsw/co7V
	4tyrlYwWZ5vesFssbFvCYnF51xw2i8+9RxgtZpzfx2Sx9PpFJovbjSvYLN78OMtkMWH6WhaL
	xyveslu8OtjG4sDnsWbeGkaPlcu/sHks3vOSyaNvyypGj+M3tjN5fN4k57FxbmgAexSXTUpq
	TmZZapG+XQJXRsel22wFp1Qq5mw9x9bAuFu2i5GTQ0LARGLm3gfsELaYxIV769m6GLk4hASW
	MkqcnHuSBaaof85dZojEIkaJ9jlv2CGcV4wS77dMYAWp4hXQkjiyZS2YzSKgKnFmwlKwsWxA
	8f0vbrCB2KICYRIrp19hgagXlPgx+R6YLSJgIbF2xVsWkKHMAreYJM5+mwKWEBYIkbh16AjU
	TUsYJY5/agRyODg4gaa+aK0EqWEW0JHY3zqNDcKWl9i85i3YqRICEzkkZp7axwhxkYDEt8mH
	WEB6JQRkJTYdYIZ4TVLi4IobLBMYxWYhuWkWkrGzkIxdwMi8ilE0tSC5oDgpvchQrzgxt7g0
	L10vOT93EyMwpk//e9a7g/H2AetDjMlAKycyS4km5wNTQl5JvKGxmZGFqYmpsZG5pRlpwkri
	vEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MFpLFfQqsXev+KdkwnouZc9zj1qviuJp
	atdcrphEhx15u2bm0wlvevRe/nyfwW+rdCT6S/qap7dfV1b/jGUr55n0S2BN63HvJ9GOzkbG
	3vnMenk6W71893f+6ZipwmQv13HROGnPX79L/rN/MQv/mVW5REvakuPS7rNSk407mo0z61sj
	bbcWKbEUZyQaajEXFScCAFmIttf/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV2vMLVgg90XDC02zljPajH/yDlW
	i3OvVjJanG16w26xsG0Ji8XlXXPYLD73HmG0mHF+H5PF0usXmSxuN65gs3jz4yyTxYTpa1ks
	Hq94y27x6mAbiwOfx5p5axg9Vi7/wuaxeM9LJo++LasYPY7f2M7k8XmTnMfGuaEB7FENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QDcrKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDM6Lt1mKzilUjFn6zm2Bsbdsl2MnBwS
	AiYS/XPuMkPYYhIX7q1n62Lk4hASWMQo0T7nDTuE84pR4v2WCawgVbwCWhJHtqwFs1kEVCXO
	TFjKDmKzAcX3v7jBBmKLCoRJrJx+hQWiXlDix+R7YLaIgIXE2hVvWUCGMgvcYpI4+20KWEJY
	IETi1qEjUKuXMEoc/9QI5HBwcAJNfdFaCVLDLKAjsb91GhuELS+xec1b5gmMArOQ7JiFpGwW
	krIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYITxjOpHYwrGywOMQpwMCrx8E5QVgsW
	Yk0sK67MPcQowcGsJMKbYA4U4k1JrKxKLcqPLyrNSS0+xJgMDIKJzFKiyfnAZJZXEm9obGJm
	ZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYz5d0tCj1vu8p1/msVQ7Czn
	Hr/FTBbXzpkKLnb1WzXnpzeXw/Sjz5gPu0ybV+L1MvpY7iTz2/yhJ/VkvtrUcnhsZtXcafKb
	MZ/zm8BR7rQlM/32PWAX+e3V2V/TITDl5uusM+nTvp688L/x0Gc75TkmG/M+zVDZM7n2QwPb
	fwVZ39O/HPnbLtQosRRnJBpqMRcVJwIAa/HPn1wDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 03/14/2014 07:47 PM, Bartlomiej Zolnierkiewicz wrote:
> On Friday, March 14, 2014 12:14:03 PM Chanwoo Choi wrote:
>> Hi,
>>
>> On 03/14/2014 01:43 AM, Bartlomiej Zolnierkiewicz wrote:
>>>
>>> Hi,
>>>
>>> On Thursday, March 13, 2014 05:17:21 PM Chanwoo Choi wrote:
>>>> This patchset support devicetree and use common ppmu driver instead of
>>>> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
>>>> get the resources for busfreq from dt data by using DT helper function.
>>>> - PPMU register address
>>>> - PPMU clock
>>>> - Regulator for INT/MIF block
>>>>
>>>> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
>>>> To remove power-leakage in suspend state, before entering suspend state,
>>>> disable ppmu clocks.
>>>>
>>>> Changes from v1:
>>>> - Add exynos4_bus.txt documentation for devicetree guide
>>>> - Fix probe failure if CONFIG_PM_OPP is disabled
>>>> - Fix typo and resource leak(regulator/clock/memory) when happening probe failure
>>>> - Add additionally comment for PPMU usage instead of previous PPC
>>>> - Split separate patch to remove ambiguous of patch
>>>>
>>>> Chanwoo Choi (8):
>>>>   devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>>>>   devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>>>>   devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>>>>   devfreq: exynos4: Fix bug of resource leak and code clean on probe()
>>>>   devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
>>>>   devfreq: exynos4: Fix power-leakage of clock on suspend state
>>>>   devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
>>>>   devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
>>>>
>>>>  .../devicetree/bindings/devfreq/exynos4_bus.txt    |  49 +++
>>>>  drivers/devfreq/Kconfig                            |   1 +
>>>>  drivers/devfreq/exynos/Makefile                    |   2 +-
>>>>  drivers/devfreq/exynos/exynos4_bus.c               | 415 ++++++++++++++-------
>>>>  4 files changed, 341 insertions(+), 126 deletions(-)
>>>>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
>>>
>>> Thanks for updating this patchset.  There are still some minor issues
>>> left though:
>>>
>>> - patch #4 should be at beginning of the patch series
>>>
>>> - moving of devfreq_unregister_opp_notifier(dev, data->devfreq) from
>>>   exynos4_bus_exit() to exynos4_busfreq_remove() should be in patch #4
>>>   (which should really be at the beggining of patch series) not #3
>>>
>>> - handling of iounmap(data->ppmu[i].hw_base) should be added to
>>>   exynos4_bus_exit() in patch #2 not #3
>>>
>>> - patch #8 summary and description should mention fact that it adds DT
>>>   binding documentation (not the driver itself) and the patch itself
>>>   can be slighlty polished
>>
>> OK, I'll re-order the sequence of patchset and modify minior issues about your comment.
>> Also, I'll modify the patch description for patch8.
>>
>>>
>>> One important note about this patchset not mentioned in the cover
>>> letter is that it is improving currently unused driver (because of
>>> DT-only mach-exynos conversion the only user was removed in June 2013
>>> and from the reading the code I suspect that even that user hadn't
>>> worked previously).  As such this patch series should not cause any
>>> regressions.
>>
>> I don't understand correct your meaning.I explained DT support on upper
>> patchset description by using DT helper function and I added PPMU descritpion.
>> Also, Each patch include detailed description of patch content.
> 
> Everything is okay, I just noted that since there are no users of this
> driver currently (the only user was NURI and it was removed by DT
> conversion of mach-exynos) it should be okay to merge the patch series
> quickly once reviewed and acked by the respective maintainers.
> 
>> What is more needed?
> 
> Users of the driver? ;)
> 
> Your patchset adds DT support and fixes to the driver but it doesn't
> add actual users of the driver to arch/arm/boot/dts/ files.

Ah, I didn't understand 'users'  meanings.

Now, clk-exynos4.c driver in mainline don't provide the clocks for PPMU IP. So, I can't add dt node of exynos4_busfreq to exynos4210.dtsi/exynos4x12.dtsi/exynos4210-trats.dts/exynos4412-trats2.dts.

First of all, I will add the ppmu clocks to clk-exynos4.c driver and then modify dts file for exynos4_busfreq as your comment. That which add the ppmu clocks is apart from this patch set.

Thanks for your comment.

Best Regards,
Chanwoo Choi

