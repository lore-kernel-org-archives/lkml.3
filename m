Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3EIIwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:52:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38344 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3EIIwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,640,1363104000"; 
   d="scan'208";a="7224682"
Message-ID: <518B645C.10408@cn.fujitsu.com>
Date: Thu, 09 May 2013 16:54:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org> <517F7110.6000705@cn.fujitsu.com>
In-Reply-To: <517F7110.6000705@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/09 16:51:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/09 16:51:01,
	Serialize complete at 2013/05/09 16:51:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On 04/30/2013 03:21 PM, Tang Chen wrote:
> So I suggest to separate the job into 2 parts:
> 1. Push Yinghai's patch1 ~ patch20, without putting pagetable in local node.
> And push my work to use SRAT to arrange ZONE_MOVABLE.
> In this case, we can enable memory hotplug in the kernel first.
> 2. Merge patch21 and patch22 into the fixing work I am doing now, and push them
> together when finished.
>

It has been a long time since this mail and there was no response. I do 
think I
should move on to push this patch-set. So if you don't mind, I'll rebase 
and
push "parse SRAT earlier" part of this patch-set first.

Since putting pagetable in local node will destroy memory hot-remove 
logic for now,
I will drop "put pagetable in local node" parts now, and merge this part 
into
the hot-add and hot-remove fix work.

If you have any thinking of this patch-set, please let me know.

Thanks. :)
