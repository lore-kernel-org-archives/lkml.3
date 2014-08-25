Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaHYAjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 20:39:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51637 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaHYAjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 20:39:22 -0400
Date: Sun, 24 Aug 2014 17:39:19 -0700 (PDT)
Message-Id: <20140824.173919.1884241872806255607.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        rostedt@goodmis.org, dborkman@redhat.com, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, brendan.d.gregg@gmail.com,
        namhyung@kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
        keescook@chromium.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net-next 00/29] BPF syscall, maps, verifier,
 samples, llvm
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408911690-7598-1-git-send-email-ast@plumgrid.com>
References: <1408911690-7598-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Aug 2014 17:39:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Sun, 24 Aug 2014 13:21:01 -0700

> enough RFCs, let's finalize it...

Please break this down into smaller, easier to review, sets
of changes.

Asking people to review nearly 30 patches at once isn't reasonable.

Shoot for something like about 10 at a time, at most.

Thank you.
