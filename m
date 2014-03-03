Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaCCHBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:01:49 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44692 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaCCHBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:01:48 -0500
MIME-Version: 1.0
In-Reply-To: <m3bnxnpyok.fsf@t19.piap.pl>
References: <3980699.cFzmTHesZE@daeseok-laptop.cloud.net>
	<m3bnxnpyok.fsf@t19.piap.pl>
Date: Mon, 3 Mar 2014 16:01:47 +0900
Message-ID: <CAHb8M2AS2w9VBSJS9imU07ydMOZW+M-PD-Ja3iZYSTJ=2GNa-A@mail.gmail.com>
Subject: Re: [PATCH 3/5 v2] Staging: cxt1e1: Fix line length over 80
 characters in hwprobe.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: =?EUC-KR?Q?Krzysztof_Ha=A9=A9asa?= <khalasa@piap.pl>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        Shaun Laing <shaun@xresource.ca>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-03 15:46 GMT+09:00 Krzysztof Ha©©asa <khalasa@piap.pl>:
> Daeseok Youn <daeseok.youn@gmail.com> writes:
>
>> clean up checkpatch.pl warnings:
>>  WARNING: Line length over 80 characters
>
> This warning should be long gone IMHO. It does more harm than good.
>
>>               unsigned char *ucp = (unsigned char *) &hi->mfg_info.data;
>>
>>               pr_info("eeprom[00]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
>> -                             *(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3), *(ucp + 4), *(ucp + 5), *(ucp + 6), *(ucp + 7));
>> +                     *(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3),
>> +                     *(ucp + 4), *(ucp + 5), *(ucp + 6), *(ucp + 7));
>>               pr_info("eeprom[08]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
>> -                             *(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11), *(ucp + 12), *(ucp + 13), *(ucp + 14), *(ucp + 15));
>> +                     *(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11),
>> +                     *(ucp + 12), *(ucp + 13), *(ucp + 14), *(ucp + 15));
>>               pr_info("eeprom[16]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
>> -                             *(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19), *(ucp + 20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
>> +                     *(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19),
>> +                     *(ucp + 20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
>>               pr_info("eeprom[24]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
>> -                             *(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27), *(ucp + 28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
>> +                     *(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27),
>> +                     *(ucp + 28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
>>               pr_info("eeprom[32]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
>> -                             *(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35), *(ucp + 36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
>> +                     *(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35),
>> +                     *(ucp + 36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
>>               pr_info("eeprom[40]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
>> -                             *(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43), *(ucp + 44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
>> +                     *(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43),
>> +                     *(ucp + 44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
>>       }
>
> This one is probably an improvement, though... why not use some existing
> *hex_dump*() instead?
OK. but this patch is only for fix line length over 80 characters,
right? If it can be improved as your comment,
it must be in another patch.

>
>> -              * match with board's first found interface, otherwise this is first
>> -              * found
>> +              * match with board's first found interface, otherwise this is
>> +              * fisrt found
>                    ^^^^^
> I wonder what's your exact procedure for doing such changes :-)
"first" word is over 80 line character after applying my previous patch(2/5)
(previous patch is already merged to staging-next tree :-))
>
>>  #ifdef SBE_MAP_DEBUG
>>                       pr_warning("%s: io remapped from phys %x to virt %x\n",
>> -                                hi->devname, (u_int32_t) hi->addr[j], (u_int32_t) hi->addr_mapped[j]);
>> +                                hi->devname, (u_int32_t) hi->addr[j],
>> +                                (u_int32_t) hi->addr_mapped[j]);
>
> This one is fine, too. The others, I wouldn't touch them.
this line, same reason above one.
> --
> Krzysztof Halasa
>
> Research Institute for Automation and Measurements PIAP
> Al. Jerozolimskie 202, 02-486 Warsaw, Poland
