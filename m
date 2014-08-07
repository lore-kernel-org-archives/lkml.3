Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaHGXE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:04:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53614 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaHGXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:04:25 -0400
Date: Thu, 07 Aug 2014 16:04:24 -0700 (PDT)
Message-Id: <20140807.160424.419426873249476082.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, david.vrabel@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next v2] xen-netback: Fix vif->disable handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407415118-16365-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407415118-16365-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 16:04:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Thu, 7 Aug 2014 13:38:38 +0100

> In the patch called "xen-netback: Turn off the carrier if the guest is not able
> to receive" new branches were introduced to this if statement, risking that a
> queue with non-zero id can reenable the disabled interface.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> ---
> v2: fix a code style error in this "if" as well

Applied.
