Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3EBB2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:28:42 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:60484 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3EBB2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130501.164755.1859264969403837546.davem@davemloft.net>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
Date: Wed, 1 May 2013 18:28:38 -0700
X-Google-Sender-Auth: m3bSeDczGqs8VT9kdI9HQq3kTyU
Message-ID: <CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>, hayeswang <hayeswang@realtek.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 1:47 PM, David Miller <davem@davemloft.net> wrote:
>
> Highlights (1721 non-merge commits, this has to be a record of some
> sort):

Lowlight: it completely breaks my machine with r8169 ethernet.  In the
networkmanager applet, it claims no cable connection, which is a bit
odd, because (a) it works with an older kernel and (b) the kernel
messages actually say

  r8169 0000:01:00.0 eth0: link up

but nothing actually works.

 r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
 r8169 0000:01:00.0 eth0: RTL8168d/8111d at 0xffffc90010ece000,
e0:cb:4e:95:1a:d7, XID 083000c0 IRQ 53
 r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx
checksumming: ko]

Any ideas?

                  Linus
