Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbaCOAoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 20:44:03 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64338 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaCOAoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 20:44:01 -0400
X-Nat-Received: from [202.181.97.72]:50791 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1394844239.22758
To: joseph.salisbury@canonical.com, Nagalakshmi.Nandigama@lsi.com,
        Sreekanth.Reddy@lsi.com
Cc: oleg@redhat.com, rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create() killable
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <53236AA2.7030105@canonical.com>
In-Reply-To: <53236AA2.7030105@canonical.com>
Message-Id: <201403150943.BIH30251.FOQLOOtFJHSMVF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 15 Mar 2014 09:43:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14032014 #7519940, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Salisbury wrote:
> A kernel bug report was opened against Ubuntu[0].  We performed a kernel
> bisect, and found that reverting the following commit resolved this bug:

I added a comment to that bug report.

This commit by chance revealed incorrect error handling of mptsas_probe() or
mptscsih_remove().
