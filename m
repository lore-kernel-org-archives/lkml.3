Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbaD3Khz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:37:55 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:44594 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbaD3Khv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <5360CF8A.5010809@gmail.com>
References: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com>
	<1398848110-6152-4-git-send-email-gautam.vivek@samsung.com>
	<5360CF8A.5010809@gmail.com>
Date: Wed, 30 Apr 2014 16:07:50 +0530
X-Google-Sender-Auth: lKb5ZASbAQl1gaBqM458u96E9MA
Message-ID: <CAFp+6iGDoMQO2-BMdOJjnjnb6_cO1VUTLX2MjRksHmPqYTEq9g@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: dts: Add usb2phy support on exynos5420
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kamil Debski <k.debski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kishon <kishon@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,


On Wed, Apr 30, 2014 at 3:55 PM, Arun Kumar K <arunkk.samsung@gmail.com> wrote:
> Hi Vivek,
>
> On 04/30/14 14:25, Vivek Gautam wrote:
>> Add required device node for usb2phy to let enable USB 2.0
>> support.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
>> index cfa3755..16b860a 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -737,4 +737,14 @@
>>               clock-names = "secss";
>>               samsung,power-domain = <&g2d_pd>;
>>       };
>> +
>> +     phy@12130000 {
>
> As we will be changing over to reference-based updation of nodes in the
> board dts files, it would be good to add node reference also while
> adding new nodes. Like : usb_phy: phy@12130000 {

Sure, i will add node-references to phy as well as the usb nodes in
the subsequent patch.

[snip]


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
