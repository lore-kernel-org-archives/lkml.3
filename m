Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaFWANI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:13:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49529 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaFWANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:13:07 -0400
Date: Sun, 22 Jun 2014 17:13:05 -0700 (PDT)
Message-Id: <20140622.171305.2202259755276449247.davem@davemloft.net>
To: linux@rainbow-software.org
Cc: grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tulip: Poll link status more frequently for Comet chips
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403431272-2569-1-git-send-email-linux@rainbow-software.org>
References: <1403431272-2569-1-git-send-email-linux@rainbow-software.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 22 Jun 2014 17:13:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>
Date: Sun, 22 Jun 2014 12:01:12 +0200

> It now takes up to 60 seconds to detect cable (un)plug on ADMtek Comet chips.
> That's too slow and might cause people to think that it doesn't work at all.
> 
> Poll link status every 2 seconds instead of 60 for ADMtek Comet chips.
> That should be fast enough while not stressing the system too much.
> 
> Tested with ADMtek AN983B.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Looks good, and this is consistent with tulip_media_timer().

Applied, thanks.
