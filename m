Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbbAWBFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:05:04 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45232 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbbAWBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <CANn89i+anRV98Y_EQGvMiPvc-JUu9KxmP2SY7kYXvjVw3Dj-KQ@mail.gmail.com>
References: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
	<CA+mtBx8yeLG7UwqtknAsUTBtpocspraBcfj5W-2vTBA5pC8LEQ@mail.gmail.com>
	<CANn89i+anRV98Y_EQGvMiPvc-JUu9KxmP2SY7kYXvjVw3Dj-KQ@mail.gmail.com>
Date: Fri, 23 Jan 2015 06:34:59 +0530
Message-ID: <CAP8vtKLzrDRWGC8y0cW5ig15p_-CyGktgY-P+kFKeBPvcpAN1g@mail.gmail.com>
Subject: Re: [PATCH] include:linux:Optimizations to __skb_push
From: Jamal Mohammad <md.jamalmohiuddin@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <therbert@google.com>, David Miller <davem@davemloft.net>,
        viro@zeniv.linux.org.uk,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:54 PM, Eric Dumazet <edumazet@google.com> wrote:
> On Thu, Jan 22, 2015 at 10:21 AM, Tom Herbert <therbert@google.com> wrote:
>
>> Hmm, this seems less readable to me. What is the effect of this patch?
>> Does the compiler even produce different assembly?
>
> No change at all in generated assembly, this looks not worth it.
>
> BTW, most __skb_push() callers ignore return value.
it just reduces the number of lines....
