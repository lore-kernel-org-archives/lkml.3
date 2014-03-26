Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaCZBTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:19:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33455 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbaCZBTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:19:25 -0400
Date: Tue, 25 Mar 2014 21:19:23 -0400 (EDT)
Message-Id: <20140325.211923.1366926482436380447.davem@davemloft.net>
To: monamagarwal123@gmail.com
Cc: stephen@networkplumber.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge: Use RCU_INIT_POINTER(x, NULL) in br_vlan.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395601873-12447-1-git-send-email-monamagarwal123@gmail.com>
References: <1395601873-12447-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 18:19:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Monam Agarwal <monamagarwal123@gmail.com>
Date: Mon, 24 Mar 2014 00:41:13 +0530

> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Applied.
