Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaARWY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 17:24:57 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60986 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaARWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 17:24:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140118221212.GB15543@pd.tnic>
References: <1390078081-26030-1-git-send-email-gurligebis@gentoo.org>
	<1390079163.25980.2.camel@x41>
	<CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
	<20140118221212.GB15543@pd.tnic>
Date: Sat, 18 Jan 2014 23:24:53 +0100
X-Google-Sender-Auth: gIeDDV5Wc4L6bnQhsQkQ2UOuLGQ
Message-ID: <CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/18 Borislav Petkov <bp@alien8.de>:
> On Sat, Jan 18, 2014 at 11:07:10PM +0100, Bjarke Istrup Pedersen wrote:
>> I have been thinking about other solutions, but so far, I haven't been
>> able to find one that solves it, so the tools build. (An option might
>> be to strip it from the __KERNEL__ part, to make it smaller, but I
>> don't know what difference that would make :-)
>
> The fix is to move the userspace stuff into the uapi header and include
> that header in the kernel header.
>
> See include/linux/sched.h and many others for an example.
>
Okay, so let me see if I get this right.

I should take all the parts the is not guarded by __KERNEL__, and move
them to a uapi header, and then include it at the top of the normal
header.
Correct understood? :)

/Bjarke
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
