Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaLaSME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 13:12:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44618 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaLaSMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 13:12:02 -0500
Date: Wed, 31 Dec 2014 13:11:59 -0500 (EST)
Message-Id: <20141231.131159.1962969227546395849.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, jon.maloy@ericsson.com,
        allan.stephens@windriver.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH 1/1 net-next] tipc: replace 0 by NULL for pointers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419505550-17336-1-git-send-email-fabf@skynet.be>
References: <1419505550-17336-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Dec 2014 10:12:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Thu, 25 Dec 2014 12:05:50 +0100

> Fix sparse warning:
> net/tipc/link.c:1924:40: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.
