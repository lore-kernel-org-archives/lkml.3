Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3IIMQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:16:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62801 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3IIMQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:16:50 -0400
X-Nat-Received: from [202.181.97.72]:59291 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378728999.25125
To: joe@perches.com
Cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org
Subject: [checkpatch.pl] runtime error by version dependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201309092116.GAG52609.LQJOHFFtOSOMFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 9 Sep 2013 21:16:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09092013 #11001181, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Commit d1fe9c09 "checkpatch: add some --strict coding style checks"
introduced dependency on perl >= 5.10.0 .

While the comment says that "Any use must be runtime checked with $^V",
it is not runtime checked when running with perl == v5.8.4 , failing with

  Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./scripts/checkpatch.pl line 340.

error.
