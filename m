Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaHVT1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:27:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53501 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaHVT1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:27:52 -0400
Date: Fri, 22 Aug 2014 12:27:51 -0700 (PDT)
Message-Id: <20140822.122751.953073827713209046.davem@davemloft.net>
To: bernat.ada@gmail.com
Cc: mchan@broadcom.com, eddie.wai@broadcom.com, joe@perches.com,
        mingo@kernel.org, peterz@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] cnic: Replace rcu_dereference() with
 rcu_access_pointer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140817101149.GA3692@ada>
References: <20140817101149.GA3692@ada>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:27:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Date: Sun, 17 Aug 2014 13:12:09 +0300

> The "rcu_dereference()" calls are used directly in conditions.
> Since their return values are never dereferenced it is recommended to use
> "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes the replacements.
 ...
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>

Applied.
