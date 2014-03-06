Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaCFRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:54:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59515 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaCFRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:54:14 -0500
Date: Thu, 06 Mar 2014 12:54:12 -0500 (EST)
Message-Id: <20140306.125412.1583267049751920093.davem@davemloft.net>
To: markos.chandras@imgtec.com
Cc: linux-kernel@vger.kernel.org, dborkman@redhat.com
Subject: Re: [PATCH] tools/net/Makefile: Define PACKAGE to fix bfd build
 problems
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394097354-5290-1-git-send-email-markos.chandras@imgtec.com>
References: <1394097354-5290-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 09:54:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>
Date: Thu, 6 Mar 2014 09:15:54 +0000

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
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>

I think your subject needs to be adjusted, this patch doesn't fix a "bfd"
build problem.
