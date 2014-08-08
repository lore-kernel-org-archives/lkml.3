Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaHHR3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:29:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60359 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaHHR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:29:33 -0400
Date: Fri, 08 Aug 2014 10:29:31 -0700 (PDT)
Message-Id: <20140808.102931.1051613105167978317.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next] xen-netback: Don't deschedule NAPI when
 carrier off
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407494580-19404-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407494580-19404-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Aug 2014 10:29:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Fri, 8 Aug 2014 11:43:00 +0100

> +	if (unlikely(queue->vif->disabled )) {
                                         ^^

Please get rid of that space and resubmit this patch, thank you.
