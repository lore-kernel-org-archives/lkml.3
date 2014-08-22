Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaHVT2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:28:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53511 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaHVT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:28:02 -0400
Date: Fri, 22 Aug 2014 12:28:01 -0700 (PDT)
Message-Id: <20140822.122801.607834249912014517.davem@davemloft.net>
To: bernat.ada@gmail.com
Cc: j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] bonding: Replace rcu_dereference() with
 rcu_access_pointer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140817102145.GA3854@ada>
References: <20140817102145.GA3854@ada>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:28:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Date: Sun, 17 Aug 2014 13:21:45 +0300

> This "rcu_dereference()" call is used directly in a condition.
> Since its return value is never dereferenced it is recommended to use
> "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes this replacement.
 ...
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>

Applied.
