Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3GVVv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:51:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35163 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab3GVVv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:51:56 -0400
Date: Mon, 22 Jul 2013 14:51:55 -0700 (PDT)
Message-Id: <20130722.145155.581647564098552323.davem@davemloft.net>
To: jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, ben@decadent.org.uk, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, kbuild-all@01.org
Subject: Re: [PATCH] NET: pch_gbe depends on x86
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374215169-28866-1-git-send-email-jslaby@suse.cz>
References: <51d48037.Zcczkb6ouQ0Nv+4v%fengguang.wu@intel.com>
	<1374215169-28866-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 22 Jul 2013 14:51:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 19 Jul 2013 08:26:09 +0200

> Since 4bb1667255a86360721291fe59991d033bbc2f2a (build some drivers only
> when compile-testing), PTP_1588_CLOCK_PCH depends on (X86 ||
> COMPILE_TEST). But PCH_GBE selects PTP_1588_CLOCK_PCH without
> depending on x86. Fix this by adding the same dependency here.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: <fengguang.wu@intel.com> [intel's build test robot]

Applied, thanks.

Please use lowercase "net: " not uppercase "NET: " in your commit
subject lines.  I fixed it for you this time.

Thank you.
