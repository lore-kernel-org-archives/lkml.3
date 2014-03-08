Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaCHGSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 01:18:30 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44942 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCHGS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 01:18:28 -0500
MIME-Version: 1.0
In-Reply-To: <531A53CF.2000604@zytor.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<1391325599.6481.5.camel@europa>
	<530FCDD6.3060701@zytor.com>
	<531A53CF.2000604@zytor.com>
Date: Fri, 7 Mar 2014 22:18:27 -0800
Message-ID: <CALmL7E84ge7YyT5ooGM2n63J98jYCyPqD3vLpEQXKqo=r+2Zug@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 3:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Hi Suresh,
>
> Any thoughts on this?

hi Peter,

Can you please pickup the second short patch
(https://lkml.org/lkml/2014/2/3/21) which actually fixes the reported
problem at hand. And tested and acked by all the problem reporters.

I will respond shortly about the first patch (which is more of a cleanup).

thanks,
suresh
