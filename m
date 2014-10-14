Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaJNUHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:07:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44299 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaJNUHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:07:12 -0400
Date: Tue, 14 Oct 2014 16:07:07 -0400 (EDT)
Message-Id: <20141014.160707.30937593503083649.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        rostedt@goodmis.org, dborkman@redhat.com, hannes@stressinduktion.org,
        chema@google.com, edumazet@google.com, a.p.zijlstra@chello.nl,
        hpa@zytor.com, akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: filter: move common defines into bpf_common.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413277734-13053-1-git-send-email-ast@plumgrid.com>
References: <1413277734-13053-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 13:07:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 14 Oct 2014 02:08:54 -0700

> userspace programs that use eBPF instruction macros need to include two files:
> uapi/linux/filter.h and uapi/linux/bpf.h
> Move common macro definitions that are shared between classic BPF and eBPF
> into uapi/linux/bpf_common.h, so that user app can include only one bpf.h file
> 
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> 
> Daniel believes that this patch has to be done for this merge window.
> I think it can wait till next, but it won't hurt now either.

Applied, thanks everyone.
