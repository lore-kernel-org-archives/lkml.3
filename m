Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3GWEZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:25:44 -0400
Received: from ozlabs.org ([203.10.76.45]:45365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3GWEZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:25:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] lguest64
In-Reply-To: <51E97779.3020103@zytor.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Jul 2013 10:58:06 +0930
Message-ID: <87zjte9iah.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
> On 07/19/2013 02:06 AM, Ramkumar Ramachandra wrote:
>> Hi,
>> 
>> I tried building lguest to play with it, but was disappointed to find
>> this in the Kconfig:
>> 
>>   depends on X86_32
>> 
>> Why is this [1]?  What is so hard about supporting 64-bit machines?  I
>> found a five-year old tree that claims to do lguest64 [2], but didn't
>> investigate further.
>> 
>
> Please don't have us deal with another lguest unless there is a use case
> for it.  We want to reduce pvops and pvops users, not increase them...
>
> 	-hpa

Yes, the subset of x86-64 machines for which there isn't hardware
virtualization support is pretty uninteresting.

Cheers,
Rusty.
