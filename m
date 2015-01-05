Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbbAEEsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 23:48:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46839 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbbAEEsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 23:48:41 -0500
Date: Sun, 04 Jan 2015 23:48:38 -0500 (EST)
Message-Id: <20150104.234838.596521437683943688.davem@davemloft.net>
To: me@mortis.eu
Cc: linux-kernel@vger.kernel.org, jitendra.kalsaria@qlogic.com,
        ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix an infinite retry-loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420394696-20099-1-git-send-email-me@mortis.eu>
References: <1420394696-20099-1-git-send-email-me@mortis.eu>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 04 Jan 2015 20:48:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giel van Schijndel <me@mortis.eu>
Date: Sun,  4 Jan 2015 19:04:55 +0100

> This was clearly intended as a retry-10-times loop, but due to the
> absence of code incrementing the loop-counter it was practically a
> retry-forever loop.
> 
> Rewritten it as a for-loop as well to make the loop-counter increment
> (as well as its potential absence) easier to spot.

Besides missing the Signoff, you also did not write your
Subject line properly.

You should format it as:

Subject: [PATCH] ${SUBSYSTEM_PREFIX}: Description.

Where ${SUBSYSTEM_PREFIX} should be "qlogic: " in this
case.

Do not fix this by replying to this email, instead make a new
fresh patch posting to the lists.

This also applied to all of your other submissions, they all
need to be fixed up in this manner at the very least.
