Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbaH0GMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:12:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55117 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbaH0GL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:11:59 -0400
Date: Tue, 26 Aug 2014 23:11:55 -0700 (PDT)
Message-Id: <20140826.231155.421325307812864648.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        rostedt@goodmis.org, dborkman@redhat.com, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, brendan.d.gregg@gmail.com,
        namhyung@kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
        keescook@chromium.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v7 net-next 00/28] BPF syscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Aug 2014 23:11:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 26 Aug 2014 19:29:14 -0700

> posting whole thing again as RFC to get feedback on syscall only.
> If syscall bpf(int cmd, union bpf_attr *attr, unsigned int size) is ok,

I'm personally not reviewing such a large patch series, sorry.

You need to submit smaller sets if you want to get reasonable
review of your changes and ideas.
