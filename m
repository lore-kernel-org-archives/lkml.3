Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaBJEpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:45:50 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:42048 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBJEpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:45:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140210042646.GA10320@kroah.com>
References: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
	<20140210042646.GA10320@kroah.com>
Date: Mon, 10 Feb 2014 13:45:48 +0900
Message-ID: <CAHb8M2B=SrQKQGbZxP_-ks-uVYdSeyTjBLWZ6sXCm812eJ41Vw@mail.gmail.com>
Subject: Re: [PATCH] staging : android : fix checkpatch issues
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>, ohaugan@codeaurora.org,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        konkers@android.com, linux-kernel <linux-kernel@vger.kernel.org>,
        ccross@android.com, Rebecca Zavin <rebecca@android.com>,
        prtvar.b@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-10 13:26 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Feb 10, 2014 at 10:59:14AM +0900, Daeseok Youn wrote:
>> >From 1348300b03697d0499eddba6035a851d1278abd1 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Mon, 10 Feb 2014 10:45:30 +0900
>> Subject: [PATCH] staging : android : fix checkpatch issues
>>
>> drivers/staging/android/
>> ion/ion.c :
>>  - WARNNING: Unnecessary space after function pointer name
>>  - ERROR: return is not a function, parentheses are not required
>>  - WARNNING: Prefer seq_puts to seq_printf
>>  - WARNING: quoted string split across lines
>>
>> ion/ion_priv.h :
>>  - WARNING: Unnecessary space after function pointer name
>>
>> sync.h :
>>  - WARNING: missing space after return type
>>
>> timed_output.h :
>>  - WARNING: Multiple spaces after return type
>
> You are doing multiple things in different files, please break this up
> into smaller patches...
>
> thanks,
>
> greg k-h

Yes, I will break this into smaller patches and re-send.
Thanks.

Daeseok Youn
