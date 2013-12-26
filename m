Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3LZSDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:03:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45150 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3LZSDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:03:46 -0500
Message-ID: <52BC6F79.7040006@zytor.com>
Date: Thu, 26 Dec 2013 10:03:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t in struct mq_attr
References: <20131225165834.GA1526@gmail.com>	<20131226155410.GH23355@gmail.com>	<52BC6D0A.8060407@zytor.com> <CAMe9rOoS4qMmTyyHvv2xq1zyFuKFk=++kfx7mM_CGhS-b8fTkA@mail.gmail.com>
In-Reply-To: <CAMe9rOoS4qMmTyyHvv2xq1zyFuKFk=++kfx7mM_CGhS-b8fTkA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 09:59 AM, H.J. Lu wrote:
> 
>> but it would seem to give the wrong types when __BITS_PER_LONG in
>> userspace is 32.
>>
> 
> For x32,  __BITS_PER_LONG is 64, not 32. If __BITS_PER_LONG
>  is 32, my patch doesn't change anything.  If it works before,
> it still works.  If it is broken before, it remains broken.
> 
> I prefer my first patch, which is less clutter.  But I can't guarantee
> it is correct for all x3-like ABIs.  My second patch has more
> clutter, but it has no impact on other ABIs.
> 

It's rather simple to prove, which is to consider the generic definition
of __kernel_[u]long_t.

	-hpa

