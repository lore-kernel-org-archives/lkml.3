Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbaCTVFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:05:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51808 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbaCTVFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:05:00 -0400
Date: Thu, 20 Mar 2014 17:04:58 -0400 (EDT)
Message-Id: <20140320.170458.1005538496220925120.davem@davemloft.net>
To: monamagarwal123@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.wai@broadcom.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/9] Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x,NULL)
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1395324808.git.monamagarwal123@gmail.com>
References: <cover.1395324808.git.monamagarwal123@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Mar 2014 14:05:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Monam Agarwal <monamagarwal123@gmail.com>
Date: Thu, 20 Mar 2014 20:07:10 +0530

> This patchset uses following coccinelle script to replace
> rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,NULL)
> 
> @@
> expression E;
> @@
> - rcu_assign_pointer(
> + RCU_INIT_POINTER(
> E, NULL)

None of the networking patches apply to my net-next tree, in fact
nearly all of these case are already using RCU_INIT_POINTER()
properly.
