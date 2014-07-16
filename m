Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbaGPMyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:54:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9185 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806AbaGPMyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:54:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-3b-53c6760998ff
Message-id: <53C675E4.4020502@samsung.com>
Date: Wed, 16 Jul 2014 14:53:56 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 11/19] ARM: S5PV210: Remove support for board files
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-12-git-send-email-t.figa@samsung.com>
 <1405505072.4408.17.camel@x220>
In-reply-to: <1405505072.4408.17.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xy7qcZceCDebvNrD4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i0a0zzBardv1hdOD2+P1r
	EqPHzll32T02repk89i8pN7jyokmVo++LasYPbZfm8fssXH7EyaPz5vkAjijuGxSUnMyy1KL
	9O0SuDJ6935jKbjPUbFy4XnGBsYG9i5GTg4JAROJA8ffs0LYYhIX7q1nA7GFBJYySnxdVtzF
	yAVkf2aU6N66nAUkwSugJTFh+wEwm0VAVWLShZfMIDabgJrE54ZHYM38QDVrmq4D1XBwiApE
	SDy+IATRKijxY/I9sFYRAWWJ1s332EHmMwv8Y5JoWrYb7AhhAXeJjYdamSAWz2OUWDSzB+xS
	TgEdiRUdu8EWMAuoS0yat4gZwpaX2LzmLfMERsFZSJbMQlI2C0nZAkbmVYyiqaXJBcVJ6blG
	esWJucWleel6yfm5mxgh0fR1B+PSY1aHGAU4GJV4eBlmHw0WYk0sK67MPcQowcGsJMLr4H8s
	WIg3JbGyKrUoP76oNCe1+BAjEwenVAPjis+Bn89WKa98uvHoR4GMvvqvmQqX3+Wkc5RM6yq3
	z50ecoR1y8qvK7mjb06dmbLiePvmuLW+Ils6z58xmvd5SuwlvhY1baG/C2+l35N/qNt66Iae
	9fXUnr97zud+9eU7mP9IbvbzzbOn5x1RSuN1nPMwyOv8+eU2iVZcl3e+ezb7N5/Xo+//NZRY
	ijMSDbWYi4oTAZVp7p+EAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2014 12:04, Paul Bolle wrote:
> On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:

[snip]

>> -
>> -config MACH_AQUILA
>> -	bool "Aquila"
>> -	select CPU_S5PV210
>> -	select S3C_DEV_FB
>> -	select S3C_DEV_HSMMC
>> -	select S3C_DEV_HSMMC1
>> -	select S3C_DEV_HSMMC2
>> -	select S5PV210_SETUP_FB_24BPP
>> -	select S5PV210_SETUP_SDHCI
>> -	select S5PV210_SETUP_USB_PHY
>> -	select S5P_DEV_FIMC0
>> -	select S5P_DEV_FIMC1
>> -	select S5P_DEV_FIMC2
>> -	select S5P_DEV_ONENAND
>> -	help
>> -	  Machine support for the Samsung Aquila target based on S5PC110 SoC
>> -
> 
> This symbol is still referenced in sound/soc/samsung/Kconfig.

More code that I missed.

I believe that both sound card drivers for Goni and Aquilla could be
replaced with simple cards in DT, so I'll send a follow-up patch for this.

Most likely the same is the case for SMDK boards, but they don't seem to
have any active users (see cover letter for more details), which means
that probably they could be simply dropped from
sound/soc/samsung/Kconfig in another follow-up patch.

Best regards,
Tomasz
