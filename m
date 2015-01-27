Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbbA0IKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:10:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48294 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbbA0IKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:10:30 -0500
Date: Tue, 27 Jan 2015 00:10:29 -0800 (PST)
Message-Id: <20150127.001029.277347255719163174.davem@davemloft.net>
To: der.herr@hofr.at
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: hyperv: else branch not necessary
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422209317-18975-1-git-send-email-der.herr@hofr.at>
References: <1422209317-18975-1-git-send-email-der.herr@hofr.at>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Jan 2015 00:10:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Mc Guire <der.herr@hofr.at>
Date: Sun, 25 Jan 2015 19:08:37 +0100

> As the if completes with a unconditional goto the else branch
> is not needed here.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> v2: added missing subsystem string in subject line - patch unchanged

The feedback you were given was completely bogus.

Saying "net: " in addition to "hyperv: " is unnecessary, redundant,
and something you should not do.

Just plain "hyperv: " is complete and unambiguous enough to stand
upon itself.

Nobody says "net: ixgbe: " for Intel ethernet driver changes.  That's
just stupid.
