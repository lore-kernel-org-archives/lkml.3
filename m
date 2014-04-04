Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaDDOsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:48:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52183 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaDDOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:48:38 -0400
Date: Fri, 04 Apr 2014 10:50:13 -0400 (EDT)
Message-Id: <20140404.105013.1941651716819314222.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, trivial@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netback: Trivial format string fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396622724-26090-1-git-send-email-zoltan.kiss@citrix.com>
References: <1396622724-26090-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 07:48:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Fri, 4 Apr 2014 15:45:24 +0100

> There is a "%" after pending_idx instead of ":".
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Applied, thanks.
