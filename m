Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3CQQBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:01:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab3CQQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:01:47 -0400
Date: Sun, 17 Mar 2013 12:01:46 -0400 (EDT)
Message-Id: <20130317.120146.1958709702875370639.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363298204-8014-4-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
	<1363298204-8014-4-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 09:01:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 14 Mar 2013 22:56:41 +0100

> Disabling CONFIG_VIRT_TO_BUS on ARM showed that the hisax netjet
> driver depends on this deprecated functionality but is not
> marked so in Kconfig.
> 
> Rather than adding ARM to the already long list of architectures
> that this driver is broken on, this patch adds 'depends on
> VIRT_TO_BUS' and removes the dependency on !SPARC, which is
> also implied by that.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
