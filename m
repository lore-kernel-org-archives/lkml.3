Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaJDIXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 04:23:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:38657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaJDIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 04:23:20 -0400
Date: Sat, 4 Oct 2014 10:23:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: linux-mips@linux-mips.org, Zubair.Kakakhel@imgtec.com,
        david.daney@cavium.com, paul.gortmaker@windriver.com, davidlohr@hp.com,
        macro@linux-mips.org, chenhc@lemote.com, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, alex@alex-smith.me.uk,
        tglx@linutronix.de, blogic@openwrt.org, jchandra@broadcom.com,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        markos.chandras@imgtec.com, manuel.lauss@gmail.com,
        akpm@linux-foundation.org, lars.persson@axis.com
Subject: Re: [PATCH 0/3] MIPS executable stack protection
Message-ID: <20141004082307.GS10583@worktop.programming.kicks-ass.net>
References: <20141004030438.28569.85536.stgit@linux-yegoshin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004030438.28569.85536.stgit@linux-yegoshin>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 08:17:14PM -0700, Leonid Yegoshin wrote:
> The following series implements an executable stack protection in MIPS.
> 
> It sets up a per-thread 'VDSO' page and appropriate TLB support.

So traditionally we've always avoided per-thread pages like that. What
makes it worth it on MIPS?
