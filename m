Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaJSQpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 12:45:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaJSQpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 12:45:44 -0400
Date: Sun, 19 Oct 2014 12:45:42 -0400 (EDT)
Message-Id: <20141019.124542.141206969262552652.davem@davemloft.net>
To: dg@emlix.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: s6gmac: remove driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413672545-8535-1-git-send-email-dg@emlix.com>
References: <1413672385-8492-1-git-send-email-dg@emlix.com>
	<1413672545-8535-1-git-send-email-dg@emlix.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 09:45:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>
Date: Sun, 19 Oct 2014 00:49:05 +0200

> The s6000 Xtensa support is removed from the kernel. There are no
> other chips using this driver.

That's not what I see in Linus's current tree:

[davem@localhost linux]$ git grep XTENSA_VARIANT_S6000
arch/xtensa/Kconfig:config XTENSA_VARIANT_S6000
arch/xtensa/Kconfig:	default "s6000"				if XTENSA_VARIANT_S6000
