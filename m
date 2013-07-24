Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3GXKNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:13:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab3GXKNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:13:54 -0400
X-IronPort-AV: E=Sophos;i="4.89,734,1367942400"; 
   d="scan'208";a="8005653"
Message-ID: <51EFA97F.2090701@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 18:16:31 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 13/21] x86, acpi: Try to find SRAT in firmware earlier.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-14-git-send-email-tangchen@cn.fujitsu.com> <51EF1143.1020503@linux.vnet.ibm.com>
In-Reply-To: <51EF1143.1020503@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 18:11:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 18:11:44,
	Serialize complete at 2013/07/24 18:11:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 07:26 AM, Cody P Schafer wrote:
> On 07/19/2013 12:59 AM, Tang Chen wrote:
......
>> +/*
>> + * acpi_get_table_desc - Get the acpi table descriptor of a specific
>> table.
>> + * @signature: The signature of the table to be found.
>> + * @out_desc: The out returned descriptor.
>
> The "@out_desc:" line looks funky. Also, I believe changes to this file
> need to go in via acpica & probably conform to their commenting standards?
>

OK, followed.

......
>
> Perhaps: "Iterate over acpi_gbl_root_table_list to find SRAT then return
> its phys addr"
>
> Though I wonder if this comment is even needed, as the iteration is done
> in acpi_get_table_desc() (added above).
>

OK, will remove the comment.

Thanks.

