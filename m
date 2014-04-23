Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaDWStM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:49:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50756 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbaDWStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:49:09 -0400
Date: Wed, 23 Apr 2014 14:49:07 -0400 (EDT)
Message-Id: <20140423.144907.2086744325555588840.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2,1/2] hyperv: Remove recv_pkt_list and lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398117284-5236-1-git-send-email-haiyangz@microsoft.com>
References: <1398117284-5236-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 11:49:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 21 Apr 2014 14:54:43 -0700

> Removed recv_pkt_list and lock, and updated related code, so that
> the locking overhead is reduced especially when multiple channels
> are in use.
> 
> The recv_pkt_list isn't actually necessary because the packets are
> processed sequentially in each channel. It has been replaced by a
> local variable, and the related lock for this list is also removed.
> The is_data_pkt field is not used in receive path, so its assignment
> is cleaned up.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
