Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaGUD5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 23:57:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52991 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaGUD5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 23:57:13 -0400
Date: Sun, 20 Jul 2014 20:57:11 -0700 (PDT)
Message-Id: <20140720.205711.829460083215756821.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net 0/4 v2] xen-netback: Fixing up xenvif_tx_check_gop
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
References: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 20:57:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Fri, 18 Jul 2014 19:08:01 +0100

> This series fixes a lot of bugs on the error path around this function, which
> were introduced with my grant mapping series in 3.15. They apply to the latest
> net tree, but probably to net-next as well without any modification.
> I'll post an another series which applies to 3.15 stable, as the problem was
> first discovered there. The only difference is that the "queue" variable name is
> replaced to "vif".
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Reported-by: Armin Zentai <armin.zentai@ezit.hu>

Series applied, thanks.
