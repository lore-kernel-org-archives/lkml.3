Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbaGPM4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:56:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41876 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbaGPM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:56:40 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-48-53c676853f11
Message-id: <53C67660.8050003@samsung.com>
Date: Wed, 16 Jul 2014 14:56:00 +0200
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
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
 <1405504062.4408.11.camel@x220>
In-reply-to: <1405504062.4408.11.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xa7qtZceCDY4vMLX4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i0a0zzBardv1hdOD2+P1r
	EqPHzll32T02repk89i8pN7jyokmVo++LasYPbZfm8fssXH7EyaPz5vkAjijuGxSUnMyy1KL
	9O0SuDJuXeIoOMZScWoVZwPjaeYuRk4OCQETie/rl0PZYhIX7q1nA7GFBJYySnxYEt7FyAVk
	f2aUOPD6EytIgldAS+Lon+1MXYwcHCwCqhKvzzOChNkE1CQ+NzwC6+UHKlnTdJ0FpERUIELi
	8QUhiE5BiR+T77GA2CICyhKtm++xg4xnFvjHJNG0bDfYeGEBV4kt564yQ+ydxyix/81GdpAE
	p4CORNPbx0wgNrOAusSkeYuYIWx5ic1r3jJPYBSchWTJLCRls5CULWBkXsUomlqaXFCclJ5r
	pFecmFtcmpeul5yfu4kREkdfdzAuPWZ1iFGAg1GJh5dh9tFgIdbEsuLK3EOMEhzMSiK8Dv7H
	goV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwGmx59WOP9GsjUXXOvQudMg+84Cp38m3WPSsS32r/
	97JDZuTapmcmDe1/HvQb2X5beWvzDV8FftcXHVYS1UkrHlYkzu618SlzYLmwT1dtc+Y2e60A
	Zv/vf14/LlU/2LUjoS0m/1LE7Wv9V40nt/95O2nflFO3I2Z+OXl71dWZG8q67NsZmBoWKrEU
	ZyQaajEXFScCAKKJNP+BAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2014 11:47, Paul Bolle wrote:
> On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:

[snip]

>>  config SAMSUNG_GPIO_EXTRA
>>  	int "Number of additional GPIO pins"
>>  	default 128 if SAMSUNG_GPIO_EXTRA128
> 
> So a second order effect is that SAMSUNG_GPIO_EXTRA can now be removed.
> Which implies that SAMSUNG_GPIO_EXTRA64 and SAMSUNG_GPIO_EXTRA128 can
> also be removed.
> 
> Should I submit the trivial patch to do that or is a patch already
> queued somewhere?

Please do if you don't mind. That's one more thing I missed.

Best regards,
Tomasz
