Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305Ab3ECStS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:49:18 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58260 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763282Ab3ECStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:49:16 -0400
X-Nat-Received: from [202.181.97.72]:54160 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367606944.19362
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
	<201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
	<0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
In-Reply-To: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
Message-Id: <201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 May 2013 03:48:58 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03052013 #9876525, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying

  Subject: slab: Return NULL for oversized allocations
  (Date: Fri, 3 May 2013 15:43:18 +0000)

and

  Subject: Fix bootstrap creation of kmalloc caches
  (Date: Fri, 3 May 2013 18:04:18 +0000)

on linux-next-20130426 made my kernel boots fine and passes the allocation
testcases. Thank you.
