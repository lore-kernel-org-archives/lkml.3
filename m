Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3CZSPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:15:05 -0400
Received: from shelob.surriel.com ([74.92.59.67]:44742 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3CZSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:15:00 -0400
Message-ID: <5151E590.70909@surriel.com>
Date: Tue, 26 Mar 2013 14:14:40 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Emmanuel Benisty <benisty.e@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com>  <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>  <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>  <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>  <CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>  <CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>  <CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>  <CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com> <1364320767.5146.11.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1364320767.5146.11.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 01:59 PM, Davidlohr Bueso wrote:

> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Subject: [PATCH] ipc, sem: prevent possible deadlock
>
> In semctl_main(), when cmd == GETALL, we're locking
> sma->sem_perm.lock (through sem_lock_and_putref), yet
> after the conditional, we lock it again.
> Unlock sma right after exiting the conditional.
>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
