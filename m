Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3A1TQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:16:38 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34209 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab3A1TQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:16:35 -0500
Message-ID: <5106CE88.2030005@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 11:16:24 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, numa: Use __pa_nodebug instead
References: <1359245901-8512-1-git-send-email-bp@alien8.de>
In-Reply-To: <1359245901-8512-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012819-7182-0000-0000-000004C1FB61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2013 04:18 PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... and fix the following warning:
> 
> arch/x86/mm/numa.c: In function ‘setup_node_data’:
> arch/x86/mm/numa.c:222:3: warning: passing argument 1 of ‘__phys_addr_nodebug’ makes integer from pointer without a cast [enabled by default]
> In file included from /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/page.h:11:0,
>                  from /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h:11,
>                  from include/linux/thread_info.h:54,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/mm.h:8,
>                  from arch/x86/mm/numa.c:3:
> /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/page_64.h:12:29: note: expected ‘long unsigned int’ but argument is of type ‘void *’
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>

I was just about to send out a patch for it and came up with the same fix.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>


