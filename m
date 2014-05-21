Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaEUT46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:56:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55419 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUT45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:56:57 -0400
Date: Wed, 21 May 2014 15:56:55 -0400 (EDT)
Message-Id: <20140521.155655.2246792997958517691.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4 V2] atm: idt77252: Remove redundant error check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400495212-9150-1-git-send-email-peter.senna@gmail.com>
References: <1400495212-9150-1-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 May 2014 12:56:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Mon, 19 May 2014 12:26:52 +0200

> Remove double checks, convert printk to pr_warn, and move the call to
> pr_warn to the first check. The simplified version of the coccinelle
> semantic patch that find this issue is as follows:
 ...
> Tested by compilation only.
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied to net-next, thanks.
