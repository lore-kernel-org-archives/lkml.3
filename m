Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaFYL5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:57:48 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:53717 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaFYL5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:57:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140625062510.GB4260@osiris>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
	<20140623065835.GF19860@laptop.programming.kicks-ass.net>
	<1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
	<20140625062510.GB4260@osiris>
Date: Wed, 25 Jun 2014 04:57:45 -0700
X-Google-Sender-Auth: UpIYLaYXax6X8Tf0GMonX1lsSeg
Message-ID: <CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>
Subject: Re: [PATCH] arch,locking: Ciao arch_mutex_cpu_relax()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:25 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> Maybe cpu_relax_spin() ? However that doesn't sound much better as well.

"cpu_relax_lowlatency()", perhaps? Naming it for what the use is
("relax, but only if you can do it with very low latency")

             Linus
