Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaC0T3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:29:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbaC0T3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:29:04 -0400
Date: Thu, 27 Mar 2014 15:29:00 -0400 (EDT)
Message-Id: <20140327.152900.610693492229362700.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: jpr@f6fbb.org, kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] yam: replace del_timer by del_timer_sync
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395869625-15209-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
	<1395869625-15209-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Mar 2014 12:29:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Wed, 26 Mar 2014 22:33:45 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use del_timer_sync to ensure that the timer is stopped on all CPUs before
> the driver exists.
> 
> This change was suggested by Thomas Gleixner
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
