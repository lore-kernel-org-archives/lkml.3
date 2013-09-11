Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab3IKDpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:45:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49833 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3IKDpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:45:04 -0400
X-Nat-Received: from [202.181.97.72]:52907 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378871083.30293
Message-Id: <201309110344.r8B3ih0D017098@www262.sakura.ne.jp>
Subject: Re: [linux-next-20130822] module: broken module versions?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ak@linux.intel.com, viro@ZenIV.linux.org.uk, geert@linux-m68k.org,
        dhowells@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Sep 2013 12:44:43 +0900
References: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp> <201308270214.r7R2EXES054735@www262.sakura.ne.jp> <20130910172321.0392fea32f2a33e629a8204c@linux-foundation.org>
In-Reply-To: <20130910172321.0392fea32f2a33e629a8204c@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11092013 #11029558, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> OK, thanks, I\'ve dropped
> syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
> and scripts-mod-modpostc-handle-non-abs-crc-symbols.patch.

The problem was solved ( https://lkml.org/lkml/2013/9/4/188 ) and therefore
there is no need to drop these patches.

Regards.
