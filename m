Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161373Ab3DEEr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:47:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53445 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161057Ab3DEEr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:47:56 -0400
Date: Fri, 05 Apr 2013 00:47:54 -0400 (EDT)
Message-Id: <20130405.004754.281478419999797757.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: svenjoac@gmx.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dingtianhong@huawei.com, edumazet@google.com, luto@amacapital.net,
        ksrot@redhat.com, netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH 3/2] scm: Stop passing struct cred
From: David Miller <davem@davemloft.net>
In-Reply-To: <87li8zezzj.fsf_-_@xmission.com>
References: <87li8zhwkw.fsf_-_@xmission.com>
	<87d2ubhwiw.fsf_-_@xmission.com>
	<87li8zezzj.fsf_-_@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 04 Apr 2013 21:47:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Apr 2013 20:28:16 -0700

> 
> Now that uids and gids are completely encapsulated in kuid_t
> and kgid_t we no longer need to pass struct cred which allowed
> us to test both the uid and the user namespace for equality.
> 
> Passing struct cred potentially allows us to pass the entire group
> list as BSD does but I don't believe the cost of cache line misses
> justifies retaining code for a future potential application.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

I'll apply this to net-next once #1 and #2 propagate there.

Thanks!
