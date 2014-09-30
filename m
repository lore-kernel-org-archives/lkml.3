Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaI3FV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:21:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39097 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaI3FV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:21:57 -0400
Date: Tue, 30 Sep 2014 01:21:55 -0400 (EDT)
Message-Id: <20140930.012155.1518822116021687917.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH net 1/1 V2] hyperv: Fix a bug in netvsc_start_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411967803-29233-1-git-send-email-kys@microsoft.com>
References: <1411967803-29233-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 22:21:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sun, 28 Sep 2014 22:16:43 -0700

> After the packet is successfully sent, we should not touch the skb 
> as it may have been freed. This patch is based on the work done by 
> Long Li <longli@microsoft.com>.
> 
> In this version of the patch I have fixed issues pointed out by David.
> David, please queue this up for stable.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Tested-by: Long Li <longli@microsoft.com>

Applied and queued up for -stable.
