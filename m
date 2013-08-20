Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3HTBJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:09:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3HTBJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:09:20 -0400
X-IronPort-AV: E=Sophos;i="4.89,915,1367942400"; 
   d="scan'208";a="8245585"
Message-ID: <5212C16E.2040105@cn.fujitsu.com>
Date: Tue, 20 Aug 2013 09:07:58 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        zhangyanfei@cn.fujitsu.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Preparation for arranging hotplug memory in ZONE_MOVABLE.
References: <1376473028-29380-1-git-send-email-tangchen@cn.fujitsu.com> <15319045.yHqauUVrf3@vostro.rjw.lan>
In-Reply-To: <15319045.yHqauUVrf3@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 09:07:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 09:07:35,
	Serialize complete at 2013/08/20 09:07:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 07:40 AM, Rafael J. Wysocki wrote:
> On Wednesday, August 14, 2013 05:37:05 PM Tang Chen wrote:
>> These three trivial patches are from patch-set "Arrange hotpluggable memory as ZONE_MOVABLE."
>> And they have been acked and reviewed by many people.
>>
>> Hope they can be merged first. And the rest patches are coming soon.
>>
>>
>> Tang Chen (3):
>>    acpi: Print Hot-Pluggable Field in SRAT.
>>    earlycpio.c: Fix the confusing comment of find_cpio_data().
>>    acpi: Kill macro INVALID_TABLE().
>>
>>   arch/x86/mm/srat.c |   11 +++++++----
>>   drivers/acpi/osl.c |   36 ++++++++++++++++++++----------------
>>   lib/earlycpio.c    |   27 ++++++++++++++-------------
>>   3 files changed, 41 insertions(+), 33 deletions(-)
>
> I've queued up this series for 3.12.

Hi Rafael,

Thanks a lot. :)

