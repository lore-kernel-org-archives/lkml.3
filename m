Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbaLJTFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:05:18 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:45442 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaLJTFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:05:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412091504490.16275@nanos>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
Date: Wed, 10 Dec 2014 11:05:15 -0800
X-Google-Sender-Auth: hNmJxspoDCf6z07kDK-ut_UaboM
Message-ID: <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
Subject: Re: [GIT pull] x86 mpx support for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 6:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mpx-for-linus

So I've pulled this (not pushed out yet, I've done all the
allmodconfig builds, but I want to reboot into this all too), but I'm
not entirely sure I'm happy about how it enabled MPX support by
default.

Why would I want to enable this in my kernel when there are no actual
CPU's out yet that support it? And even when there are, why would I do
it if the CPU I have doesn't support it?

So I think it needs to be a real config option with a real question,
not a "def_bool" that just depends on "do you want to support Intel
CPU's"

                        Linus
