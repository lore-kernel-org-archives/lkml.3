Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaGaAeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:34:03 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33398 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaGaAeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:34:01 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:781a:650a:7145:334d]
In-Reply-To: <00c901cfa9fc$727b4e10$5771ea30$@samsung.com>
References: <1406463725-4208-1-git-send-email-afaerber@suse.de>
	<53D4EFBB.6000404@suse.de>
	<00c901cfa9fc$727b4e10$5771ea30$@samsung.com>
Date: Wed, 30 Jul 2014 17:33:59 -0700
Message-ID: <CAOesGMjh=xMZ3vB45ofh=CLjTFDMQxSxus5q_P67XQSbwg6-+A@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM: EXYNOS: Fix Exynos5410 boot
From: Olof Johansson <olof@lixom.net>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 27, 2014 at 5:39 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Andreas Färber wrote:
>>
>> Am 27.07.2014 14:22, schrieb Andreas Färber:
>> > Hello,
>> >
>> > This mini-series unbreaks booting on 5410 based ODROID-XU.
>> >
>> > Since I do not have access to a TRM, the address is a guess based on
>> > 5250 and 5410. Such a node was not present in the 3.14 downstream tree.
>>
>> s/5410/5420/
>>
> OK.
>
>> >
>> > Regards,
>> > Andreas
>> >
>> > Andreas Färber (3):
>> >   Documentation: devicetree: Document exynos5410 PMU
>> >   ARM: dts: exynos: Add PMU to Exynos5410
>> >   ARM: EXYNOS: Add support for Exynos5410 PMU
>> >
>> >  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>> >  arch/arm/boot/dts/exynos5410.dtsi                     | 5 +++++
>> >  arch/arm/mach-exynos/exynos.c                         | 1 +
>> >  3 files changed, 7 insertions(+)
>>
> Andreas, thanks.
>
> I'll apply this whole series.

We're getting close to the merge window. I'd prefer not to have to
start reverting samsung code to recover from these regressions, so
please send this up very soon.


-Olof
