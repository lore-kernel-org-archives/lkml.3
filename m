Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaGOTTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:19:44 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51234 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbaGOTTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <yw1xzjgaa1vg.fsf@unicorn.mansr.com>
References: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
	<1405448304-3724-6-git-send-email-xerofoify@gmail.com>
	<yw1xzjgaa1vg.fsf@unicorn.mansr.com>
Date: Tue, 15 Jul 2014 15:19:42 -0400
Message-ID: <CAPDOMVgJN5wC0yUQrRi8p7dyBz711_ZLFS+op78HsUaCj2U8eA@mail.gmail.com>
Subject: Re: [PATCH 6/6] alpha: Join lines 90 and 91
From: Nick Krause <xerofoify@gmail.com>
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: Richard Henderson <rth@twiddle.net>, ink@jurassic.park.msu.ru,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 2:54 PM, Måns Rullgård <mans@mansr.com> wrote:
> Nicholas Krause <xerofoify@gmail.com> writes:
>
>> This fixes the checkpatch error I get in this file relating to a
>> quoted string needed to be joined to the line above it.
>> ---
>>  arch/alpha/boot/bootpz.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
>> index 6fc840d..a9e127b 100644
>> --- a/arch/alpha/boot/bootpz.c
>> +++ b/arch/alpha/boot/bootpz.c
>> @@ -87,8 +87,7 @@ check_range(unsigned long vstart, unsigned long vend,
>>               kaddr = (find_pa(vaddr) | PAGE_OFFSET);
>>               if (kaddr >= kstart && kaddr <= kend) {
>>  #ifdef DEBUG_CHECK_RANGE
>> -                     srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx"
>> -                                " [0x%lx:0x%lx]\n",
>> +                     srm_printk("OVERLAP: vaddr 0x%lx kaddr 0x%lx" " [0x%lx:0x%lx]\n",
>>                                  vaddr, kaddr, kstart, kend);
>>  #endif
>
> If you're doing this, you should merge the strings too.
>
> --
> Måns Rullgård
> mans@mansr.com

Very well,
I will merge the strings for this statement.
Nick
