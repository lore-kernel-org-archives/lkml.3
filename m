Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaHRVIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:08:50 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:40652 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHRVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:08:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXxpnXPqoo6cT2tmXxHmFc1syMxWnrc-khGxytVi81s0g@mail.gmail.com>
References: <1408388465-26577-1-git-send-email-bobby.prani@gmail.com>
 <CAMuHMdXutLPeyDYHdRJ6Heb4vhtg=zMTpwOpKq1h4Yyk8exUSQ@mail.gmail.com>
 <CAJhHMCDE8e019oLvO7QEcAB-=yqkmgF4OS2VwRrJNV+vvXOe5Q@mail.gmail.com> <CAMuHMdXxpnXPqoo6cT2tmXxHmFc1syMxWnrc-khGxytVi81s0g@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 17:08:18 -0400
Message-ID: <CAJhHMCBknUCxyf2QhHWxBZAijrLsFO+Gcyv-TZF9sUOASoyyWQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build failure for PPC_32
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Gerhard Sittig <gsi@denx.de>, Rob Herring <robh@kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 4:57 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Note that PowerPC supports multi-platform kernels.
> A kernel with PPC_PSERIES and something else with PCI may still want to
> have floppy support.

OK, I tested with your change and it works. I needed to make one more
change for it compile all the way through though.

I will send both of the patches shortly.

-- 
Pranith
