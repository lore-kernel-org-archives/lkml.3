Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaI3S7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:59:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbaI3S72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:59:28 -0400
Message-ID: <542AFD8A.8060806@nod.at>
Date: Tue, 30 Sep 2014 20:59:22 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Daniel Walter <dwalter@google.com>
Subject: Re: linux-next: Tree for Sep 30 (uml)
References: <20140930201244.0a4596ec@canb.auug.org.au> <542AFB5E.7040308@infradead.org>
In-Reply-To: <542AFB5E.7040308@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.09.2014 20:50, schrieb Randy Dunlap:
> On 09/30/14 03:12, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20140926:
>>
> 
> uml defconfig on i386 and x86_64:
> 
> In file included from ../arch/x86/um/asm/processor.h:31:0,
>                  from ../arch/um/include/asm/uaccess.h:16,
>                  from ../arch/um/include/asm/thread_info.h:13,
>                  from ../include/linux/thread_info.h:54,
>                  from ../include/asm-generic/current.h:4,
>                  from arch/um/include/generated/asm/current.h:1,
>                  from ../include/linux/mutex.h:13,
>                  from ../include/linux/kernfs.h:13,
>                  from ../include/linux/sysfs.h:15,
>                  from ../include/linux/kobject.h:21,
>                  from ../include/linux/device.h:17,
>                  from ../include/linux/platform_device.h:14,
>                  from ../drivers/base/platform.c:14:
> ../arch/um/include/asm/processor-generic.h:107:19: error: expected identifier or '(' before '&' token
>  #define cpu_data (&boot_cpu_data)
>                    ^
> ../include/linux/pm_domain.h:74:23: note: in expansion of macro 'cpu_data'
>   struct gpd_cpu_data *cpu_data;

Thank you Randy, will look into this tomorrow.

Thanks,
//richard
