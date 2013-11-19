Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3KSUxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:53:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58011 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3KSUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:53:38 -0500
Date: Tue, 19 Nov 2013 15:53:35 -0500 (EST)
Message-Id: <20131119.155335.1285719229777563134.davem@davemloft.net>
To: ying.xue@windriver.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: idt77252: fix dev refcnt leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384855767-21446-1-git-send-email-ying.xue@windriver.com>
References: <1384855767-21446-1-git-send-email-ying.xue@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Nov 2013 12:53:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>
Date: Tue, 19 Nov 2013 18:09:27 +0800

> init_card() calls dev_get_by_name() to get a network deceive. But it
> doesn't decrease network device reference count after the device is
> used.
> 
> Signed-off-by: Ying Xue <ying.xue@windriver.com>

Applied and queued up for -stable, thanks.
