Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaHVT1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:27:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53456 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaHVT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:27:19 -0400
Date: Fri, 22 Aug 2014 12:27:15 -0700 (PDT)
Message-Id: <20140822.122715.2235186075962103027.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v3] hyperv: Increase the buffer length for
 netvsc_channel_cb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408130299-50848-1-git-send-email-haiyangz@microsoft.com>
References: <1408130299-50848-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 12:27:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 15 Aug 2014 19:18:19 +0000

> When the buffer is too small for a packet from VMBus, a bigger buffer will be
> allocated in netvsc_channel_cb() and retry reading the packet from VMBus.
> Increasing this buffer size will reduce the retry overhead.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>

Applied, thanks.
