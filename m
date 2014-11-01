Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbaKAT4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:56:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:47431 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbaKAT4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:56:50 -0400
Date: Sat, 1 Nov 2014 20:56:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 4/8] x86: Add a comment clarifying LDT context
 switching
In-Reply-To: <0db86397f968996fb772c443c251415b0b430ddd.1414190806.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1411012056240.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <0db86397f968996fb772c443c251415b0b430ddd.1414190806.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Andy Lutomirski wrote:
> The code is correct, but only for a rather subtle reason.  This
> confused me for quite a while when I read switch_mm, so clarify the
> code to avoid confusing other people, too.
> 
> TBH, I wouldn't be surprised if this code was only correct by
> accident.

:)
 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
