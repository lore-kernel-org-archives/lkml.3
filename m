Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3GZTyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:54:17 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:41184 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3GZTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130726155458.GA31613@arm.com>
References: <20130726155458.GA31613@arm.com>
Date: Fri, 26 Jul 2013 12:54:14 -0700
X-Google-Sender-Auth: 1cRsY4XqBKCH1t4LOGpz6rWlXPQ
Message-ID: <CA+55aFzmEhGvqY883Bg568Gguewy41X9n1qDeaHkW2We6VVhZg@mail.gmail.com>
Subject: Re: [GIT PULL] arm64 fixes for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 8:55 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> - Stack size increased to 16K (similar to other 64-bit architectures)

I pulled, but this is misleading.

*Some* other 64-bit architectures do 16k stack sizes. But neither
x86-64 nor powerpc do, afaik. Instead, they do irq stacks, which is
generally a better idea than having one big stack.

                Linus
