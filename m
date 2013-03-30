Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3C3Bgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:36:48 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64408 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab3C3Bgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
Date: Sat, 30 Mar 2013 08:36:39 +0700
Message-ID: <CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, Mar 30, 2013 at 6:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Emmanuel, can you try the attached patch? I think it applies cleanly
> on top of the scalability series too without any changes, but I didn't
> check if the patches perhaps changed some of the naming or something.

I had to slightly modify the patch since it wouldn't match the changes
introduced by 7-7-ipc-sem-fine-grained-locking-for-semtimedop.patch,
hope that was the right thing to do. So, what I tried was: original 7
patches + the one liner + your patch blindly modified by me on the top
of 3.9-rc4 and I'm still having twilight zone issues.
