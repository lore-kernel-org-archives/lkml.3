Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaCLEIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:08:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33433 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCLEIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:08:35 -0400
Date: Wed, 12 Mar 2014 00:08:33 -0400 (EDT)
Message-Id: <20140312.000833.1949958699048857702.davem@davemloft.net>
To: markos.chandras@imgtec.com
Cc: linux-kernel@vger.kernel.org, dborkman@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] tools/net/Makefile: Define PACKAGE to fix build
 problems
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394527779-6995-1-git-send-email-markos.chandras@imgtec.com>
References: <1394447988-31299-1-git-send-email-markos.chandras@imgtec.com>
	<1394527779-6995-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Mar 2014 21:08:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>
Date: Tue, 11 Mar 2014 08:49:39 +0000

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
> CC: netdev@vger.kernel.org
> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>

Applied, thank you.
