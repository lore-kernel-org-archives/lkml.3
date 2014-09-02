Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaIBI3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:29:44 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:59343 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:29:41 -0400
Message-ID: <54057FF1.2010805@codethink.co.uk>
Date: Tue, 02 Sep 2014 09:29:37 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
References: <CACVxJT9FWrGV=LOR11MoK1LEc6b9orDrA1dRAqMiT2Z=OnOQsg@mail.gmail.com> <54047A96.1090900@codethink.co.uk> <CACVxJT_nkS9evtCd5x6GH3Fiyg+hO+bJCzvz3pgdxsUj+fwQVw@mail.gmail.com> <540484FB.1060906@codethink.co.uk> <20140901212250.GJ7996@ZenIV.linux.org.uk>
In-Reply-To: <20140901212250.GJ7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/14 22:22, Al Viro wrote:
> On Mon, Sep 01, 2014 at 03:38:51PM +0100, Rob Jones wrote:
>>>> kmalloc where it is expected to be a size_t.
>>>
>>> Which is a mistake too because allocations are never that large.
>>
>> Yet.
>
> *raised eyebrow*
>
> You do realize that kmalloc() gives physically contiguous allocation, right?

Do please try to not be quite so patronizing. It's very counter-
productive.

> And refuses to allocate more than KMALLOC_MAX_SIZE, while we are at it.
> With allocations anywhere near such range being very heavily discouraged.
>
> There might or might not be point in using size_t for kmalloc() argument,
> but "future-proofing" isn't it.

Indeed, and I am following up those arguments with people that may want
to be constructive.

>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
