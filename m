Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3HBO16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:27:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49056 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3HBO15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:27:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <8761vq40s2.fsf@rustcorp.com.au>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <87zjte9iah.fsf@rustcorp.com.au> <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com> <51F9005F.30501@zytor.com> <CABpLfoiKnbkHq9oT3yk72583yYKz_AMotLVV-Cu1sw1B1GH0xw@mail.gmail.com> <8761vq40s2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [QUERY] lguest64
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 02 Aug 2013 07:27:40 -0700
To: Rusty Russell <rusty@rustcorp.com.au>,
        Mike Rapoport <mike.rapoport@gmail.com>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <8f931f05-e8e3-4d1e-a1f1-23fbd315fa32@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll look at them and consider to what degree they are likely to cause issues, but as Rusty says, it is the red shirt.

UML is also PV of course, but sits in its own corner and we x86 maintainers very rarely have to do something special to accommodate it.

Rusty Russell <rusty@rustcorp.com.au> wrote:
>Mike Rapoport <mike.rapoport@gmail.com> writes:
>> On Wed, Jul 31, 2013 at 3:17 PM, H. Peter Anvin <hpa@zytor.com>
>wrote:
>>> On 07/31/2013 02:39 AM, Mike Rapoport wrote:
>>>>
>>>> The use case I had in mind is to use lguest as a nested hypervisor
>in
>>>> public clouds. As of today, major public clouds do not support
>nested
>>>> virtualization and it's not clear at all if they will expose this
>>>> ability in their deployments. Addition of 64-bit support for lguest
>>>> won't require changes to pvops and, as far as I can tell, won't
>change
>>>> the number of pvops users...
>>>>
>>>
>>> "We can add a pvops user and that won't change the number of pvops
>>> users" What?!
>>
>> We modify existing pvops user, IMHO. lguest is existing pvops user
>and
>> my idea was to extend it, rather than add lguest64 alongside
>lguest32.
>
>Well, lguest is particularly expendable.  It's the red shirt of the
>virtualization away team.
>
>Unlike HPA, I would advocate for applying the patches if you produced
>them.  But I'd be aware that they're likely to be ripped out as soon as
>pvops has no other users.
>
>Cheers,
>Rusty.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
