Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab3CZNYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:24:12 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49166 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab3CZNYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <1843378.VZBEQ0WNNo@vostro.rjw.lan>
References: <1362558611-32255-1-git-send-email-tangchen@cn.fujitsu.com>
 <1362558611-32255-2-git-send-email-tangchen@cn.fujitsu.com> <1843378.VZBEQ0WNNo@vostro.rjw.lan>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 26 Mar 2013 14:23:49 +0100
Message-ID: <CACQ1gAia2YsbzV+zT8gTiYvB7JVft3aL1iwC0DBuyCoZ+8wAuQ@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/6] acpi: Remove the leading space of "unlock"
 label in acpi_memory_device_notify().
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, lenb@kernel.org,
        robert.moore@intel.com, lv.zheng@intel.com, ming.m.lin@intel.com,
        mpm@selenic.com, herbert@gondor.hengli.com.au, rob@landley.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/26 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, March 06, 2013 04:30:06 PM Tang Chen wrote:
>> There is a leading space in front of "unlock" label in acpi_memory_device_notify(). Remove it.
>>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> ---
>>  drivers/acpi/acpi_memhotplug.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>> index da1f82b..8a10c23 100644
>> --- a/drivers/acpi/acpi_memhotplug.c
>> +++ b/drivers/acpi/acpi_memhotplug.c
>> @@ -369,7 +369,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
>>                       kfree(ej_event);
>>               }
>>
>> - unlock:
>> +unlock:
>>               acpi_scan_lock_release();
>>               if (ACPI_SUCCESS(status))
>>                       return;
>
> The leading space is actually in agreement with the kernel coding style
> (and there's a reason why it's there).

Well, I'm curious. What's the reason ?
I didn't see anything in Documentation/CodingStyle about that.

Regards,
Richard.
