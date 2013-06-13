Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3FMSgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:36:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025Ab3FMSgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:36:33 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1371128589-8953-22-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com> <1371128589-8953-22-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Part1 PATCH v5 21/22] x86, mm: Make init_mem_mapping be able to be called several times
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 13 Jun 2013 14:35:28 -0400
To: Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
CC: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Message-ID: <aad34de7-8ff7-442d-ad8a-bed2a6e3edea@email.android.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang Chen <tangchen@cn.fujitsu.com> wrote:

>From: Yinghai Lu <yinghai@kernel.org>
>
>Prepare to put page table on local nodes.
>
>Move calling of init_mem_mapping() to early_initmem_init().
>
>Rework alloc_low_pages to allocate page table in following order:
>	BRK, local node, low range
>
>Still only load_cr3 one time, otherwise we would break xen 64bit again.
>



Sigh..  Can that comment on Xen be removed please.  The issue was fixed last release  and I believe I already asked to remove that comment as it is not true anymore. 
-- 
Sent from my Android phone. Please excuse my brevity.
