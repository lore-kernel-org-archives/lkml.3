Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469Ab3DIRUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:20:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36422 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762769Ab3DIRUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:20:09 -0400
Date: Tue, 09 Apr 2013 13:20:06 -0400 (EDT)
Message-Id: <20130409.132006.1285366255924272823.davem@davemloft.net>
To: lizefan@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com
Subject: Re: [PATCH 1/2] cls_cgroup: remove task_struct parameter from
 sock_update_classid()
From: David Miller <davem@davemloft.net>
In-Reply-To: <5163AF37.8010605@huawei.com>
References: <5163AF37.8010605@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 09 Apr 2013 10:20:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>
Date: Tue, 9 Apr 2013 14:03:35 +0800

> The callers always pass current to sock_update_classid().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied.
