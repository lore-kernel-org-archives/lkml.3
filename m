Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaJRDoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 23:44:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44318 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaJRDoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 23:44:11 -0400
Date: Fri, 17 Oct 2014 23:43:58 -0400 (EDT)
Message-Id: <20141017.234358.41209953117216295.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v3] hyperv: Add handling of IP header with
 option field in netvsc_set_hash()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413496078-25066-1-git-send-email-haiyangz@microsoft.com>
References: <1413496078-25066-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 20:44:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 16 Oct 2014 14:47:58 -0700

> In case that the IP header has optional field at the end, this patch will
> get the port numbers after that field, and compute the hash. The general
> parser skb_flow_dissect() is used here.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
