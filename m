Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaLSECa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 23:02:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51886 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaLSEC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 23:02:29 -0500
Date: Thu, 18 Dec 2014 23:02:26 -0500 (EST)
Message-Id: <20141218.230226.442587581329380880.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net V2] net: drop the packet when fails to do software
 segmentation or header check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418958553-9962-1-git-send-email-jasowang@redhat.com>
References: <1418958553-9962-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 20:02:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 19 Dec 2014 11:09:13 +0800

> Commit cecda693a969816bac5e470e1d9c9c0ef5567bca ("net: keep original skb
> which only needs header checking during software GSO") keeps the original
> skb for packets that only needs header check, but it doesn't drop the
> packet if software segmentation or header check were failed.
> 
> Fixes cecda693a9 ("net: keep original skb which only needs header checking
> during software GSO")
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable, thanks Jason.
