Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaKUQ1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:27:48 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:38884 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547AbaKUQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:27:46 -0500
Date: Fri, 21 Nov 2014 11:27:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121162742.GB15461@htj.dyndns.org>
References: <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
 <20141120233920.GC25393@htj.dyndns.org>
 <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andy.

On Thu, Nov 20, 2014 at 03:55:09PM -0800, Andy Lutomirski wrote:
> That doesn't appear to have anything to with nmi though, right?

I thought that was the main offender but, apparently, not any more.

> Wouldn't this issue be fixed by moving the vmalloc_fault check into
> do_page_fault before exception_enter?

Can you please elaborate why that'd fix the issue?  I'm not
intimiately familiar with the fault handling so it'd be great if you
can give me some pointers in terms of where to look at.

Thanks.

-- 
tejun
