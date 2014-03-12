Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaCLT34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:29:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40524 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaCLT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:29:53 -0400
Date: Wed, 12 Mar 2014 15:29:51 -0400 (EDT)
Message-Id: <20140312.152951.1951796893968999628.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/9] ixgbe: Convert uses of __constant_<foo>
 to <foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <a8b7fce92d51c6c97e1450bc291b0815325935d0.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	<a8b7fce92d51c6c97e1450bc291b0815325935d0.1394644825.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:29:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 12 Mar 2014 10:22:34 -0700

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Will let the Intel folks pick this up.

