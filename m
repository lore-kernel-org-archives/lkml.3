Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaJFBLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 21:11:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56442 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJFBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 21:11:31 -0400
Date: Sun, 05 Oct 2014 21:11:29 -0400 (EDT)
Message-Id: <20141005.211129.632749242463744635.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412530971-29897-1-git-send-email-kys@microsoft.com>
References: <1412530971-29897-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Oct 2014 18:11:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sun,  5 Oct 2014 10:42:51 -0700

> After the packet is successfully sent, we should not touch the packet 
> as it may have been freed. This patch is based on the work done by
> Long Li <longli@microsoft.com>.
> 
> David, please queue this up for stable.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Applied and queued up for -stable.
