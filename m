Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3IQERI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:17:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46541 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3IQERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:17:05 -0400
Date: Tue, 17 Sep 2013 00:17:00 -0400 (EDT)
Message-Id: <20130917.001700.583366017350321523.davem@davemloft.net>
To: Vineet.Gupta1@synopsys.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        Alexey.Brodkin@synopsys.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ethernet/arc/arc_emac: Fix huge delays in large file
 copies
From: David Miller <davem@davemloft.net>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307514C1F4@IN01WEMBXA.internal.synopsys.com>
References: <52369A94.5060900@synopsys.com>
	<20130916194012.GA23656@kroah.com>
	<C2D7FE5348E1B147BCA15975FBA2307514C1F4@IN01WEMBXA.internal.synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 16 Sep 2013 21:17:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Date: Tue, 17 Sep 2013 04:07:23 +0000

> Can you please do the needful for stable 3.11 backport of this patch.

Queued up for -stable.
