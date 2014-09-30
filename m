Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaI3KIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:08:48 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:34781 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaI3KIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <3268049.TolhrmBCZA@wuerfel>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
	<1411992293-7729-7-git-send-email-zhang.lyra@gmail.com>
	<3268049.TolhrmBCZA@wuerfel>
Date: Tue, 30 Sep 2014 18:08:44 +0800
Message-ID: <CAAfSe-sU0w6XTQ1yJd6v0q1eT5H3wvJXJYVBE8dv--QyZ3wHxw@mail.gmail.com>
Subject: Re: [PATCH 6/6] Documentation: Add entry for Spreadtrum's Shark64 SoC
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@linaro.org>,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        Ramkumar Ramachandra <artagnon@gmail.com>, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com,
        Orson Zhai <orsonzhai@gmail.com>, geng.ren@spreadtrum.com,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd

[use plain text pattern to send again]

Thank you very much for your review in detail so carefully. I'll
address these changes which you mentioned in this patch set in V2, but
the days from tomorrow to 10.7 are Chinese holidays, I'm going to send
PATCHv2 a few days later.

I'm also sorry that make you confused about my name, I'll solve this
problem in the next submit.

Thanks,
Chunyan

2014-09-29 21:59 GMT+08:00 Arnd Bergmann <arnd@arndb.de>:
> On Monday 29 September 2014 20:04:53 zhang.lyra@gmail.com wrote:
>> From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
>>
>> Adds a devicetree binding documentation for Spreadtrum's Shark64 SoC.
>>
>> Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
>
> One more thing: The email addresses look wrong, please use the form in
> which you normally write the names, such as
>
> Signed-off-by: Zhang Chunyan <chunyan.zhang@spreadtrum.com>
>
> You can set the user name that git will add using the
> 'git config --global user.name ...'.
>
> Also, I notice that the email from which the patch is sent does not
> match the last 'Signed-off-by' line. If Chunyan and Lyra are both
> your names, better pick one that you use for both the email and the
> signoff. If you are Lyra and are posting a patch from Chunyan, please
> add your own line below hers, like
>
> Signed-off-by: Zhang Chunyan <chunyan.zhang@spreadtrum.com>
> Signed-off-by: Zhang Lyra <zhang.lyra@gmail.com>
>
> so that you include everybody who was involved in sending the
> patch, but have your own list last.
>
>         Arnd
