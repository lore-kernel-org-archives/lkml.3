Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab3DIRUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:20:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36417 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762521Ab3DIRUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:20:03 -0400
Date: Tue, 09 Apr 2013 13:19:56 -0400 (EDT)
Message-Id: <20130409.131956.1617262364252663466.davem@davemloft.net>
To: lizefan@huawei.com
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_memcontrol: remove a redundant statement in
 tcp_destroy_cgroup()
From: David Miller <davem@davemloft.net>
In-Reply-To: <5163AE40.40304@huawei.com>
References: <5163AE40.40304@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 09 Apr 2013 10:19:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>
Date: Tue, 9 Apr 2013 13:59:28 +0800

> We read the value but make no use of it.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied.
