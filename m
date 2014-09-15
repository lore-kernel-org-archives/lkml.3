Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaIOCVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:21:25 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:52049 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIOCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:21:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140914171957.GA2157@fool>
References: <1410699283.5595.1.camel@centos.angelo.com>
	<20140914171957.GA2157@fool>
Date: Mon, 15 Sep 2014 10:21:22 +0800
Message-ID: <CAOeQWiRqPv-6cBuMAh-6PgccThnjEB-zJXcjCkL5qXp97p3pBQ@mail.gmail.com>
Subject: Re: [PATCH] Set EXTRAVERSION to -eudyptula of Makefile
From: Angelo Yin <angelo.yin@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sudip,

I may misunderstand the task requirements. Very sorry for disturbance.

Thank you very much!

On Mon, Sep 15, 2014 at 1:19 AM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Sun, Sep 14, 2014 at 08:54:43PM +0800, Amitabha Yin wrote:
>> Hello all,
>>
>> Set EXTRAVERSION to -eudyptula in Makefile for
>> Task 03 of the Eudyptula Challenge.
>>
>
> i think you are supposed to send the patch to little and not here.
>
> thanks
> sudip
>
>> Signed-off-by: Ping Yin <angelo.yin@gmail.com>
>> --
>> diff --git a/Makefile b/Makefile
>> index 1a60bdd..c6e6859 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,7 +1,7 @@
>>  VERSION = 3
>>  PATCHLEVEL = 17
>>  SUBLEVEL = 0
>> -EXTRAVERSION = -rc4
>> +EXTRAVERSION = -eudyptula
>>  NAME = Shuffling Zombie Juror
>>
>>  # *DOCUMENTATION*
>> --
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
