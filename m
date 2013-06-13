Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab3FMWrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:47:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45514 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab3FMWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:47:40 -0400
MIME-Version: 1.0
In-Reply-To: <aad34de7-8ff7-442d-ad8a-bed2a6e3edea@email.android.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
	<1371128589-8953-22-git-send-email-tangchen@cn.fujitsu.com>
	<aad34de7-8ff7-442d-ad8a-bed2a6e3edea@email.android.com>
Date: Thu, 13 Jun 2013 15:47:40 -0700
X-Google-Sender-Auth: ipUpeiAzo00jfG3mUFxDvARWzco
Message-ID: <CAE9FiQXjg1zZB8veUHH2u9T5G1X8VMdMyY528YDhJtsFjKPxPQ@mail.gmail.com>
Subject: Re: [Part1 PATCH v5 21/22] x86, mm: Make init_mem_mapping be able to
 be called several times
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        Rik van Riel <riel@redhat.com>, jweiner@redhat.com,
        Prarit Bhargava <prarit@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:35 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Tang Chen <tangchen@cn.fujitsu.com> wrote:
>
>>From: Yinghai Lu <yinghai@kernel.org>
>>
>>Prepare to put page table on local nodes.
>>
>>Move calling of init_mem_mapping() to early_initmem_init().
>>
>>Rework alloc_low_pages to allocate page table in following order:
>>       BRK, local node, low range
>>
>>Still only load_cr3 one time, otherwise we would break xen 64bit again.
>>
>
>
>
> Sigh..  Can that comment on Xen be removed please.  The issue was fixed last release  and I believe I already asked to remove that comment as it is not true anymore.

Sorry about that again, I thought I removed that already.

Yinghai
