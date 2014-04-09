Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836AbaDIQVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:21:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27189 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbaDIQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:20:59 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-76-53457368105c
Message-id: <53457366.6000905@samsung.com>
Date: Wed, 09 Apr 2014 18:20:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: linux-next: Tree for Apr 9 (media/i2c/s5c73m3)
References: <20140409172233.093c15de27c3b9f3c7c61bd7@canb.auug.org.au>
 <53456EDE.5000807@infradead.org>
In-reply-to: <53456EDE.5000807@infradead.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xK7oZxa7BBr2XRS1urTvHanF51xw2
	i54NW1ktDi5sY7R4e2c6i8XWvVfZHdg8Gm/cYPPYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDLeHmpjKpjLXnFt+1G2BsY2ti5GTg4JAROJtj1TmSBsMYkL99YDxbk4hASWMkpcnDMB
	yvnEKDFtzjxWkCpeAS2JNZcnMXYxcnCwCKhK7D1uCBJmEzCU6D3axwhiiwpESNxrPAxVLijx
	Y/I9FhBbREBD4veVK6wgM5kFdjJKrHhzlB0kISxgLbFv0V2wBiGBTInz0xeD2ZwCuhIP3z4A
	a2YWUJeYNG8RM4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQgL66w7GpcesDjEKcDAq8fAqWLoEC7EmlhVX5h5ilOBgVhLh5St0DRbiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAuPXAvc5T3qeXvA1bPmfzyf+ZjFN+7Vl05p7T45pvPROTTTtEXEUl
	9VPvrpIPXv71ldKfJ23zzuoHrshsfrwn8v/8Lw5tsrY7np2bFXrjhO6dt0HrjFguS28o3R3y
	5hX3wy+rLf4kOq18Zq5/5BYDm8fK06yHLMyyLIsZKnzPH7m7WGzm5cnHV1UpsRRnJBpqMRcV
	JwIAktC9VEYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/04/14 18:01, Randy Dunlap wrote:
> On 04/09/2014 12:22 AM, Stephen Rothwell wrote:
>> > Hi all,
>> > 
>> > Please do not add material intended for v3.16 to your linux-next included
>> > branches until after v3.15-rc1 is released.
>> > 
>> > This tree still fails (more than usual) the powerpc allyesconfig build.
>> > 
>> > Changes since 20140408:
>> > 
> on i386:
> CONFIG_OF is not enabled.
> 
> drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function 's5c73m3_get_platform_data':
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function 'v4l2_of_get_next_endpoint' [-Werror=implicit-function-declaration]
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]

I have already prepared a patch for this issue:
https://patchwork.linuxtv.org/patch/23465

--
Thanks,
Sylwester
