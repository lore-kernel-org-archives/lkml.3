Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030350AbaGAWWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:22:55 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:51040 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaGAWWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140701065554.GA20782@samfundet.no>
References: <1404183899-5953-1-git-send-email-xerofoify@gmail.com>
	<20140701065554.GA20782@samfundet.no>
Date: Tue, 1 Jul 2014 18:22:53 -0400
Message-ID: <CAPDOMViGUR=QP+Dxbq+SYsSuv2ituygL4gMz638kLFwKDr0GXg@mail.gmail.com>
Subject: Re: [PATCH] Remove memory start and memory end
From: Nick Krause <xerofoify@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem , just happy it was of help to you.
Cheers Nick

On Tue, Jul 1, 2014 at 2:55 AM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Mon 30 Jun 2014 23:04:59 -0400 or thereabout, Nicholas Krause wrote:
>> This patch removes the uneeded variables memory start and memory
>> stated in FIXME message before declaring this variables as extern
>> unsigned longs.
>
> Thanks for cleaning, I will append it to my for-linus branch. Queuing it for
> 3.17 most likely.
>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>
>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>
>> ---
>>  arch/avr32/include/asm/page.h | 3 ---
>>  1 file changed, 3 deletions(-)
>
> <snipp diff>
>
> --
> mvh
> Hans-Christian Egtvedt
