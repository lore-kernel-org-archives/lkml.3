Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaDCSWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:22:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46008 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDCSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:22:02 -0400
Date: Thu, 03 Apr 2014 14:23:30 -0400 (EDT)
Message-Id: <20140403.142330.1048193401278908355.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, paul.durrant@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next v3 1/2] xen-netback: Rename map ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com>
References: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 11:22:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 2 Apr 2014 18:04:57 +0100

> Rename identifiers to state explicitly that they refer to map ops.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Applied.
