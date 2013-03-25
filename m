Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3CYPxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:53:44 -0400
Received: from shelob.surriel.com ([74.92.59.67]:49086 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3CYPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:53:43 -0400
Message-ID: <51507301.3050601@surriel.com>
Date: Mon, 25 Mar 2013 11:53:37 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Emmanuel Benisty <benisty.e@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com> <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com> <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com> <CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com> <CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com> <CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com> <CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com> <51505881.5060409@surriel.com> <51505923.2070504@surriel.com> <CA+i8gKKOPkVRBjqQb8=9T_eyw_oF5jedKMqG1U=Kwa3OHsMW_g@mail.gmail.com>
In-Reply-To: <CA+i8gKKOPkVRBjqQb8=9T_eyw_oF5jedKMqG1U=Kwa3OHsMW_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 11:20 AM, Emmanuel Benisty wrote:
> On Mon, Mar 25, 2013 at 9:03 PM, Rik van Riel <riel@surriel.com> wrote:
>>>> With the first four patches only, I got some X server freeze (just
>>>> tried once).
>>>
>>>
>>> Could you try booting with panic=1 so the kernel panics on the first
>>> oops?
>>
>>
>> Sorry that should be "oops=panic"
>>
>>
>>> Maybe that way (if we are lucky) we will be able to capture the first
>>> oops, and maybe get an idea of what causes the problem.
>
> Sorry Rik, I get all kind of weird behaviors (wireless dies, compiling
> gets stuck and is impossible to kill, can't kill X) with the 4
> patches+oops=panic but no trace. Here after is 7+1 patches with
> oops=panic boot: http://i.imgur.com/1jep1qx.jpg

This may be a stupid question, but you re-compile and re-install
the kernel modules every time you changed the kernel?

The behaviour you report with just the first four patches is so
random, it sounds almost like a mismatched data structure between
compiles...

-- 
All rights reversed.
