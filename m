Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab3LFRyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:54:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab3LFRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:54:07 -0500
Date: Fri, 06 Dec 2013 12:54:02 -0500 (EST)
Message-Id: <20131206.125402.1834036599966030558.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: klassert@mathematik.tu-chemnitz.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com
Subject: Re: [PATCH net v2 2/2] 3c59x/net: Use dev_is_pci() instead of
 hardcoding
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386311695-22992-1-git-send-email-wangyijing@huawei.com>
References: <1386311695-22992-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 09:54:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Fri, 6 Dec 2013 14:34:55 +0800

> Use PCI standard macro dev_is_pci() instead of hardcoding.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied.
