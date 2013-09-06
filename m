Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3IFSQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:16:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49713 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IFSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <522A1627.3050900@tilera.com>
References: <522A1627.3050900@tilera.com>
Date: Fri, 6 Sep 2013 11:16:01 -0700
X-Google-Sender-Auth: TrmhgHIgcWWyagB4gS9sVc6idqQ
Message-ID: <CA+55aFzpmUtiw7OB54XS=PbZci3FZFpFc=5K8rViFqmW-D1qkw@mail.gmail.com>
Subject: Re: [GIT PULL] arch/tile changes for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 10:51 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>
> These changes bring in a bunch of new functionality that has been
> maintained internally at Tilera over the last year, plus other stray
> bits of work that I've taken into the tile tree from other folks.
> The changes include some PCI root complex work, interrupt-driven console
> support, support for performing fast-path unaligned data fixups by
> kernel-based JIT code generation, CONFIG_PREEMPT support, vDSO support
> for gettimeofday(), a serial driver for the tilegx on-chip UART,
> KGDB support, more optimized string routines, support for ftrace and
> kprobes, improved ASLR, and many bug fixes.  We also remove support for
> the old TILE64 chip, which is no longer buildable.

Your new tilegx on-chip uart ended up conflicting with the equally new
ST ASC serial driver..

Which had gotten the ID 105 already.

So I bumped you to 106. Yay! You're now one more.

              Linus
