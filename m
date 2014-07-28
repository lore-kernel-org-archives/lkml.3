Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaG1Fn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:43:26 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59157 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1FnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <fc0f860634c4.53d5952a@langara.bc.ca>
References: <fc0f860634c4.53d5952a@langara.bc.ca>
Date: Mon, 28 Jul 2014 01:43:23 -0400
Message-ID: <CAPDOMVj7H8eWLp+mtPUK2odos4c2VKu=qG+H8=V5_iTnGp4nEg@mail.gmail.com>
Subject: Re: Bug 24912 - I think this one fell through the cracks a bit
From: Nick Krause <xerofoify@gmail.com>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 8:11 PM, Steven Stewart-Gallus
<sstewartgallus00@mylangara.bc.ca> wrote:
> Hello,
>
> I think that bug 2491 at
> https://bugzilla.kernel.org/show_bug.cgi?id=24912 sort of fell through
> the cracks and I'm not sure as many people are aware of it as there
> could be. This bug is that one can't mount bind mounts readonly but
> can only remount them readonly which is insufficient for recursive
> bind mounts and certain kinds of sandboxing. Also the bind mount fails
> silenty without giving an error which is never a good idea.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Steven,
It's late now but I will look into this tomorrow and see if I can
trace the issue
and may be write a solution.
Cheers Nick
