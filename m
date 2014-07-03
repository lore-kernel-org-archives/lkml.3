Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaGCBGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:06:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:48568 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGCBGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:06:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140702063224.GA13864@samfundet.no>
References: <1404183899-5953-1-git-send-email-xerofoify@gmail.com>
	<20140701065554.GA20782@samfundet.no>
	<CAPDOMViGUR=QP+Dxbq+SYsSuv2ituygL4gMz638kLFwKDr0GXg@mail.gmail.com>
	<20140702063224.GA13864@samfundet.no>
Date: Wed, 2 Jul 2014 21:06:10 -0400
Message-ID: <CAPDOMVh3KNcUfdR-DBneksbz6jEr0MvS3a8DdUVfS_fOzsqbmA@mail.gmail.com>
Subject: Re: [PATCH] Remove memory start and memory end
From: Nick Krause <xerofoify@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the typo. Need time will prefix subsystem or area of kernel fixed.
Cheers Nick

On Wed, Jul 2, 2014 at 2:32 AM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Tue 01 Jul 2014 18:22:53 -0400 or thereabout, Nick Krause wrote:
>> No problem , just happy it was of help to you.
>> Cheers Nick
>
> I did take the liberty of fixing a typo, uneeded => unneeded, and prefixing
> the subject with avr32:. Have a nice day (-:
>
>> On Tue, Jul 1, 2014 at 2:55 AM, Hans-Christian Egtvedt
>> <egtvedt@samfundet.no> wrote:
>>> Around Mon 30 Jun 2014 23:04:59 -0400 or thereabout, Nicholas Krause wrote:
>>>> This patch removes the uneeded variables memory start and memory
>>>> stated in FIXME message before declaring this variables as extern
>>>> unsigned longs.
>>>
>>> Thanks for cleaning, I will append it to my for-linus branch. Queuing it for
>>> 3.17 most likely.
>>>
>>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>>>
>>>
>>> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>>>
>>>> ---
>>>>  arch/avr32/include/asm/page.h | 3 ---
>>>>  1 file changed, 3 deletions(-)
>>>
>>> <snipp diff>
> --
> mvh
> Hans-Christian Egtvedt
