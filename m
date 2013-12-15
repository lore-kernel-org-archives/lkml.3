Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3LOOPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 09:15:16 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41182 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3LOOPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 09:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <6057819.pWzq25qpVf@flatron>
References: <1386998490-19456-1-git-send-email-kasimling@gmail.com> <6057819.pWzq25qpVf@flatron>
From: Alex Ling <kasimling@gmail.com>
Date: Sun, 15 Dec 2013 22:14:53 +0800
Message-ID: <CAHaF_kimHy38cL79uZDRy-OWCDs2m0TRAQyT=JaHVfWgHLz2JA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ARM: dts: Add missing clocks for exynos4412 dwmmc node
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for pointing out this, Tomasz. I'll use those patches instead.


Regards,
Alex

On Sat, Dec 14, 2013 at 9:24 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Alex,
>
> On Saturday 14 of December 2013 13:21:30 Alex Ling wrote:
>> This patch adds "biu" and "ciu" clocks for exynos4412 dwmmc
>> node. Without this patch, dwmmc host driver will skip enabling the
>> two clocks and it will break dwmmc host function on exynos4412.
>> Tested on FriendlyARM TINY4412 board.
>>
>> Signed-off-by: Alex Ling <kasimling@gmail.com>
>> ---
>> Changes for v2:
>>    - Fix patch description as Mark Rutland suggested
>>
>>  arch/arm/boot/dts/exynos4412.dtsi |    2 ++
>>  1 file changed, 2 insertions(+)
>
> The patch is correct, but unfortunately it's not the only thing that
> is wrong with MSHC device tree node for Exynos4x12.
>
> Please refer to my series fixing DW-MSHC support on Exynos4x12 (and
> enabling it on TRATS2 board):
> http://www.spinics.net/lists/arm-kernel/msg293652.html
>
> Best regards,
> Tomasz
>
