Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774Ab3IDOgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:36:31 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8556 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab3IDOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:36:29 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-69-5227456a3ad9
From: Tomasz Figa <t.figa@samsung.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: 3.12 merge window exynos cpufreq driver fails to build
Date: Wed, 04 Sep 2013 16:36:25 +0200
Message-id: <7035644.8Kb1gDYsCf@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <CA+5PVA6SQ9JGBD3F=u5ysch-agp91oTK8ZbKsdQkz57yZ8OUHQ@mail.gmail.com>
References: <CA+5PVA6SQ9JGBD3F=u5ysch-agp91oTK8ZbKsdQkz57yZ8OUHQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xa7pZrupBBi3rTC2eNv1gt2ieN5/N
	onfBVTaLTY+vsVpc3jWHzWLG+X1MFv0Le5ksNn71cODwmHKvhc3jzrU9bB6bl9R79G1Zxejx
	aHELo8fnTXIBbFFcNimpOZllqUX6dglcGWeO3WEs2M1Z8XJiN1sD42n2LkZODgkBE4nlU7aw
	QdhiEhfurQeyuTiEBJYySrxatBnK6WKS6DxwhBGkik1ATeJzwyOwDhEBLYmWHTsYQYqYBeYw
	SczbPocJJCEs4CzxdfkhZhCbRUBV4uT5x2ANvAKaEo/P/WMFsfkF1CXebXsKVi8q4CrxaeFG
	sJM4BYIl5n+7CVYvJBAgcWjZClaIXkGJH5PvsYDYzALyEvv2T2WFsLUk1u88zjSBUXAWkrJZ
	SMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkIr7uYFx6zOoQowAHoxIPr4ah
	epAQa2JZcWXuIUYJDmYlEd6pzkAh3pTEyqrUovz4otKc1OJDjEwcnFINjEsa5DnDfz+dsX+X
	D7vfT/6HTwxXdTBG5f3//OGtfekVzsL9iVXR+4KEguZYtjsopUzZmdgjUDK7+94R28MeB3he
	78v8zuzE1d9ZHS79vTvhtPrZWzNim17qMsR9zV98+WjjKYOmb0kzXO1ech2R+Z20O3/VO/tg
	w4SktSd3HtKYWmfqayC+Q4mlOCPRUIu5qDgRAB8hM1NmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Wednesday 04 of September 2013 10:13:16 Josh Boyer wrote:
> Using Linus' tree as of this morning (v3.11-2654-g458c3f6), the
> exynos-cpufreq driver doesn't build because it includes a file that
> doesn't exist.
> 
> + make -s ARCH=arm V=1 -j4 bzImage KALLSYMS_EXTRA_PASS=1
> arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO:
> return_address should use unwind tables" [-Wcpp]
>  #warning "TODO: return_address should use unwind tables"
>   ^
> arch/arm/mm/dma-mapping.c:253:2: warning: #warning ARM Coherent DMA
> allocator does not (yet) support huge TLB [-Wcpp]
>  #warning ARM Coherent DMA allocator does not (yet) support huge TLB
>   ^
> drivers/cpufreq/exynos-cpufreq.c:21:22: fatal error: plat/cpu.h: No
> such file or directory
>  #include <plat/cpu.h>
>                       ^
> compilation terminated.
> make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
> 
> I'm guessing that <plat/cpu.h> file is supposed to come from
> arch/arm/plat-samsung/include/plat/, but I don't see anything that
> specifies a -I there.
> 
> Thoughts?

Could you attach config that could be used to trigger this? Thanks in 
advance.

Best regards,
Tomasz

