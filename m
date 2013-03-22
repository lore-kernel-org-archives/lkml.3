Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3CVPhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:37:20 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:57920 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3CVPhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
Date: Fri, 22 Mar 2013 08:37:18 -0700
X-Google-Sender-Auth: 38MjCJPckcAvoKIWIsgIyDtaAII
Message-ID: <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
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

On Fri, Mar 22, 2013 at 4:04 AM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> I was trying your patchset and my machine died while building a
> package. I could reproduce the bug the (only) two times I tried.
> There's a poor quality picture here: http://i.imgur.com/MuYuyQC.jpg

Hmm. The original oops may well have scrolled off the window, what
remains is just indicating something is corrupted in slab. Which isn't
likely to give much hints..

Can you try to reproduce this with CONFIG_SLUB_DEBUG=y and
CONFIG_SLUB_DEBUG_ON=y, and see if there are any earlier messages?

                  Linus
