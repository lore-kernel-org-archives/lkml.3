Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaDZQxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:53:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaDZQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:53:04 -0400
Date: Sat, 26 Apr 2014 12:53:02 -0400 (EDT)
Message-Id: <20140426.125302.2231088219056320790.davem@davemloft.net>
To: jin.xiao@intel.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, trivial@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com
Subject: Re: [PATCH] inetpeer_gc_worker: trivial cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398387209-12322-1-git-send-email-jin.xiao@intel.com>
References: <1398387209-12322-1-git-send-email-jin.xiao@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Apr 2014 09:53:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>
Date: Fri, 25 Apr 2014 08:53:29 +0800

> Do not initialize list twice.
> list_replace_init() already takes care of initializing list.
> We don't need to initialize it with LIST_HEAD() beforehand.
> 
> Signed-off-by: xiao jin <jin.xiao@intel.com>
> Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>

Also applied, thank you.
