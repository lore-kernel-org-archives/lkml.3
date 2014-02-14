Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaBNFhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 00:37:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53194 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaBNFhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 00:37:06 -0500
Date: Fri, 14 Feb 2014 00:37:04 -0500 (EST)
Message-Id: <20140214.003704.2200785743998021561.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net,v3] hyperv: Fix the carrier status setting
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392252867-21146-1-git-send-email-haiyangz@microsoft.com>
References: <1392252867-21146-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 21:37:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 12 Feb 2014 16:54:27 -0800

> Without this patch, the "cat /sys/class/net/ethN/operstate" shows
> "unknown", and "ethtool ethN" shows "Link detected: yes", when VM
> boots up with or without vNIC connected.
> 
> This patch fixed the problem.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied and queued up for -stable, thanks.
