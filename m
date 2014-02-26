Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaBZVIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:08:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41034 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaBZVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:08:31 -0500
Date: Wed, 26 Feb 2014 16:08:26 -0500 (EST)
Message-Id: <20140226.160826.1051230037229837227.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 11/16] atm: firestream: fix interruptible_sleep_on race
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393412516-3762435-12-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
	<1393412516-3762435-12-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 13:08:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Feb 2014 12:01:51 +0100

> interruptible_sleep_on is racy and going away. This replaces the one use
> in the firestream driver with the appropriate wait_event_interruptible
> variant.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>

Applied.
