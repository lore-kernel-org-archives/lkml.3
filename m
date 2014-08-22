Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaHVVrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:47:39 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37488 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140822.144011.1708163582352708529.davem@davemloft.net>
References: <20140822.114711.856705392345846995.davem@davemloft.net>
	<CA+55aFxsf02Lt+rFOxf0rXu1WoqZW0omGzwdHUfSfo+O9EqUAw@mail.gmail.com>
	<20140822.144011.1708163582352708529.davem@davemloft.net>
Date: Fri, 22 Aug 2014 14:47:36 -0700
X-Google-Sender-Auth: Ih2hfYGl23TxvmArdqc6T3p7vpE
Message-ID: <CA+55aFy+2WiFDRDZwb9B3bh9HS_5Q8K=2PpTHkzi7keSzwc67g@mail.gmail.com>
Subject: Re: [GIT PULL] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 2:40 PM, David Miller <davem@davemloft.net> wrote:
>
> I think you can apply it directly and none of us will mind, and GIT
> will sort it all out during the next merge.

Ok, I'll apply it directly to my tree, since it affected my machine.
Now that I'm back home I probably won't see the channel switch
requests that caused the problem, but I just feel uncomfortable
running a known-broken kernel.

              Linus
