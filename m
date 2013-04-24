Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab3DXM21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:28:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63284 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3DXM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:28:26 -0400
X-Nat-Received: from [202.181.97.72]:51801 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366806485.32161
To: james.hogan@imgtec.com, hpa@zytor.com, rusty@rustcorp.com.au
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
	<201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
	<51772CD3.3040405@zytor.com>
	<51772EBC.1050600@zytor.com>
	<5177B061.50107@imgtec.com>
In-Reply-To: <5177B061.50107@imgtec.com>
Message-Id: <201304242128.JGD59575.OFFVLOSOJHFtQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 24 Apr 2013 21:28:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24042013 #9886291, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan wrote:
> How does the patch below look? I presume this is preferred over
> making VMLINUX_SYMBOL_STR non-argument-expanding?
> 
> Thanks
> James
> 
> Subject: [PATCH 1/1] modpost: fix unwanted VMLINUX_SYMBOL_STR expansion
> 
> Commit a4b6a77b77ba4f526392612c2365797fab956014 ("module: fix symbol
> versioning with symbol prefixes") broke the MODVERSIONS loading of any
> module using memcmp (e.g. ipv6) on x86_32, as it's defined to
> __builtin_memcmp which is expanded by VMLINUX_SYMBOL_STR. Use
> __VMLINUX_SYMBOL_STR instead which doesn't expand the argument.
> 
The patch solves this problem. Thank you.
