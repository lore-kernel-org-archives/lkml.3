Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3CQS2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:28:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3CQS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:28:03 -0400
Date: Sun, 17 Mar 2013 14:28:01 -0400 (EDT)
Message-Id: <20130317.142801.1476717176435086403.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, samuel@sortiz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: irda: use resource_size() in au1k_ir.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363503826-24166-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363503826-24166-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 11:28:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Sun, 17 Mar 2013 09:03:46 +0200

> This uses the resource_size() function instead of explicit computation.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied.
