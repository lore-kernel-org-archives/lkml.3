Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3H0RxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:53:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57283 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3H0RxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:53:16 -0400
Date: Tue, 27 Aug 2013 13:53:11 -0400 (EDT)
Message-Id: <20130827.135311.363272748428277447.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 27 Aug 2013 10:53:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 11:39:14 -0700

> Eric fell for my bogus claim that nsproxy->pid_ns was the current'
> process's pid ns.  This isn't true.
> 
> Let's fix the bug and rename pid_ns so that no one gets this wrong again.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Series applied, thanks.
