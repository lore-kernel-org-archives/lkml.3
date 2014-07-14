Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaGNGqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:46:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58357 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaGNGqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:46:16 -0400
Date: Sun, 13 Jul 2014 23:46:14 -0700 (PDT)
Message-Id: <20140713.234614.1536480358445017348.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, joe@perches.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2 0/9] drivers/net: remove unnecessary break after goto
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405188597-2815-1-git-send-email-fabf@skynet.be>
References: <1405188597-2815-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Jul 2014 23:46:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Sat, 12 Jul 2014 20:09:39 +0200

> Small patchset addressing break redundancy on drivers/net branch
> (suggested by Joe Perches). 
> 
> V2: cc to maintainers of each section.

Series applied to net-next, thanks.
