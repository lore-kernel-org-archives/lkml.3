Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbaEQPWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:22:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:56288 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbaEQPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140516230928.GA31392@kroah.com>
References: <20140425070459.GA9155@devel>
	<20140516230928.GA31392@kroah.com>
Date: Sun, 18 May 2014 00:22:09 +0900
Message-ID: <CAHb8M2BPEwJ-=WhdR2WpNOrVMKtyd5Zr9YDoP_kaD6XcCbAJsQ@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: implement error handling in dgap_tty_register()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-17 8:09 GMT+09:00, Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Apr 25, 2014 at 04:04:59PM +0900, Daeseok Youn wrote:
>> - alloc_tty_driver() is deprecated so it is changed to
>> tty_alloc_driver()
>> - Pointers which are allocated by alloc_tty_driver() and kzalloc()
>> can be NULL so it need to check NULL for them.
>> - If one of those is failed, it need to add proper handler for
>> avoiding memory leak.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/dgap/dgap.c |   49
>> +++++++++++++++++++++++++++++++++++--------
>>  1 files changed, 40 insertions(+), 9 deletions(-)
>
> This doesn't apply at all to my tree anymore, please refresh it and
> resend.
>
Yes. It need to rebase on staging-next branch. I will rebase and resend this.
Thanks
Daeseok Youn.

> thanks,
>
> greg k-h
>
