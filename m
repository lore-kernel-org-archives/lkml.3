Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaIEU4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:56:03 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:38114 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaIEUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <540A17A6.1000802@zytor.com>
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com>
	<540A17A6.1000802@zytor.com>
Date: Fri, 5 Sep 2014 13:55:56 -0700
Message-ID: <CAP6exY+ehqwpt0tC_Xa=ZP4jbjnzWii+=qc-=rqxC5rK5mG3Dg@mail.gmail.com>
Subject: Re: [coreboot] [PATCH] x86: add coreboot framebuffer support
From: ron minnich <rminnich@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        coreboot <coreboot@coreboot.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:

> I'm not a fan of Coreboot having invented its own nonstandard hacks, but
> I guess it is pretty much unavoidable.

I suspect this should not be architecture-dependent, since coreboot
tables work across 3 coreboot architectures at present with more on
the way.

Sometimes, something that spans more than an x86 can look like a
non-standard hack. At other times, it might look portable. Depends on
ones perspective I guess.

Gerd, I'll get back to you offline to show you what we did in Akaros.

ron
