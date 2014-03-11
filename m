Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaCKBxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:53:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49206 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaCKBxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:53:54 -0400
Date: Mon, 10 Mar 2014 21:53:52 -0400 (EDT)
Message-Id: <20140310.215352.573291450790920864.davem@davemloft.net>
To: markos.chandras@imgtec.com
Cc: linux-kernel@vger.kernel.org, dborkman@redhat.com
Subject: Re: [PATCH v2] tools/net/Makefile: Define PACKAGE to fix build
 problems
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394447988-31299-1-git-send-email-markos.chandras@imgtec.com>
References: <1394447988-31299-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 18:53:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>
Date: Mon, 10 Mar 2014 10:39:48 +0000

> Fixes the following build problem with binutils-2.24
> 
> gcc -Wall -O2   -c -o bpf_jit_disasm.o bpf_jit_disasm.c
> In file included from bpf_jit_disasm.c:25:0:
> /usr/include/bfd.h:35:2: error: #error config.h must be included
> before this header
>  #error config.h must be included before this header
> 
> This is similar to commit 3ce711a6abc27abce1554e1d671a8762b7187690
> "perf tools: bfd.h/libbfd detection fails with recent binutils"
> 
> See: https://sourceware.org/bugzilla/show_bug.cgi?id=14243
> 
> CC: David S. Miller <davem@davemloft.net>
> CC: Daniel Borkmann <dborkman@redhat.com>
> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>

Please submit networking patches with netdev@vger.kernel.org at least
CC:'d so that such patches can be properly tracked in patchwork.

Thank you.
