Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3EYNob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:44:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40870 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3EYNo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130525121851.GB3746@kroah.com>
References: <51A0989A.6070100@nagafix.co.uk>
	<20130525121851.GB3746@kroah.com>
Date: Sat, 25 May 2013 15:44:27 +0200
Message-ID: <CAFLxGvx8aFWkPuFh4W3ffDRw-vtqYCHeBGtj4=KeOFvv2AyFBQ@mail.gmail.com>
Subject: Re: UML build broken since 3.0.75 (also affects 3.2.x)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Antoine Martin <antoine@nagafix.co.uk>, stable@vger.kernel.org,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 2:18 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, May 25, 2013 at 05:55:22PM +0700, Antoine Martin wrote:
>> Linus' vm patches broke the UML build in 3.0.75 onwards:
>>
>>   CC      mm/memory.o
>> mm/memory.c: In function ‘vm_iomap_memory’:
>> mm/memory.c:2363:2: error: implicit declaration of function
>> ‘io_remap_pfn_range’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[1]: *** [mm/memory.o] Error 1
>> make: *** [mm] Error 2
>>
>>
>> This fix is just a copy of what is found in later kernels.
>
> What is that git commit id?

commit 4d94d6d030adfdea4837694d293ec6918d133ab2
Author: Richard Weinberger <richard@nod.at>
Date:   Tue Feb 7 01:22:47 2012 +0100

    um: Serve io_remap_pfn_range()

    At some places io_remap_pfn_range() is needed.
    UML has to serve it like all other archs do.

    Signed-off-by: Richard Weinberger <richard@nod.at>

--
Thanks,
//richard
