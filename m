Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3LZSKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:10:37 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:65197 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3LZSKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:10:35 -0500
MIME-Version: 1.0
In-Reply-To: <52BC6F79.7040006@zytor.com>
References: <20131225165834.GA1526@gmail.com>
	<20131226155410.GH23355@gmail.com>
	<52BC6D0A.8060407@zytor.com>
	<CAMe9rOoS4qMmTyyHvv2xq1zyFuKFk=++kfx7mM_CGhS-b8fTkA@mail.gmail.com>
	<52BC6F79.7040006@zytor.com>
Date: Thu, 26 Dec 2013 10:10:35 -0800
Message-ID: <CAMe9rOpM_i-8dD7Ga33wMSdALBWWjgfCZDxRjpUkuG-Qht4NAA@mail.gmail.com>
Subject: Re: [PATCH] Use __kernel_long_t in struct mq_attr
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 10:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/26/2013 09:59 AM, H.J. Lu wrote:
>>
>>> but it would seem to give the wrong types when __BITS_PER_LONG in
>>> userspace is 32.
>>>
>>
>> For x32,  __BITS_PER_LONG is 64, not 32. If __BITS_PER_LONG
>>  is 32, my patch doesn't change anything.  If it works before,
>> it still works.  If it is broken before, it remains broken.
>>
>> I prefer my first patch, which is less clutter.  But I can't guarantee
>> it is correct for all x3-like ABIs.  My second patch has more
>> clutter, but it has no impact on other ABIs.
>>
>
> It's rather simple to prove, which is to consider the generic definition
> of __kernel_[u]long_t.
>

Then. I withdrew my second alternative with  __BITS_PER_LONG == 64
check..  Please use my first alternative for all my kernel_long_t and
kernel_ulong_t patches.

Thanks.

-- 
H.J.
