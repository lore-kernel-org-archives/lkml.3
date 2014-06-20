Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaFTE0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:26:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46467 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaFTE0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:26:42 -0400
Date: Thu, 19 Jun 2014 21:26:40 -0700 (PDT)
Message-Id: <20140619.212640.604406862144791409.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net/irda/kingsun-sir.c: remove null test
 before kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403032970-6471-1-git-send-email-fabf@skynet.be>
References: <1403032970-6471-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Jun 2014 21:26:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 17 Jun 2014 21:22:50 +0200

> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
> 
> Cc: Samuel Ortiz <samuel@sortiz.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
