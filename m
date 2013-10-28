Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3J1I2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:28:53 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:44567 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3J1I2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:28:52 -0400
Date: Mon, 28 Oct 2013 09:28:48 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131028082848.GA276@x4>
References: <20131026122414.GA25026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026122414.GA25026@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.10.26 at 14:24 +0200, Ingo Molnar wrote:
>  - Reversal of the new 'MMAP2' extended mmap record ABI, introduced 
>    in this merge window. (Patches were proposed to fix it but it was
>    all a bit late and we felt it's safer to just delay the ABI one
>    more kernel release and do it right.)

commit 3090ffb5a2515990182f3f55b0688a7817325488
Author: Stephane Eranian <eranian@google.com>
Date:   Thu Oct 17 19:32:15 2013 +0200

    perf: Disable PERF_RECORD_MMAP2 support

The commit above breaks "perf top" on my system, because it causes only
[kernel] symbols to show up in the list. When I revert the commit I get
the usual mixture of userspace and kernel symbols in the list.

-- 
Markus
