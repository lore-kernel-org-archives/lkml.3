Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaI3Jvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:51:40 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53367 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaI3Jvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140929144752.GP16977@sirena.org.uk>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
	<1411992293-7729-4-git-send-email-zhang.lyra@gmail.com>
	<20140929144752.GP16977@sirena.org.uk>
Date: Tue, 30 Sep 2014 17:51:37 +0800
Message-ID: <CAAfSe-sdz=DkJteLCLwLg_2-KWRY8mp1O+ZZ=j2YJtskXNT6Mw@mail.gmail.com>
Subject: Re: [PATCH 3/6] arm64: dts/Makefile: Add support for Spreadtrum's
 Shark64 SoC.
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz,
        Kumar Gala <galak@codeaurora.org>, mark.rutland@arm.com,
        m-karicheri2@ti.com, pawel.moll@arm.com,
        Ramkumar Ramachandra <artagnon@gmail.com>, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com,
        Orson Zhai <orsonzhai@gmail.com>, geng.ren@spreadtrum.com,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

[use plain text pattern to send again]

2014-09-29 22:47 GMT+08:00 Mark Brown <broonie@kernel.org>:
> On Mon, Sep 29, 2014 at 08:04:50PM +0800, zhang.lyra@gmail.com wrote:
>
>>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>> +dtb-$(CONFIG_ARCH_SHARK64) += sprd_shark64.dtb
>
> It's better to keep lists in Makefiles and Kconfig sorted
> alphanumerically, that way there's less chance of conflicts when
> applying patches or merging different branches.

Thank you very much for your review and explain why this way is
better. I'll address this change in V2.

Best regards,
Chunyan
