Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaAGGcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:32:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaAGGcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:32:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,617,1384272000"; 
   d="scan'208";a="9383387"
Message-ID: <52CB9FF8.6020809@cn.fujitsu.com>
Date: Tue, 07 Jan 2014 14:34:32 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lans Zhang <jia.zhang@windriver.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
References: <20140107170041.3a0b3ada016d250b1f9f0572@canb.auug.org.au>
In-Reply-To: <20140107170041.3a0b3ada016d250b1f9f0572@canb.auug.org.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/07 14:31:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/07 14:31:03,
	Serialize complete at 2014/01/07 14:31:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 02:00 PM, Stephen Rothwell wrote:
> Hi Andrew,
>
> Today's linux-next merge of the akpm-current tree got a conflict in
> arch/x86/mm/numa.c between commit f3d815cb854b ("x86/mm/numa: Fix 32-bit
> kernel NUMA boot") from the tip tree and commit 1459be89954e ("x86: get
> pg_data_t's memory from other node") from the akpm-current tree.
>
> These appear to be two very similar solutions, I fixed it up (see below -
> I (arbitrarily) chose to keep the actual allocation from the tip tree, but
> the messages from the akpm-current tree) and can carry the fix as
> necessary (no action is required).
>

memblock_alloc_nid() and __memblock_alloc_base() will call
memblock_alloc_base_nid() in the end. So I think it is OK to me.

I will do some tests when they are merged.

Thanks.
