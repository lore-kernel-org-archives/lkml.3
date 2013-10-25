Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3JYFCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:02:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53886 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3JYFCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:02:30 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5269FB5E.6010901@roeck-us.net>
Date: Thu, 24 Oct 2013 22:02:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 24
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1382632289-18523-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 09:31 AM, Thierry Reding wrote:
> Hi all,
>
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
>
>          git://gitorious.org/thierryreding/linux-next.git
>
> A next-20131024 tag is also provided for convenience.
>
> Quite a few new conflicts. Some of them non-trivial. I've fixed another
> set of build failures, so 32-bit and 64-bit allmodconfigs build fine on
> x86. ARM and x86 default configurations also build fine. PowerPC is in
> pretty bad shape, mostly due to some OF header rework going on.
>

Hmm ... I see

Building arm:defconfig ... failed
--------------
Error log:
drivers/built-in.o: In function `mmc_gpio_request_cd':
clkdev.c:(.text+0x74cf8): undefined reference to `devm_gpio_request_one'
make: *** [vmlinux] Error 1

Otherwise pretty much the same as yesterday, with a build log of
	total: 110 pass: 88 skipped: 4 fail: 18

This is with "v3.12-rc5-7941-g765f88c".

Guenter

