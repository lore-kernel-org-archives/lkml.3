Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBKBCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:02:31 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:51462 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBKBC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:02:27 -0500
MIME-Version: 1.0
In-Reply-To: <1392078024.2507.34.camel@joe-AO722>
References: <1861074.WmPcbRBdNV@daeseok-laptop.cloud.net>
	<1392050018.2507.6.camel@joe-AO722>
	<CAHb8M2DZHv7qsnt8RxAKyycMptyvKbfZcCtwV4juTs4jRp_z-A@mail.gmail.com>
	<1392078024.2507.34.camel@joe-AO722>
Date: Tue, 11 Feb 2014 10:02:26 +0900
Message-ID: <CAHb8M2AJDi1Zx=keMYKA07MzKaU5TNwxK468RPZ3majMfmT2Aw@mail.gmail.com>
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

Oh.. I see.

My tabstop  size is 4 in my editor so I didn't get your comment.
Sorry for that.(I know tabs in kernel are 8 char.)

I will re-send fixing alignment as your comment.

Thanks a lot.
Daeseok Youn

2014-02-11 9:20 GMT+09:00 Joe Perches <joe@perches.com>:
> On Tue, 2014-02-11 at 09:11 +0900, DaeSeok Youn wrote:
>> Hi,
>
> Hello.
>
>> Thanks for review.
>> If I send this patch again, i will use a subject as you comment.
>
> Thanks.
>
>> And alignment issue, my patch line seems to be same with your example.
>
> You took out a space from the line with the function pointer
> but not from the subsequent lines of the arguments.
>
>> >> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
>> > []
>> >> @@ -55,7 +55,7 @@ struct ion_device {
>> >>       struct mutex buffer_lock;
>> >>       struct rw_semaphore lock;
>> >>       struct plist_head heaps;
>> >> -     long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
>> >> +     long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>> >>                             unsigned long arg);
>> >
>> > Please realign the arguments to the open parenthesis like:
>> >
>> >         long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>> >                              unsigned long arg);
>
> Your patch has:
>
>         long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>                               unsigned long arg);
>
> it should be:
>
>         long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
>                              unsigned long arg);
>
> with the "unsigned long arg" aligned immediately after
> the open parenthesis of the function arguments.
>
> (under the "s" of struct, not the first "t" of struct)
>
>
>
