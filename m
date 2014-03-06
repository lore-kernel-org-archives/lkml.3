Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaCFBsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:48:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51798 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaCFBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:48:16 -0500
Date: Wed, 05 Mar 2014 20:48:14 -0500 (EST)
Message-Id: <20140305.204814.1986539104864076428.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2] hyperv: Move state setting for link query
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393971066-6491-1-git-send-email-haiyangz@microsoft.com>
References: <1393971066-6491-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Mar 2014 17:48:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue,  4 Mar 2014 14:11:06 -0800

> It moves the state setting for query into rndis_filter_receive_response().
> All callbacks including query-complete and status-callback are synchronized
> by channel->inbound_lock. This prevents pentential race between them.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied.
