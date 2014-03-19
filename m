Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaCSUaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:30:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38772 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaCSUaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:30:11 -0400
Date: Wed, 19 Mar 2014 16:30:09 -0400 (EDT)
Message-Id: <20140319.163009.460997858507816239.davem@davemloft.net>
To: monamagarwal123@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] rcu: Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x, NULL)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395180150-18548-1-git-send-email-monamagarwal123@gmail.com>
References: <1395180150-18548-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Mar 2014 13:30:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Many of your patches, such as this one, all have the same exact
subject line.

This makes it impossible to scan the subject lines and have some
idea what area a commit makes changes.

I would really suggest that you use a subject prefix that references
the driver or subsystem, so for this one:

Subject: [PATCH N/M] infiniband: Use rcu_assign_pointer(x, NULL instead) of RCU_INIT_POINTER(x, NULL)

and likewise for all of your other patches.
