Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbaEPJ2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:28:47 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:65241 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbaEPJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140516090332.GB16255@mwanda>
References: <20140516080810.GA16229@devel.8.8.4.4>
	<20140516090332.GB16255@mwanda>
Date: Fri, 16 May 2014 18:28:45 +0900
Message-ID: <CAHb8M2CW8QKy7rX22qk-ef5Db4NX_SG7jSd+0T_0WCX2gb9thA@mail.gmail.com>
Subject: Re: [PATCH] staging: ozwpan: remove redundant NULL check for devs
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: rupesh.gujare@atmel.com, devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan

2014-05-16 18:03 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, May 16, 2014 at 05:08:10PM +0900, Daeseok Youn wrote:
>> >From 1cebea7a40490d0d0b122eb444a105d424af42e6 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Fri, 16 May 2014 17:02:04 +0900
>> Subject: [PATCH] staging: ozwpan: remove redundant NULL check for devs
>>
>
> Your patches before were fine.  Why do you have these lines in them now?
> Please resend.
Oh.. I actually made a script for mutt and I didn't notice it.
I will remove these lines and resend it.

Thanks.
Regards,
Daeseok Youn.
>
> Otherwise this looks fine.
>
> regards,
> dan carpenter
>
>
