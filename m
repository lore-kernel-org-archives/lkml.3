Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaHVVdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:33:01 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45713 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaHVVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140822.114711.856705392345846995.davem@davemloft.net>
References: <20140822.114711.856705392345846995.davem@davemloft.net>
Date: Fri, 22 Aug 2014 14:32:58 -0700
X-Google-Sender-Auth: vk8F15wJ6xCelgGJxRsYN2Zh260
Message-ID: <CA+55aFxsf02Lt+rFOxf0rXu1WoqZW0omGzwdHUfSfo+O9EqUAw@mail.gmail.com>
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

On Fri, Aug 22, 2014 at 11:47 AM, David Miller <davem@davemloft.net> wrote:
>
> Here are some bug fixes that have piled up during ksummit/linuxcon.

Hmm. What happened to the patch titled "mac80211: fix channel switch
for chanctx-based drivers" by Michal Kazior?

That one fixes a rather nasty oops that results in dead machines. It's
generic wireless code, but hits with at least intel wireless cards. It
needs the AP to send a channel switch request, but if that happens
(and it does), the kernel goes belly-up.

            Linus
