Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaBXJox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:44:53 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37765 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXJow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140224080656.GC26722@mwanda>
References: <3750536.lQYs9UcrV9@daeseok-laptop.cloud.net>
	<20140224080656.GC26722@mwanda>
Date: Mon, 24 Feb 2014 18:44:51 +0900
Message-ID: <CAHb8M2Do6UvxcvPt2_q1Nz94-JKgvo_BERhPvBMKKp_jyvy3-w@mail.gmail.com>
Subject: Re: [PATCH] staging: ced401: remove redundant spin_unlock
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        paul.gortmaker@windriver.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Elena Ufimtseva <ufimtseva@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-24 17:06 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Mon, Feb 24, 2014 at 09:51:35AM +0900, Daeseok Youn wrote:
>> >From 5e737e8211cd1f83488e484c088befc5feb755a9 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Mon, 24 Feb 2014 09:17:41 +0900
>> Subject: [PATCH] staging: ced401: remove redundant spin_unlock
>
> Don't send this header.  We get everything from the email header.
Actually, I did attach a file which is output of "git format-patch"
with text mode. So this header was included in my e-mail.
I will remove this header and send patch again. And I don't send this
header again.

>
>>
>> sparse says:
>> drivers/staging/ced1401/usb1401.c:1080:28: warning:
>>  context imbalance in 'Handle1401Esc' - unexpected unlock
>>
>
> Your fix is correct, but the changelog is not good.  These messages in
> Sparse are wrong over 80% of the time.  So when I see one in a commit
> message I assume it is wrong.  Add some more explanation to say why you
> removed the spin_unlock.
You're right. I will add more explanation about this patch.

>
> Also "redundant" means "unnecessary" but sort of implies that it is
> harmless.  Say something like: "staging: ced401: fix double unlock bug".
Ok. fix my subject as your comment.

>
> regards,
> dan carpenter
>
Thanks for your comment.
