Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaKQEmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 23:42:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaKQEmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 23:42:23 -0500
Message-ID: <54697CAA.5040601@suse.com>
Date: Mon, 17 Nov 2014 05:42:18 +0100
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH V6 00/18] x86: Full support of PAT
References: <1415019724-4317-1-git-send-email-jgross@suse.com> <20141116130847.GA4736@gmail.com>
In-Reply-To: <20141116130847.GA4736@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2014 02:08 PM, Ingo Molnar wrote:
>
> * Juergen Gross <jgross@suse.com> wrote:
>
>>   arch/x86/include/asm/cacheflush.h         |  38 ++++---
>
> FYI, this series breaks the UML build:
>
> In file included from /home/mingo/tip/include/linux/highmem.h:11:0,
>                   from /home/mingo/tip/include/linux/pagemap.h:10,
>                   from /home/mingo/tip/include/linux/mempolicy.h:14,
>                   from /home/mingo/tip/include/linux/shmem_fs.h:6,
>                   from /home/mingo/tip/init/do_mounts.c:30:
> /home/mingo/tip/arch/x86/include/asm/cacheflush.h:67:36: error: return type is an incomplete type
>   static inline enum page_cache_mode get_page_memtype(struct page *pg)
>                                      ^
> /home/mingo/tip/arch/x86/include/asm/cacheflush.h: In function ‘get_page_memtype’:
> /home/mingo/tip/arch/x86/include/asm/cacheflush.h:69:2: warning: ‘return’ with a value, in function returning void [enabled by default]
>    return -1;
>    ^
> /home/mingo/tip/arch/x86/include/asm/cacheflush.h: At top level:
> /home/mingo/tip/arch/x86/include/asm/cacheflush.h:72:30: error: parameter 2 (‘memtype’) has incomplete type
>           enum page_cache_mode memtype)
>                                ^
> /home/mingo/tip/arch/x86/include/asm/cacheflush.h:71:20: error: function declaration isn’t a prototype [-Werror=strict-prototypes]

Thomas already committed a fixup. Thank you, Thomas.


Juergen

