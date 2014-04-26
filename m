Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaDZQwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:52:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaDZQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:52:09 -0400
Date: Sat, 26 Apr 2014 12:52:06 -0400 (EDT)
Message-Id: <20140426.125206.1284988815126862472.davem@davemloft.net>
To: jin.xiao@intel.com
Cc: trivial@kernel.org, ebiederm@xmission.com, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, serge.hallyn@canonical.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com
Subject: Re: [PATCH] cleanup_net: trivial cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398387054-11172-1-git-send-email-jin.xiao@intel.com>
References: <1398387054-11172-1-git-send-email-jin.xiao@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Apr 2014 09:52:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>
Date: Fri, 25 Apr 2014 08:50:54 +0800

> Do not initialize net_kill_list twice.
> list_replace_init() already takes care of initializing net_kill_list.
> We don't need to initialize it with LIST_HEAD() beforehand.
> 
> Signed-off-by: xiao jin <jin.xiao@intel.com>
> Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>

Applied, thank you.
