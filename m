Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaFTEWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:22:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaFTEV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:21:58 -0400
Date: Thu, 19 Jun 2014 21:21:55 -0700 (PDT)
Message-Id: <20140619.212155.1427312394524206357.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Jun 2014 21:21:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 19 Jun 2014 18:34:36 -0700

> The RNDIS_STATUS_NETWORK_CHANGE event is received after the Hyper-V host
> sleep or hibernation. We refresh network at this time.
> MS-TFS: 135162
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
