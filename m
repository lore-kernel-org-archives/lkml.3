Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536Ab3IEB6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 21:58:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14658 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763059Ab3IEB6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 21:58:21 -0400
X-IronPort-AV: E=Sophos;i="4.90,843,1371052800"; 
   d="scan'208";a="8416596"
Message-ID: <5227E4E4.9050705@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 09:56:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, lenb@kernel.org,
        liwanp@linux.vnet.ibm.com, tj@kernel.org, akpm@linux-foundation.org,
        joe@perches.com, toshi.kani@hp.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/4] acpi: Fix and cleanup in acpi.
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com> <17694789.JU3fWJ8s3q@vostro.rjw.lan>
In-Reply-To: <17694789.JU3fWJ8s3q@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 09:55:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 09:56:10,
	Serialize complete at 2013/09/05 09:56:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 07:50 AM, Rafael J. Wysocki wrote:
> On Tuesday, September 03, 2013 04:45:37 PM Tang Chen wrote:
>> This patch-set fix the following problems:
>>
>> 1. Kill useless function save_add_info() which will block us from using
>>     numa when MEMORY_HOTPLUG is not configured.
>> 2. acpi_table_parse() didn't check if @id is NULL.
>> 3. Fix incorrect comment in acpi_table_parse(), and return -ENOENT if a
>>     table is not found.
>>
>> And also did some cleanup.
>>
>> change log v1 ->  v2:
>> 1. Use pr_fmt() to simply the SRAT message.
>>     Suggested by Joe Perches<joe@perches.com>
>> 2. Improve the log in patch 4, and change the return value of the stub of
>>     acpi_table_parse() in linux/acpi.h
>>     Suggested by Toshi Kani<toshi.kani@hp.com>
>> 3. Merge the two pr_{info|err} patches into one.
>> 4. Remove on of the patch that has been merged by Rafael.
>>
>> Tang Chen (4):
>>    acpi, numa, mem_hotplug: Kill save_add_info().
>>    acpi cleanup: Use pr_{info|err}() instead of printk() in
>>      arch/x86/mm/srat.c
>>    acpi: Check if @id is NULL in acpi_table_parse()
>>    acpi: Return -ENOENT in acpi_table_parse() and fix wrong comment.
>
> Thanks for the patches!
>
> Peter, any objections against [1-2/4]?  If not, I'll queue them up for 3.13.

Hi Rafael,

Thanks for the checking. As Ishimatu has sent some comments for patch 2, 
I'd like
to send a v3 patch-set soon. Please queue the coming v3 patches.

Thanks.

