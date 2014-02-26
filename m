Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaBZVI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:08:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41047 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBZVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:08:54 -0500
Date: Wed, 26 Feb 2014 16:08:52 -0500 (EST)
Message-Id: <20140226.160852.1312618438946802150.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH 15/16] isdn: fix multiple sleep_on races
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393412516-3762435-16-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<1393412516-3762435-16-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 13:08:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Feb 2014 12:01:55 +0100

> The isdn core code uses a couple of wait queues with
> interruptible_sleep_on, which is racy and about to get
> removed from the kernel. Fortunately, we know for each case
> what we are waiting for, so they can all be converted to
> the better wait_event_interruptible interface.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
