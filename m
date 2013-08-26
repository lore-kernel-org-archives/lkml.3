Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3HZT7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:59:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3HZT7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:59:23 -0400
Date: Mon, 26 Aug 2013 15:59:09 -0400 (EDT)
Message-Id: <20130826.155909.1859861206590524940.davem@davemloft.net>
To: luto@amacapital.net
Cc: ebiederm@xmission.com, security@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Rename nsproxy.pid_ns and fix a related security
 bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1377196394.git.luto@amacapital.net>
References: <cover.1377196394.git.luto@amacapital.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 26 Aug 2013 12:59:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 11:39:14 -0700

>     commit 92f28d973cce45ef5823209aab3138eb45d8b349
>     Author: Eric W. Biederman <ebiederm@xmission.com>
>     Date:   Fri Mar 15 01:03:33 2013 -0700
> 
>         scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.
> 
> Eric fell for my bogus claim that nsproxy->pid_ns was the current'
> process's pid ns.  This isn't true.
> 
> Let's fix the bug and rename pid_ns so that no one gets this wrong again.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Eric please take the time to review these changes, thanks.
