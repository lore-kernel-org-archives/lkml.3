Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3FQW6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:58:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40049 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3FQW6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:58:30 -0400
Date: Mon, 17 Jun 2013 15:58:29 -0700 (PDT)
Message-Id: <20130617.155829.1565606302338817921.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] Fix the VLAN_TAG_PRESENT in netvsc_recv_callback()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371508609-22780-1-git-send-email-haiyangz@microsoft.com>
References: <1371508609-22780-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 17 Jun 2013 15:36:49 -0700

> We should call __vlan_hwaccel_put_tag() only if the packet
> comes from vlan, otherwise VLAN_TAG_PRESENT will always be
> added.
> 
> Reported-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
