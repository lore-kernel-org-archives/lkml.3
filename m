Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaBKALy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:11:54 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46955 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaBKALu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:11:50 -0500
MIME-Version: 1.0
In-Reply-To: <1392050018.2507.6.camel@joe-AO722>
References: <1861074.WmPcbRBdNV@daeseok-laptop.cloud.net>
	<1392050018.2507.6.camel@joe-AO722>
Date: Tue, 11 Feb 2014 09:11:49 +0900
Message-ID: <CAHb8M2DZHv7qsnt8RxAKyycMptyvKbfZcCtwV4juTs4jRp_z-A@mail.gmail.com>
Subject: Re: [Resend PATCH] staging : ion : Fix some checkpatch warnings and
 an error
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Zavin <rebecca@android.com>, ccross@android.com,
        ohaugan@codeaurora.org, Rom Lemarchand <romlem@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for review.
If I send this patch again, i will use a subject as you comment.

And alignment issue, my patch line seems to be same with your example.

Daeseok Youn

2014-02-11 1:33 GMT+09:00 Joe Perches <joe@perches.com>:
> On Mon, 2014-02-10 at 20:25 +0900, Daeseok Youn wrote:
>
>> Warning:
>>  - Unnecessary space after function pointer name
>>  - quoted string split across lines
>>
>> Error:
>>  - return is not a function, parentheses are not required
>
> Hi.
>
> checkpatch issuing either an ERROR or WARNING isn't
> really relevant to the subject.
>
> This isn't really a resend.  It's a different version
> and so the subject should not say "Resend".  Ideally,
> you send this with a subject like:
>
> [PATCH V2] staging: ion: Whitespace neatening
>
> and if needed again:
>
> [PATCH V3] staging: ion: Whitespace neatening
>
> etc...
>
> and below:
>
>> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> []
>> @@ -55,7 +55,7 @@ struct ion_device {
>>       struct mutex buffer_lock;
>>       struct rw_semaphore lock;
>>       struct plist_head heaps;
>> -     long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
>> +     long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>>                             unsigned long arg);
>
> Please realign the arguments to the open parenthesis like:
>
>         long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>                              unsigned long arg);
>
>> diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
> []
>> @@ -100,18 +100,18 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
>>   * map_dma and map_kernel return pointer on success, ERR_PTR on error.
>>   */
>>  struct ion_heap_ops {
>> -     int (*allocate) (struct ion_heap *heap,
>> +     int (*allocate)(struct ion_heap *heap,
>>                        struct ion_buffer *buffer, unsigned long len,
>>                        unsigned long align, unsigned long flags);
>
> realignment here too
>
> etc.
>
