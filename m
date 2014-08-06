Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaHFVHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:07:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43757 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaHFVHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:07:23 -0400
Date: Wed, 06 Aug 2014 14:07:22 -0700 (PDT)
Message-Id: <20140806.140722.489043833669403528.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, david.vrabel@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-netback: Change disable flag from bool to a bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407348973-2433-5-git-send-email-zoltan.kiss@citrix.com>
References: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>
	<1407348973-2433-5-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 14:07:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 6 Aug 2014 19:16:13 +0100

> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Neither this nor your "Small fixes around internal queue purging"
patch apply cleanly to my current tree.  I have no idea what tree you
are sending these patches against.
