Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbAVSYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:24:49 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36450 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbAVSYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:24:46 -0500
MIME-Version: 1.0
In-Reply-To: <CA+mtBx8yeLG7UwqtknAsUTBtpocspraBcfj5W-2vTBA5pC8LEQ@mail.gmail.com>
References: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
	<CA+mtBx8yeLG7UwqtknAsUTBtpocspraBcfj5W-2vTBA5pC8LEQ@mail.gmail.com>
Date: Thu, 22 Jan 2015 10:24:45 -0800
Message-ID: <CANn89i+anRV98Y_EQGvMiPvc-JUu9KxmP2SY7kYXvjVw3Dj-KQ@mail.gmail.com>
Subject: Re: [PATCH] include:linux:Optimizations to __skb_push
From: Eric Dumazet <edumazet@google.com>
To: Tom Herbert <therbert@google.com>
Cc: Mohammad Jamal <md.jamalmohiuddin@gmail.com>,
        David Miller <davem@davemloft.net>, viro@zeniv.linux.org.uk,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:21 AM, Tom Herbert <therbert@google.com> wrote:

> Hmm, this seems less readable to me. What is the effect of this patch?
> Does the compiler even produce different assembly?

No change at all in generated assembly, this looks not worth it.

BTW, most __skb_push() callers ignore return value.
