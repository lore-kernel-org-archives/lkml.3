Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaGMTsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:48:42 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:61378 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaGMTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140713190719.GA31809@kroah.com>
References: <20140713144929.GA6656@archDesk> <20140713190719.GA31809@kroah.com>
From: Lucas Tanure <tanure@linux.com>
Date: Sun, 13 Jul 2014 16:48:22 -0300
X-Google-Sender-Auth: vj0SXwhbUFvXh0J7xK6U4egSRQk
Message-ID: <CAJyon0tz5T9zxHyn3HKP7+O1=ro5tJLiaznRv5eypv91UPB87Q@mail.gmail.com>
Subject: Re: [RESEND PATCH] staging: android: Clean up binder_send_failed_reply
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry,
I didn't know. I will fix.

Thanks
--
Lucas Tanure
+55 (19) 988176559


On Sun, Jul 13, 2014 at 4:07 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Jul 13, 2014 at 11:49:29AM -0300, Lucas Tanure wrote:
>> Kernel coding style. Remove useless else statement after return.
>>
>> Signed-off-by: Lucas Tanure <tanure@linux.com>
>> ---
>>  drivers/staging/android/binder.c | 27 +++++++++++++--------------
>>  1 file changed, 13 insertions(+), 14 deletions(-)
>
> You didn't compile this patch :(
>
> Or if you did, you ignored the fact that it now adds a warning to the
> kernel build process, which is not allowed.  Please fix this up and
> resend.
>
> thanks,
>
> greg k-h
