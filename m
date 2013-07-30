Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3G3Wyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:54:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42912 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab3G3Wyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:54:51 -0400
Date: Tue, 30 Jul 2013 15:54:50 -0700 (PDT)
Message-Id: <20130730.155450.370003633888422808.davem@davemloft.net>
To: andi@etezian.org
Cc: dominique.martinet@cea.fr, pebolle@tiscali.nl, lucho@ionkov.net,
        ericvh@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, rminnich@sandia.gov
Subject: Re: [PATCH] 9p: client: remove unused code and any reference to
 "cancelled" function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374742464-10686-1-git-send-email-andi@etezian.org>
References: <20130725061411.GA8579@nautica>
	<1374742464-10686-1-git-send-email-andi@etezian.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 15:54:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Shyti <andi@etezian.org>
Date: Thu, 25 Jul 2013 10:54:24 +0200

> This patch reverts commit
> 
> 80b45261a0b263536b043c5ccfc4ba4fc27c2acc
> 
> which was implementing a 'cancelled' functionality to notify that
> a cancelled request will not be replied.
> 
> This implementation was not used anywhere and therefore removed.
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>

Applied, thanks Andi.
