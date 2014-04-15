Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaDOIcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:32:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26558 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaDOIcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:32:39 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-5a-534ceea4e500
Message-id: <534CEEA8.6020800@samsung.com>
Date: Tue, 15 Apr 2014 17:32:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, olof@lixom.net, marc.zyngier@arm.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/8] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
 <1397527192-21988-4-git-send-email-cw00.choi@samsung.com>
 <4788081.xvaJfdGTMu@wuerfel>
In-reply-to: <4788081.xvaJfdGTMu@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42JZI2JSrLv0nU+wwfLFTBZ/Jx1jt5i07gCT
	xeX92hbzj5xjtfj8oYXdonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma/H3zj82i1PX
	PwOFJr9ks1g/4zWLxbEZSxgt9u6czOgg6LFm3hpGj5bmHjaP378mMXr8XfWC2ePOtT1sHpuX
	1HtcOdHE6tG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZW0+/ZCr4zVUxs8mzgfEbRxcjJ4eE
	gInE5B1XWCBsMYkL99azdTFycQgJLGWUuDprDzNM0fSvSxkhEosYJebMn8UK4bxmlHh4azZQ
	hoODV0BLYuK7apAGFgFViYeHZrCB2GxA4f0vboDZogJhEiunQ2zjFRCU+DH5HpgtIqAoMfXF
	M2aQmcwCS5kl5i78wwiSEBbwkXh5dR07iC0ksIBRYvFOFpBdnAKaEmsu5IKEmQV0JPa3TmOD
	sOUlNq95CzZHQmAHh0TbyR9sEAcJSHybfAisV0JAVmLTAajHJCUOrrjBMoFRbBaSk2YhGTsL
	ydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQJj//S/ZxN3MN4/YH2IMRlo5URmKdHk
	fGDqyCuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xlW7lz+2e5Tr+EPi1dt38/8riJj5OfPNKG0TXJsqPOPPmtKbDA/CGl9/Mi/IWcMorhT5/dqM
	VzMef7yqGSL3yjjOj8N7ZowQ27tpv38dOr9nhUrQ18Q3OlZ/raeVTAx+O/XizwWi557ofIus
	sJ5WvMhob5gKYztbt/zkJxZLbx6z5Q+4cvfqYiElluKMREMt5qLiRAC6xKJvEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAd0l73yCDRauMbP4O+kYu8WkdQeY
	LC7v17aYf+Qcq8XnDy3sFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXou/d/6xWZy6
	/hkoNPklm8X6Ga9ZLI7NWMJosXfnZEYHQY8189YwerQ097B5/P41idHj76oXzB53ru1h89i8
	pN7jyokmVo++LasYPT5vkgvgjGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBX
	UshLzE21VXLxCdB1y8wBekVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjD
	mLH19Eumgt9cFTObPBsYv3F0MXJySAiYSEz/upQRwhaTuHBvPVsXIxeHkMAiRok582exQjiv
	GSUe3poNVMXBwSugJTHxXTVIA4uAqsTDQzPYQGw2oPD+FzfAbFGBMImV06+wgNi8AoISPybf
	A7NFBBQlpr54xgwyk1lgKbPE3IV/wDYLC/hIvLy6jh3EFhJYwCixeCcLyC5OAU2JNRdyQcLM
	AjoS+1unsUHY8hKb17xlnsAoMAvJillIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85
	P3cTIzixPJPawbiyweIQowAHoxIPr8cEn2Ah1sSy4srcQ4wSHMxKIrxfXgKFeFMSK6tSi/Lj
	i0pzUosPMSYDQ2Ais5Rocj4w6eWVxBsam5gZWRqZG1oYGZuTJqwkznug1TpQSCA9sSQ1OzW1
	ILUIZgsTB6dUAyMnr5iMcf6OJU0BR1mK91+faz3xTUDdGqYNGtGhZUw7Q0NXrjzdnp/787VA
	jF2fspyTiP7JD4cMrPndo5Z8OSL76S7v10NHJp613rJaVO6wv6ppx+Tz1msDFTZE89ZdVlrA
	8WLzTq2vis0aioVf/rO+mfcnszXcS2/VWeP5lQadJ588nSopfUqJpTgj0VCLuag4EQDOCae2
	cAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/15/2014 05:11 PM, Arnd Bergmann wrote:
> On Tuesday 15 April 2014 10:59:47 Chanwoo Choi wrote:
>> This patch add memory mapping for PMU (Power Management Unit) which is used
>> for power control of Exynos3250.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Arnd Bergmann suggested that need proper driver instead of static memory mapping.
>> As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
>> for memory mapping for SYSRAM.
>> [1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
>> [2] https://lkml.org/lkml/2014/4/10/161
>>
>> So, I'm going to re-implement following patch related to static memory mapping
>> after merged Sachin Kamat patch[1].
>>   ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
> 
> I don't think we have a patch for the PMU yet, Sachin was looking at the SYSRAM
> only.

You are right. Sachin's patch only included the solution of SYSRAM memory mapping.
I set out the plan that I would implment proper driver for PMU memory mapping
instead of static method after merged Sachin's patch for SYSRAM.

But,
If you'd like me to implment PMU memory mapping instead of static mapping right now,
I'll implement it for PMU such as Sachin's patch on next posting(v3).

Thanks for your review.

Best Regards,
Chanwoo Choi


