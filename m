Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3ILKER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:04:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab3ILKEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:04:14 -0400
X-IronPort-AV: E=Sophos;i="4.90,890,1371052800"; 
   d="scan'208";a="8503635"
Message-ID: <52319218.3080609@cn.fujitsu.com>
Date: Thu, 12 Sep 2013 18:06:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, toshi.kani@hp.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/9] x86, memblock: Allocate memory near kernel image
 before SRAT parsed.
References: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com> <20130911125101.GA20997@htj.dyndns.org>
In-Reply-To: <20130911125101.GA20997@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/12 18:01:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/12 18:01:49,
	Serialize complete at 2013/09/12 18:01:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 08:51 PM, Tejun Heo wrote:
> On Wed, Sep 11, 2013 at 06:07:28PM +0800, Tang Chen wrote:
>> This patch-set is based on tj's suggestion, and not fully tested.
>> Just for review and discussion. And according to tj's suggestion,
>> implemented a new function memblock_alloc_bottom_up() to allocate
>> memory from bottom upwards, whihc can simplify the code.
>
> For $DEITY's sake, can you please specify against which tree the
> patches are?  :(
>

Hi tj,

So sorry for the trouble. I have rebased the patches to the latest
kernel and resent it. I cannot access to my github now, so sorry for
that I cannot give you a tree with these patches.

Thanks. :)
