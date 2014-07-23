Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbaGWPGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:06:07 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:65007 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbaGWPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140723065013.GA15677@samfundet.no>
References: <1406097756-7912-1-git-send-email-xerofoify@gmail.com>
	<20140723065013.GA15677@samfundet.no>
Date: Wed, 23 Jul 2014 11:06:01 -0400
Message-ID: <CAPDOMVgXAA3dJ+x7H+BHqpc-5UNPh2X17FiCOJ6vWWWJ_b37WA@mail.gmail.com>
Subject: Re: [PATCH] avr32: Remove unnessary variables from page.h
From: Nick Krause <xerofoify@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 2:50 AM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Wed 23 Jul 2014 02:42:36 -0400 or thereabout, Nicholas Krause wrote:
>> This removes the unneeded variables memory_start and memory_end in
>> order to fix this fix me message.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>
> This is already applied to my local for-linus branch, it will be pushed once
> Linus opens up for merges after 3.16 is released.
>
>> ---
>>  arch/avr32/include/asm/page.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/avr32/include/asm/page.h b/arch/avr32/include/asm/page.h
>> index f805d1c..701006f 100644
>> --- a/arch/avr32/include/asm/page.h
>> +++ b/arch/avr32/include/asm/page.h
>> @@ -42,8 +42,6 @@ typedef struct page *pgtable_t;
>>  #define __pgd(x)             ((pgd_t) { (x) })
>>  #define __pgprot(x)          ((pgprot_t) { (x) })
>>
>> -/* FIXME: These should be removed soon */
>> -extern unsigned long memory_start, memory_end;
>>
>>  /* Pure 2^n version of get_order */
>>  static inline int get_order(unsigned long size)
> --
> mvh
> Hans-Christian Egtvedt


I wasn't sure if  I had sent this out. Seems I have :).
Cheers Nick
