Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab3CYPUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:20:22 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:65505 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab3CYPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <51505923.2070504@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	<CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	<CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
	<CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
	<CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
	<CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com>
	<51505881.5060409@surriel.com>
	<51505923.2070504@surriel.com>
Date: Mon, 25 Mar 2013 22:20:19 +0700
Message-ID: <CA+i8gKKOPkVRBjqQb8=9T_eyw_oF5jedKMqG1U=Kwa3OHsMW_g@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
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

On Mon, Mar 25, 2013 at 9:03 PM, Rik van Riel <riel@surriel.com> wrote:
>>> With the first four patches only, I got some X server freeze (just
>>> tried once).
>>
>>
>> Could you try booting with panic=1 so the kernel panics on the first
>> oops?
>
>
> Sorry that should be "oops=panic"
>
>
>> Maybe that way (if we are lucky) we will be able to capture the first
>> oops, and maybe get an idea of what causes the problem.

Sorry Rik, I get all kind of weird behaviors (wireless dies, compiling
gets stuck and is impossible to kill, can't kill X) with the 4
patches+oops=panic but no trace. Here after is 7+1 patches with
oops=panic boot: http://i.imgur.com/1jep1qx.jpg
