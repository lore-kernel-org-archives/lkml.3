Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbaCUSNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:13:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34676 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaCUSNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:13:12 -0400
Date: Fri, 21 Mar 2014 14:13:09 -0400 (EDT)
Message-Id: <20140321.141309.1420639327487993718.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, paul.durrant@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next] xen-netback: Follow-up patch for grant
 mapping series
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395343961-4744-2-git-send-email-zoltan.kiss@citrix.com>
References: <1395343961-4744-1-git-send-email-zoltan.kiss@citrix.com>
	<1395343961-4744-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Mar 2014 11:13:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Thu, 20 Mar 2014 19:32:41 +0000

> Ian made some late comments about the grant mapping series, I incorporated the
> outcomes into this patch. Additional comments, refactoring etc.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

I would really prefer that pure non-functional cleanup changes happen
separately from real changes.

Thanks.
