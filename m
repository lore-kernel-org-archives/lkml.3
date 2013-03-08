Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab3CHHFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:05:14 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:33397 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3CHHFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:05:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130308062602.GI14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-9-git-send-email-yinghai@kernel.org>
	<20130308062602.GI14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 23:05:12 -0800
X-Google-Sender-Auth: SYIdqqBTb_uzZeO_zfX5ySM76JA
Message-ID: <CAE9FiQXGH69V2sy_KXsBFHWK4gBo213iaBtOExWvPmmYVVs_3g@mail.gmail.com>
Subject: Re: [PATCH 08/14] x86, mm, numa: use numa_meminfo to check
 node_map_pfn alignment
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 10:26 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 07, 2013 at 08:58:34PM -0800, Yinghai Lu wrote:
>> We could use numa_meminfo directly instead of memblock nid.
>>
>> So we could move down set memblock nid down and only do it one time
>> for successful path
>>
>> Move node_map_pfn_alignment() to arch/x86/mm as no other user for it.
>
> Please don't move and update in the same patch.  It makes it difficult
> to review what's really changing.

ok, will make it two patches, one for moving and one for changing to
numa_meminfo.

Thanks

Yinghai
