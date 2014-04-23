Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbaDWTX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:23:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbaDWTX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:23:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <5354AD36.5090809@zytor.com> <CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com> <16597012.pEkDc99HDN@wuerfel> <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>,<5357FF8E.9010809@codesourcery.com> <E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 23 Apr 2014 12:21:22 -0700
To: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
CC: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Catalin.Marinas@arm.com" <Catalin.Marinas@arm.com>,
        Andrew Pinski <apinski@cavium.com>
Message-ID: <5b7c8d5a-48b0-416f-ae6f-e0f9caa73b0d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think Linuxs said we should just fix POSIX on that front.

On April 23, 2014 11:15:34 AM PDT, "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com> wrote:
>
>
>> On Apr 23, 2014, at 10:59 AM, "Chung-Lin Tang"
><cltang@codesourcery.com> wrote:
>> 
>>> On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
>>> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de>
>wrote:
>>>>> On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>>>>>> Hi Arnd and Peter Anvin,
>>>>>>> 
>>>>>>> Other than 64-bit time_t, clock_t and suseconds_t, can you
>confirm
>>>>>>> that we don't need to have 64 bit off_t? See detail in link
>below.
>>>>>>> I can submit the patches for 64-bit time changes
>>>>>>> (include/asm-generic/posix_types.h and other archs) if everyone
>is
>>>>>>> agreed on this.
>>>>> 
>>>>> Yes.
>>> Okay, will doing that.
>> 
>> I believe that arm64 ILP32 will also be affected. What is the status
>of
>> this configuration? Has the glibc/kernel ABI been finalized?
>
>Not yet.  I am still working out the signal handling part. But we
>already agreed on 64bit time_t, clock_t, and suseconds_t.  And we
>agreed to a 64bit offset_t too. 
>
>On a related note suseconds in the timespec in posix is defined to be
>long. So it would nice if the kernel ignores the upper 32bits so we
>(glibc developers) can fix this for new targets including x32 and
>arm64/ilp32. 
>
>Thanks,
>Andrew
>
>> 
>> Thanks,
>> Chung-Lin
>> 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
