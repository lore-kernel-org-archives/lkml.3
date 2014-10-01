Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaJATY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:24:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35692 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaJATYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:24:55 -0400
Date: Wed, 01 Oct 2014 15:24:52 -0400 (EDT)
Message-Id: <20141001.152452.1973501659924138094.davem@davemloft.net>
To: thierry.reding@gmail.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Fix build warning for !PM_SLEEP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412164740-32452-1-git-send-email-thierry.reding@gmail.com>
References: <1412164740-32452-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 12:24:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Wed,  1 Oct 2014 13:59:00 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The dsa_switch_suspend() and dsa_switch_resume() functions are only used
> when PM_SLEEP is enabled, so they need #ifdef CONFIG_PM_SLEEP protection
> to avoid a compiler warning.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied.

Please, in the future, explicitly indicate what tree your changes
are against.  Through trial and error I figured out that this could
only apply to net-next, but that's not a good use of my time.

Thanks.
