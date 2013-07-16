Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3GPThB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:37:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39431 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3GPTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:36:59 -0400
Date: Tue, 16 Jul 2013 12:36:58 -0700 (PDT)
Message-Id: <20130716.123658.1660201783834013788.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: tim.gardner@canonical.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        eli@mellanox.com
Subject: Re: [PATCH 3.11-rc1] mlx5 core: Fix __udivdi3 when compiling for
 32 bit arches
From: David Miller <davem@davemloft.net>
In-Reply-To: <51E41AB2.3020905@infradead.org>
References: <1373900205-69711-1-git-send-email-tim.gardner@canonical.com>
	<51E41AB2.3020905@infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Jul 2013 12:36:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 15 Jul 2013 08:52:18 -0700

> On 07/15/13 07:56, Tim Gardner wrote:
>> Cc: Eli Cohen <eli@mellanox.com>
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> 
> I reported this last week and Eli wrote:
> 
> "I have this fixed in my tree and we run the driver on i386. I will check on Sunday why it is not in the patches submitted."
> 
> Anyway, the patch works for me.
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks.
