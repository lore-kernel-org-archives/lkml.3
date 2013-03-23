Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3CWDTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 23:19:18 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:63974 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3CWDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 23:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
Date: Sat, 23 Mar 2013 10:19:16 +0700
Message-ID: <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Mar 22, 2013 at 10:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 22, 2013 at 4:04 AM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>
>> I was trying your patchset and my machine died while building a
>> package. I could reproduce the bug the (only) two times I tried.
>> There's a poor quality picture here: http://i.imgur.com/MuYuyQC.jpg
>
> Hmm. The original oops may well have scrolled off the window, what
> remains is just indicating something is corrupted in slab. Which isn't
> likely to give much hints..
>
> Can you try to reproduce this with CONFIG_SLUB_DEBUG=y and
> CONFIG_SLUB_DEBUG_ON=y, and see if there are any earlier messages?

I could reproduce it but could you please let me know what would be
the right tools I should use to catch the original oops?
This is what I got but I doubt it will be helpful:
http://i.imgur.com/Mewi1hC.jpg

Thanks.
