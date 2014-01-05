Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750831AbaAEBcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 20:32:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44807 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaAEBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 20:32:50 -0500
Date: Sat, 04 Jan 2014 20:32:49 -0500 (EST)
Message-Id: <20140104.203249.1100084640435359350.davem@davemloft.net>
To: allen.pais@oracle.com
Cc: bigeasy@linutronix.de, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc64: convert spinlock_t to raw_spinlock_t in
 mmu_context_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <52AEDCFD.9020402@oracle.com>
References: <1387166853-10782-3-git-send-email-allen.pais@oracle.com>
	<52AED5BB.1060002@linutronix.de>
	<52AEDCFD.9020402@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 04 Jan 2014 17:32:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>
Date: Mon, 16 Dec 2013 16:29:09 +0530

> I did not think it'd be nice to put the call trace in the commit message.
> But if needed I can re-send them.

The more information you provide in a commit message, the better.

Please add those traces to the commit messages, and then you can add
my:

Acked-by: David S. Miller <davem@davemloft.net>
