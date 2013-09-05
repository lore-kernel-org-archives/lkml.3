Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545Ab3IEJWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:22:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763299Ab3IEJWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:22:37 -0400
X-IronPort-AV: E=Sophos;i="4.90,845,1371052800"; 
   d="scan'208";a="8422151"
Message-ID: <52284D12.6050604@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 17:21:22 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 05/11] memblock: Introduce allocation order to memblock.
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com> <1377596268-31552-6-git-send-email-tangchen@cn.fujitsu.com> <20130905091615.GB15294@hacker.(null)>
In-Reply-To: <20130905091615.GB15294@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 17:20:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 17:20:25,
	Serialize complete at 2013/09/05 17:20:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng,

On 09/05/2013 05:16 PM, Wanpeng Li wrote:
......
>>
>> +/* Allocation order. */
>
> How about replace "Allocation order" by "Allocation sequence".
>
> The "Allocation order" is ambiguity.
>

Yes, order is ambiguity. But as tj suggested, I think maybe "direction"
is better.

Thanks. :)

