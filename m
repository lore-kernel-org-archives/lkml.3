Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaBUQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:50:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18360 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaBUQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:50:51 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-f6-530783e824db
Message-id: <530783E4.6090206@samsung.com>
Date: Fri, 21 Feb 2014 17:50:44 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        linux-samsung-soc@vger.kernel.org, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for
 ARCH_EXYNOS
References: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com>
 <1753680.KKj0Q1erxA@wuerfel> <53077DE0.7080108@samsung.com>
 <1888663.ccFYmJ9QJl@wuerfel>
In-reply-to: <1888663.ccFYmJ9QJl@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xq7ovmtmDDWa947L4O+kYu8XlhZdY
	LS487WGz2PT4GqvF5V1z2CxmnN/H5MDm8fvXJEaPzUvqPfq2rGL0OH5jO5PH501yAaxRXDYp
	qTmZZalF+nYJXBm7TqgUTGCpeHz6IksD42TmLkZODgkBE4mlVw+yQ9hiEhfurWfrYuTiEBJY
	yiix7s4+RgjnE6PEmZZfbCBVvAJaEs9OzQDrYBFQlVjfNp8JxGYTMJToPdrHCGKLCkRIvDo7
	kQWiXlDix+R7YLaIgKLE1BfPwDYzC0xklNj+3hPEFgaqv7twB9SyxYwST1YeAiri4OAU0JTY
	9dYOol5HYn/rNDYIW15i85q3zBMYBWYhWTELSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfm
	pesl5+duYoQE9tcdjEuPWR1iFOBgVOLhdUhlDxZiTSwrrsw9xCjBwawkwtscDRTiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAyMA6+VThjP3y3+SVvQ/bvdpzWeXKjo3nDm5d55KV2GRvdM/YiOl4
	qvBhs2KPi5PFT4Wlvzo1RfnTRa/zExmVtTbeiOM+O2XG9R0C7Grit9uOauhXLvHomVjJmJDX
	K//qhrYg75eqFAGf+n234to4JM5tvLHW/FDRzwtf2BI0+uctveH0eQXHBCWW4oxEQy3mouJE
	AA3ffsJKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/14 17:41, Arnd Bergmann wrote:
> On Friday 21 February 2014 17:25:04 Sylwester Nawrocki wrote:
>> > 
>> > Hmm, good point, I will modify it that way.
>> > 
>> > For patch 1/2 I guess it should be:
>> > 
>> > "default ARCH_S5PV210 || ARCH_EXYNOS"
>> > 
>> > or rather
>> > 
>> > "default y if ARCH_S5PV210 || ARCH_EXYNOS" ?
>
> Right. I'd probably use the first syntax, but it doesn't really matter.

Oops, I've already sent patch using the second one, as it seemed
more common.

Thanks,
Sylwester

