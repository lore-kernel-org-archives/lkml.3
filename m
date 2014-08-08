Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaHHN1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:27:13 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52763 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbaHHN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:27:09 -0400
Message-ID: <53E4CE93.9000504@gmail.com>
Date: Fri, 08 Aug 2014 15:20:19 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYg==?= =?UTF-8?B?ZXI=?= 
	<afaerber@suse.de>
CC: Mark Rutland <mark.rutland@arm.com>, Tarek Dakhran <t.dakhran@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Hakjoo Kim <ruppi.kim@hardkernel.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 3/5] pinctrl: exynos: add exynos5410 SoC specific data
References: <1406549892-5558-1-git-send-email-afaerber@suse.de> <1406549892-5558-4-git-send-email-afaerber@suse.de> <CACRpkdazZTUS50_mrXd+sNVAdf2m7meT1_LX5r6BKg3U-tC3Kw@mail.gmail.com>
In-Reply-To: <CACRpkdazZTUS50_mrXd+sNVAdf2m7meT1_LX5r6BKg3U-tC3Kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Andreas,

On 08.08.2014 14:55, Linus Walleij wrote:
> On Mon, Jul 28, 2014 at 2:18 PM, Andreas Färber <afaerber@suse.de> wrote:
> 
>> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
>>
>> Add Samsung EXYNOS5410 SoC specific data to enable pinctrl
>> support for all platforms based on EXYNOS5410.
>>
>> Cc: Hakjoo Kim <ruppi.kim@hardkernel.com>
>> [AF: Rebased onto Exynos5260]
> 
> I'm waiting for Tomasz to review this before applying.

Thanks for the reminder. I'm currently on holidays and I'm not following
the lists too closely, so sorry if I happen to miss some patches.

In general the changes look good, although I can't verify whether the
data being added really match the hardware, as I don't have access to
detailed information about Exynos5410. Also I believe this patch needs
to be rebased onto current pinctrl tree as several (conflicting)
improvements to the pinctrl-samsung driver hit it before this patch was
posted.

Best regards,
Tomasz
