Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3HNABJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:01:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45620 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3HNABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:01:08 -0400
Date: Tue, 13 Aug 2013 17:01:05 -0700 (PDT)
Message-Id: <20130813.170105.601411361110484740.davem@davemloft.net>
To: Alexey.Brodkin@synopsys.com
Cc: netdev@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        Mischa.Jonker@synopsys.com, arnd@arndb.de, grant.likely@linaro.org,
        rob.herring@calxeda.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet/arc/arc_emac - fix NAPI "work > weight"
 warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376399076-9320-1-git-send-email-abrodkin@synopsys.com>
References: <1376399076-9320-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 13 Aug 2013 17:01:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Date: Tue, 13 Aug 2013 17:04:36 +0400

> Initially I improperly set a boundary for maximum number of input
> packets to process on NAPI poll ("work") so it might be more than
> expected amount ("weight").
> 
> This was really harmless but seeing WARN_ON_ONCE on every device boot is
> not nice. So trivial fix ("<" instead of "<=") is here.
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Applied, thanks.
