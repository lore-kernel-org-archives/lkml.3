Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3CQQBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:01:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45799 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3CQQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:01:42 -0400
Date: Sun, 17 Mar 2013 12:01:40 -0400 (EDT)
Message-Id: <20130317.120140.1114222806134803996.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        grundler@parisc-linux.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ethernet/tulip: DE4x5 needs VIRT_TO_BUS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363298204-8014-5-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
	<1363298204-8014-5-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 09:01:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 14 Mar 2013 22:56:42 +0100

> The automated ARM build tests have shown that the tulip de4x5 driver
> uses the old-style virt_to_bus() interface on some architectures.
> 
> Alpha, Sparc and PowerPC did not hit this problem, because they
> use a different code path, and most other architectures actually
> do provide VIRT_TO_BUS.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
