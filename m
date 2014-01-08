Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbaAHQbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:31:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47346 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbaAHQbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:31:24 -0500
Message-ID: <52CD8A9A.3010608@ti.com>
Date: Wed, 8 Jan 2014 19:27:54 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, <santosh.shilimkar@ti.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/mm: memblock: switch to use NUMA_NO_NODE
References: <20140107022559.GE14055@localhost> <1389198198-31027-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1389198198-31027-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/08/2014 06:23 PM, Grygorii Strashko wrote:
> Update X86 code to use NUMA_NO_NODE instead of MAX_NUMNODES while
> calling memblock APIs, because memblock API is changed to use NUMA_NO_NODE and
> will produce warning during boot otherwise.
> 
> See:
>   https://lkml.org/lkml/2013/12/9/898
> 
[...]

or, there are other 3 patches from Sergey Senozhatsky, which actually fix the same warnings:
 https://lkml.org/lkml/2014/1/6/277 - [PATCH -next] x86 memtest: use NUMA_NO_NODE in do_one_pass()
 https://lkml.org/lkml/2014/1/6/280 - [PATCH -next] e820: use NUMA_NO_NODE in memblock_find_dma_reserve()
 http://comments.gmane.org/gmane.linux.kernel/1623429 - [PATCH -next] check: use NUMA_NO_NODE in setup_bios_corruption_check()

Regards,
- grygorii


	



