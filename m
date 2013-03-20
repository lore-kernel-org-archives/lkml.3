Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3CTCGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:06:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50524 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3CTCGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:06:31 -0400
X-Nat-Received: from [202.181.97.72]:53378 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1363745171.27212
To: fenghua.yu@intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address by __pa_nodebug()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
Message-Id: <201303201106.GFD65688.JtOFMLFVSQFOOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 20 Mar 2013 11:06:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19032013 #9757476, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data (e.g.
> max_low_pfn) that haven't been setup yet in such early boot phase. To fix the
> issue, __pa_nodebug() replaces __pa_symbol() to get a global symbol's physical
> address.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/microcode_intel_early.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
This patch fixes my problem. Thank you.
