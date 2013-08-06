Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3HFCau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 22:30:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3HFCas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 22:30:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,823,1367942400"; 
   d="scan'208";a="8127965"
Message-ID: <52005F7C.6080004@cn.fujitsu.com>
Date: Tue, 06 Aug 2013 10:29:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 13/18] x86, numa, mem_hotplug: Skip all the
 regions the kernel resides in.
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com> <1375434877-20704-14-git-send-email-tangchen@cn.fujitsu.com> <51FF44B7.8050704@cn.fujitsu.com> <20130805145212.GA19631@mtj.dyndns.org>
In-Reply-To: <20130805145212.GA19631@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/06 10:29:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/06 10:29:24,
	Serialize complete at 2013/08/06 10:29:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 10:52 PM, Tejun Heo wrote:
> On Mon, Aug 05, 2013 at 02:22:47PM +0800, Tang Chen wrote:
>> I have resent the v2 patch-set. Would you please give some more
>> comments about the memblock and x86 booting code modification ?
>
> Patch 13 still seems corrupt.  Is it a problem on my side maybe?
> Nope, gmane raw message is corrupt too.
>
>   http://article.gmane.org/gmane.linux.kernel.mm/104549/raw
>
> Can you please verify your mail setup?  It's not very nice to repeat
> the same problem.

Hi tj,

I'm sorry but seeing from lkml, it is OK. And the patch was formatted
by git and sent by git send-email.

   https://lkml.org/lkml/2013/8/2/135

I'll redo and resend this patch again.

Thanks.
