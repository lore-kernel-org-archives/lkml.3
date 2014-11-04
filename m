Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaKDUTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:19:07 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46642 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDUTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:19:05 -0500
Date: Tue, 4 Nov 2014 20:18:59 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        paulus@samba.org, mpe@ellerman.id.au,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, eiko.carstens@de.ibm.com,
        linux390@de.ibm.com, Chris Metcalf <cmetcalf@tilera.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, dave.long@linaro.org,
        Christoph Hellwig <hch@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH] make CONFIG_STRICT_DEVMEM a core non-debug feature
Message-ID: <20141104201859.GZ22224@bivouac.eciton.net>
References: <1415121836-16241-1-git-send-email-leif.lindholm@linaro.org>
 <CAGXu5jL1BBAvoxVqFa1YHJSMCbGdLiPey-dyC15YKVPB2xGfig@mail.gmail.com>
 <20141104195914.GY22224@bivouac.eciton.net>
 <CAGXu5jJnaAFMUBR50TgapRzRcvKS0j=XO7u9z6fdNouwMb=_sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJnaAFMUBR50TgapRzRcvKS0j=XO7u9z6fdNouwMb=_sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:02:32PM -0800, Kees Cook wrote:
> > I considered doing that, but didn't want to risk listing too many
> > details of one architecture, and too few of others.
> 
> Well, the others only say "memory mapped peripherals", so that's what
> I was suggesting adding the x86 language: it was the most detailed
> about what that would really mean to the end-user.

The problem is that this currently isn't strictly speaking true for
some architectures (at least not arm*). Without a standardised memory
map, we are exposing mapping anything not system RAM.

(Patches related to that will follow later this month.)

/
    Leif
