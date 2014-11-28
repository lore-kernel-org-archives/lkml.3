Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaK1MHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:07:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaK1MHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:07:11 -0500
Message-ID: <54786567.4050305@suse.de>
Date: Fri, 28 Nov 2014 13:07:03 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?B?6rmA7ZWZ7KO8?= <ruppi.kim@hardkernel.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "PIN CONTROL SUBSY..." <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] pinctrl: exynos: add exynos5410 SoC specific data
References: <547104D5.4030803@suse.de>	<1416695185-5198-1-git-send-email-afaerber@suse.de> <CACRpkdZie8JJGxSPkc8PPvC3qZkWhe5WqmpSKSoDFwqRd6tR_Q@mail.gmail.com>
In-Reply-To: <CACRpkdZie8JJGxSPkc8PPvC3qZkWhe5WqmpSKSoDFwqRd6tR_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.11.2014 um 12:59 schrieb Linus Walleij:
> On Sat, Nov 22, 2014 at 11:26 PM, Andreas Färber <afaerber@suse.de> wrote:
> 
>> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
>>
>> Add Samsung EXYNOS5410 SoC specific data to enable pinctrl
>> support for all platforms based on EXYNOS5410.
>>
>> Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>
>> [AF: Rebased onto Exynos5260 and irq_chip consolidation]
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>  v2 -> v3:
>>  * Rebased (.svc, .{g,w}eint_{con,mask,pend} fields dropped)
>>
>>  v1 -> v2:
>>  * Filled in Sob from Hakjoo Kim
> 
> Is this based on the pinctrl devel branch so I can apply it?

It was based on the Samsung for-next tree. I can rebase if needed.

> I'd like Tomasz ACK on it first though.

Thanks,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
