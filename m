Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3JKQE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:04:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54542 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab3JKQE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:04:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52582181.50901@roeck-us.net>
Date: Fri, 11 Oct 2013 09:04:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Thierry Reding <thierry.reding@gmail.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 10
References: <20131010225507.GY21581@sirena.org.uk>
In-Reply-To: <20131010225507.GY21581@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 03:55 PM, Mark Brown wrote:
> Hi all,
>
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
>
>          git://gitorious.org/thierryreding/linux-next.git
>
> A next-20131010 tag is also provided for convenience.
>
> There were a few new conflicts which have been reported, each merge
> builds fine with x86 allmodconfig.  A few cross tree integration fixes
> are still being carried but nothing new.
>

Build test results:
	total: 110 pass: 97 skipped: 4 fail: 9

Failed builds:
	arm:allmodconfig
	arm:kirkwood_defconfig
	blackfin:defconfig
	mips:nlm_xlp_defconfig
	mips:cavium_octeon_defconfig
	powerpc:ppc64e_defconfig
	powerpc:chroma_defconfig
	powerpc:mpc85xx_smp_defconfig
	sparc64:allmodconfig

mips qemu runs also still fail (and have for a while). mips32 hangs during boot, mips64 fails to build.

Details are at http://server.roeck-us.net:8010/builders.

For some reason buildbot fails to poll the repository status from gitorious. ZZManual update works, though.
I tried both git: and https: URLs. If anyone has an idea how to solve this problem, please let me know.

Thanks,
Guenter

