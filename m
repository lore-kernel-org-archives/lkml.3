Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161836AbaDPP1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:27:45 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60556 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161602AbaDPP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:27:44 -0400
Message-ID: <534EA16C.6000405@gmail.com>
Date: Thu, 17 Apr 2014 00:27:40 +0900
From: earl <waydi1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: greg@kroah.com, devel@driverdev.osuosl.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging : android : uapi : fix coding style
References: <1397658459-4357-1-git-send-email-waydi1@gmail.com> <20140416144404.GR26890@mwanda>
In-Reply-To: <20140416144404.GR26890@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/16/2014 11:44 PM, Dan Carpenter wrote:
> Subject is not correct format.  Should be:
>
> [PATCH] staging: android: uapi: fix coding style
>
> On Wed, Apr 16, 2014 at 11:27:39PM +0900, Seunghun Lee wrote:
>> This patch fix checkpatch.pl warnings and errors.
>>
> Patch does too many things at once.  Split it up.
>
>> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
>> ---
>>   drivers/staging/android/uapi/binder.h |    2 +-
>>   drivers/staging/android/uapi/ion.h    |   20 +++++++++-----------
>>   2 files changed, 10 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
>> index 904adb7..dba4cef 100644
>> --- a/drivers/staging/android/uapi/binder.h
>> +++ b/drivers/staging/android/uapi/binder.h
>> @@ -169,7 +169,7 @@ struct binder_ptr_cookie {
>>   struct binder_handle_cookie {
>>   	__u32 handle;
>>   	binder_uintptr_t cookie;
>> -} __attribute__((packed));
>> +} __packed;
>>   
>>   struct binder_pri_desc {
>>   	__s32 priority;
>> diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
>> index f09e7c1..36332dc 100644
>> --- a/drivers/staging/android/uapi/ion.h
>> +++ b/drivers/staging/android/uapi/ion.h
>> @@ -20,19 +20,17 @@
>>   #include <linux/ioctl.h>
>>   #include <linux/types.h>
>>   
>> -typedef int ion_user_handle_t;
> This typedef is probably a valid use.  Plus it looks to be part of the
> user space API.  Just leave it alone.
>
> regards,
> dan carpenter
>
Thanks for review.
You're right, I sent the wrong patch.
I'll resend it.
Thanks.
