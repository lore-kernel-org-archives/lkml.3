Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaHMSzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:55:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:47304 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaHMSzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:55:47 -0400
Date: Wed, 13 Aug 2014 15:55:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Alex Snast <asnast@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Add beautifier for mremap flags param
Message-ID: <20140813185543.GC2718@kernel.org>
References: <1407944560-26924-1-git-send-email-asnast@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407944560-26924-1-git-send-email-asnast@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 06:42:40PM +0300, Alex Snast escreveu:
> ~/devel/kernel/tools/perf(branch:master*) » sudo ./perf trace ~/mremap_test
>      0.543 ( 0.003 ms): mprotect(start: 0x600000, len: 4096, prot: READ                       ) = 0
>      0.550 ( 0.003 ms): mprotect(start: 0x7f441260d000, len: 4096, prot: READ                 ) = 0
>      0.561 ( 0.010 ms): munmap(addr: 0x7f44125e2000, len: 165572                              ) = 0
>      0.595 ( 0.012 ms): mmap(len: 12288, prot: READ|WRITE, flags: SHARED|ANONYMOUS|LOCKED, fd: -1) = 0x12608000
>      0.603 ( 0.006 ms): mremap(addr: 0x7f4412608000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da295000) = 0xda295000
>      0.608 ( 0.003 ms): mremap(addr: 0x7f441260a000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da297000) = 0xda297000
>      0.612 ( 0.003 ms): mremap(addr: 0x7f4412609000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da296000) = 0xda296000
>      0.619 ( 0.000 ms): exit_group(
> 
> Signed-off-by: Alex Snast <asnast@gmail.com>

Thanks, applied.

- Arnaldo
