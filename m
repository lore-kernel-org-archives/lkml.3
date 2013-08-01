Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3HBCFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:05:12 -0400
Received: from ozlabs.org ([203.10.76.45]:55378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3HBCFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:05:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Rapoport <mike.rapoport@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] lguest64
In-Reply-To: <CABpLfoiKnbkHq9oT3yk72583yYKz_AMotLVV-Cu1sw1B1GH0xw@mail.gmail.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <87zjte9iah.fsf@rustcorp.com.au> <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com> <51F9005F.30501@zytor.com> <CABpLfoiKnbkHq9oT3yk72583yYKz_AMotLVV-Cu1sw1B1GH0xw@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 01 Aug 2013 11:42:29 +0930
Message-ID: <8761vq40s2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport <mike.rapoport@gmail.com> writes:
> On Wed, Jul 31, 2013 at 3:17 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/31/2013 02:39 AM, Mike Rapoport wrote:
>>>
>>> The use case I had in mind is to use lguest as a nested hypervisor in
>>> public clouds. As of today, major public clouds do not support nested
>>> virtualization and it's not clear at all if they will expose this
>>> ability in their deployments. Addition of 64-bit support for lguest
>>> won't require changes to pvops and, as far as I can tell, won't change
>>> the number of pvops users...
>>>
>>
>> "We can add a pvops user and that won't change the number of pvops
>> users" What?!
>
> We modify existing pvops user, IMHO. lguest is existing pvops user and
> my idea was to extend it, rather than add lguest64 alongside lguest32.

Well, lguest is particularly expendable.  It's the red shirt of the
virtualization away team.

Unlike HPA, I would advocate for applying the patches if you produced
them.  But I'd be aware that they're likely to be ripped out as soon as
pvops has no other users.

Cheers,
Rusty.
