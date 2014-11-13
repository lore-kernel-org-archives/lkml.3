Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaKMCeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:34:11 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62401 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbaKMCeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:34:10 -0500
Message-ID: <5464189B.1020305@samsung.com>
Date: Thu, 13 Nov 2014 11:34:03 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/2] ARM: dts: Fix the number of DMA channels for Exynos3250/4
References: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com> <5462F24E.7030100@samsung.com>
In-Reply-To: <5462F24E.7030100@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 14:38, Chanwoo Choi wrote:
> Dear Kukjin,
>
> Please ignore this patchset because this patchset are wrong.
>
OK.

- Kukjin

> Best Regards,
> Chanwoo Choi
>
> On 11/12/2014 11:50 AM, Chanwoo Choi wrote:
>> This patch fix minor issuse to correct the number of DMA channels for
>> Exynos3250 and Exynos4 series. The PL330 DMA of Exynos3250/Exynos4 support
>> 16 channels simultaneously but, PL330 DMA driver don't use 'dma-channels'
>> property directly. This patchset fix the correct information
>> of Exynos3250/Exynos4's PL330 DMA simply.
>>
>> Changes from v1:
>> - Fix the nubmer for DMA channesl for Exynos4415
>>
>> Chanwoo Choi (2):
>>    ARM: dts: Fix the number of DMA channels for Exynos3250
>>    ARM: dts: Fix the number of DMA channels for Exynos4
>>
>>   arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
>>   arch/arm/boot/dts/exynos4.dtsi    | 4 ++--
>>   arch/arm/boot/dts/exynos4415.dtsi | 4 ++--
>>   3 files changed, 6 insertions(+), 6 deletions(-)
