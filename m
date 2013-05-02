Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3EBSxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:53:53 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:57263 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3EBSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy04mY5g-Aics9dcGpv6zgn2bu4iQ-_ifE5hun_t4E54Q@mail.gmail.com>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
	<CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
	<1367512467.4000.7.camel@dcbw.foobar.com>
	<1367519066.7757.19.camel@dcbw.foobar.com>
	<CA+55aFy04mY5g-Aics9dcGpv6zgn2bu4iQ-_ifE5hun_t4E54Q@mail.gmail.com>
Date: Thu, 2 May 2013 11:53:41 -0700
X-Google-Sender-Auth: GPMjfFtyij5pfLpul0Teor7nR_U
Message-ID: <CA+55aFy1P6TKZjWSvrJN6o=gAr7OTYQsoZORXGF6g8OnonBT=Q@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Williams <dcbw@redhat.com>
Cc: David Miller <davem@davemloft.net>, hayeswang <hayeswang@realtek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 11:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> but for some reason in the bad case NM just doesn't react past the
> "carrier now ON" part.

Grr. That was much more readable while editing, then gmail ended up
doing its "smart line wrap" thing and my nice long lines became a
mess. I think you can still figure it out,

            Linus
