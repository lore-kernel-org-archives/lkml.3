Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaHQBtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 21:49:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57319 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaHQBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 21:49:50 -0400
Date: Sat, 16 Aug 2014 18:50:02 -0700 (PDT)
Message-Id: <20140816.185002.1499212551659532229.davem@davemloft.net>
To: bernat.ada@gmail.com
Cc: j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] rcu: Replace rcu_dereference() with
 rcu_access_pointer()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140816193442.GA6471@ada>
References: <20140816193442.GA6471@ada>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Aug 2014 18:49:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do not use the same exact Subject line for all of these patches.

Otherwise nobody reading the shortlog can tell what might be different
from one patch to another.

Instead, use a subsystem prefix for the place where you're making
your change.  For example, for the two networking patches you could
replace "rcu: " with "bonding: " and "cnic: ".

Thanks.
