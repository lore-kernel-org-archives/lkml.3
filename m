Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbaCZUeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:34:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46808 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaCZUeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:34:04 -0400
Date: Wed, 26 Mar 2014 16:34:01 -0400 (EDT)
Message-Id: <20140326.163401.1016704703453912598.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, paul.durrant@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next v3 2/3] xen-netback: Non-functional follow-up
 patch for grant mapping series
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395705591-23976-2-git-send-email-zoltan.kiss@citrix.com>
References: <1395705591-23976-1-git-send-email-zoltan.kiss@citrix.com>
	<1395705591-23976-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 13:34:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Mon, 24 Mar 2014 23:59:50 +0000

> Ian made some late comments about the grant mapping series, I incorporated the
> non-functional outcomes into this patch:
> 
> - typo fixes in a comment of xenvif_free(), and add another one there as well
> - typo fix for comment of rx_drain_timeout_msecs
> - remove stale comment before calling xenvif_grant_handle_reset()
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Applied.
