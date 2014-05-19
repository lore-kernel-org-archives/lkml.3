Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaESBOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:14:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44286 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaESBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:14:13 -0400
Date: Sun, 18 May 2014 21:14:12 -0400 (EDT)
Message-Id: <20140518.211412.1525385415713413915.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] atm: idt77252: Remove redundant error check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400350980-30455-3-git-send-email-peter.senna@gmail.com>
References: <1400350980-30455-3-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 18:14:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Sat, 17 May 2014 20:22:59 +0200

> Remove double checks, and move the call to printk to the
> first check. Also adds KERN_WARNING to printk. The simplified version
> of the coccinelle semantic patch that fixes this issue is as follows:

The appropriate thing to use is pr_warning() rather than add
KERN_WARNING.
