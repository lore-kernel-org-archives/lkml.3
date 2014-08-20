Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaHTNMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:12:41 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:45190 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHTNMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWz+4ctGr92fJmi0GB1QrxRMy3GKC_KDpZfK-sriYP-FQ@mail.gmail.com>
References: <1408482065-18457-1-git-send-email-bobby.prani@gmail.com> <CAMuHMdWz+4ctGr92fJmi0GB1QrxRMy3GKC_KDpZfK-sriYP-FQ@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 09:12:08 -0400
Message-ID: <CAJhHMCCkCSKEB1uUXEwj=NjMoK30q+3xBkbEP9Lwy=hXuCpbcw@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build failure when MEMORY_HOTPLUG=y
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 4:00 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

>> 1.9.1
>
> In light of my investigation for your spufs patch, I guess this is a non-SMP
> PSERIES config?

So what happens is SELECT_MEMORY_MODEL choses FLATMEM_MANUAL because
of which SPARSEMEM is not enabled despite having
ARCH_SPARSEMEM_ENABLE=y.

-- 
Pranith
