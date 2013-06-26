Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3FZWq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:46:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48430 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3FZWq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:46:26 -0400
Date: Wed, 26 Jun 2013 15:46:26 -0700 (PDT)
Message-Id: <20130626.154626.1312386779386420575.davem@davemloft.net>
To: lizefan@huawei.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] dlci: acquire rtnl_lock before calling
 __dev_get_by_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <51CA9872.5050700@huawei.com>
References: <51CA9872.5050700@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>
Date: Wed, 26 Jun 2013 15:29:54 +0800

> Otherwise the net device returned can be freed at anytime.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied and queued up for -stable.
