Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab3DPUmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:42:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49863 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965099Ab3DPUmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:42:18 -0400
Date: Tue, 16 Apr 2013 16:42:15 -0400 (EDT)
Message-Id: <20130416.164215.1481542365151784733.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] neighbour: Convert NEIGH_PRINTK to neigh_dbg
From: David Miller <davem@davemloft.net>
In-Reply-To: <6d196be46acd99bd65d0f0d5abb842b8b0bf0d04.1366074978.git.joe@perches.com>
References: <6d196be46acd99bd65d0f0d5abb842b8b0bf0d04.1366074978.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Apr 2013 13:42:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 15 Apr 2013 18:17:19 -0700

> Update debugging messages to a more current style.
> 
> Emit these debugging messages at KERN_DEBUG instead
> of KERN_DEFAULT.
> 
> Add and use neigh_dbg(level, fmt, ...) macro
> Add dynamic_debug capability via pr_debug
> Convert embedded function names to "%s: ", __func__
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
