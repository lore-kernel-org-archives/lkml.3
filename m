Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230Ab3IDBBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:01:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5987 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934081Ab3IDBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:01:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,1017,1367942400"; 
   d="scan'208";a="8399566"
Message-ID: <52268634.1050008@cn.fujitsu.com>
Date: Wed, 04 Sep 2013 09:00:36 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
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
Subject: Re: [PATCH 06/11] memblock: Improve memblock to support allocation
 from lower address.
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>  <1377596268-31552-7-git-send-email-tangchen@cn.fujitsu.com> <1378254257.10300.921.camel@misato.fc.hp.com>
In-Reply-To: <1378254257.10300.921.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/04 08:59:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/04 08:59:42,
	Serialize complete at 2013/09/04 08:59:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 08:24 AM, Toshi Kani wrote:
......
>> +phys_addr_t __init_memblock
>> +__memblock_find_range(phys_addr_t start, phys_addr_t end,
>> +		      phys_addr_t size, phys_addr_t align, int nid)
>
> This func should be static as it must be an internal func.
>
......
>> +phys_addr_t __init_memblock
>> +__memblock_find_range_rev(phys_addr_t start, phys_addr_t end,
>> +			  phys_addr_t size, phys_addr_t align, int nid)
>
> Ditto.
......
>> +	if (memblock.current_order == MEMBLOCK_ORDER_DEFAULT)
>
> This needs to use MEMBLOCK_ORDER_HIGH_TO_LOW since the code should be
> independent from the value of MEMBLOCK_ORDER_DEFAULT.
>

OK, followed.

Thanks.

