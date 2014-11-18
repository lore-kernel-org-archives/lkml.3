Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaKRHqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:46:24 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19213 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaKRHqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:46:22 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d0-546af94b018f
Message-id: <546AF94A.8040502@samsung.com>
Date: Tue, 18 Nov 2014 08:46:18 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v8 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
 <54660DAE.9090601@samsung.com> <2593372.vOeyyAKq5M@wuerfel>
In-reply-to: <2593372.vOeyyAKq5M@wuerfel>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4NV3vn1khBr8XSFj8nXSM3eLR/MfM
	Fr0LrrJZnG16w26xvXMGu8WUP8uZLDY9vsZqcXnXHDaL2Uv6WSxmnN/HZHH7Mq/Fue1bWCyW
	Xr/IZHHq+mc2i1W7/jBa7L/i5SDgsWbeGkaPluYeNo/fvyYxenz7OonF43JfL5PHou9ZHjtn
	3WX3uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAE8Ul01Kak5mWWqRvl0CV8ai7Y1MBefZKiZ1
	vWVvYFzC2sXIySEhYCIx7ew9RghbTOLCvfVsXYxcHEICSxklJvZ/YoRwPjFKTO8+ygJSxSug
	JbGs9zE7iM0ioCrx9OIbsElsAoYSXW+72EBsUYEYifs7V7NB1AtK/Jh8D6xXREBRYuqLZ8wg
	Q5kFXjJLnLm/F2yQsIC3xPWne5ghtrUySuw5vw5oKgcHp4CmRNPhNJAaZgEziS8vD7NC2PIS
	m9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkAr/sYFx8
	zOoQowAHoxIPb8PGrBAh1sSy4srcQ4wSHMxKIrznuoFCvCmJlVWpRfnxRaU5qcWHGJk4OKUa
	GE3mnd65/8QUK6flLednr0y6K/g53tAnmsvlwcEQq6KiqW8izde93yo/PW9f9Z/VL2vvP3fM
	/303bXvhzdBvfCZPSn58Y31yd9eOWVP/fKjd5HnEMchv1YvZpyr25QY+urV3Qnmu4jKD/QIi
	VnPeryo518oqvO6ooKBh9za/c4/vz43f8sPyZnKPEktxRqKhFnNRcSIAxYFn2Z4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-11-14 15:51, Arnd Bergmann wrote:
> On Friday 14 November 2014 15:11:58 Marek Szyprowski wrote:
>> I assume that after all comments from previous versions, no more changes
>> are needed
>> to this patchset and I would really like to have it queued to v3.19.
>>
>> Arnd, Olof: could you take this patchset thought arm-soc tree? It already
>> contains all dependencies.
>>
>> Kukjin: could you ack this patchset?
> I'd rather see this merged through Russell's tree, as most of the patches
> are for core code, and only three are for the platform.

Ok, I will upload v9 posted yesterday to Russell's patch system when
http://www.arm.linux.org.uk/ gets back to life.

> For the exynos patches:
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

