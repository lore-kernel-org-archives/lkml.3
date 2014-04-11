Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaDKIvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:51:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37842 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaDKIvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:51:44 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-e4-5347ad1e16ab
Message-id: <5347AD19.7080905@samsung.com>
Date: Fri, 11 Apr 2014 10:51:37 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent
 connected with GIC
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-4-git-send-email-cw00.choi@samsung.com>
 <20140411040050.GD14934@quad.lixom.net> <53477347.1080603@samsung.com>
In-reply-to: <53477347.1080603@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xa7pya92DDRZvZbG4/uU5q8XnDy3s
	FpPuT2Cx6F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWp65/BrImv2Sz2LtzMqMDt8fmJfUe
	V040sXr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxoI1fWwFZzkqXv/tZm9gbGHvYuTkkBAw
	kbg14wkzhC0mceHeerYuRi4OIYGljBLt0x+wQzifGSW+br/OBlLFK6AlsfPGRTCbRUBV4tjF
	PWA2m4CaxOeGR2A2P1DNmqbrLCC2qECExL3Gw6wQvYISPybfA4uLCHhKPPm7ixFkAbPAP0aJ
	8yu2M4EkhAWSJE6dP8kMsfkUo8TEk++AEhwcnALaEuv/FYDUMAtYS6yctI0RwpaX2LzmLfME
	RsFZSHbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh0fF1B+PSY1aHGAU4
	GJV4eA9ccgsWYk0sK67MPcQowcGsJML7bJl7sBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG8+J0
	rvUzvkzczZ9zODjiI18K75R37N7zuh4naM9hf7b24ulTXDcWsU9Z1JyRkt15/v2vtVylEUZt
	Ad1NfFvL7Y7Muq96rsVd6EhfYePm6ENOpccVisoLcrfUpyf+a0wr7Pl7R2/zJ83Jx/pyrvE0
	S72U2rCE+93cZ38vbIi2Lc0VevnlyHMOJZbijERDLeai4kQAf67tAGwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11.04.2014 06:44, Chanwoo Choi wrote:
> Hi,
>
> On 04/11/2014 01:00 PM, Olof Johansson wrote:
>> On Thu, Apr 10, 2014 at 07:06:02PM +0900, Chanwoo Choi wrote:
>>> This patch add interrupt-parent node to connected with GIC.
>>> All interrupt-related dt nodes need default interrupt-parent node.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> There's no point in splitting these off in separate patches; fold them
>> into one patch that introduces the SoC dtsi, please.
>
> OK, I will consolidate following two patches into one patch.
>
> [PATCH 11/27] ARM: dts: exynos3250: Add GIC dt node for Exynos3250
> [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent connected with GIC
>

I believe the intention was to squash all the patches related to 
exynos3250.dtsi into a single patch called "ARM: dts: Add device tree 
sources for Exynos3250". To retain authorship information, signed-off-by 
tags should be merged from all those patches too.

Best regards,
Tomasz
