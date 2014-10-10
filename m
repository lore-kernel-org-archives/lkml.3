Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJJSqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:46:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaJJSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:46:33 -0400
Date: Fri, 10 Oct 2014 14:46:30 -0400 (EDT)
Message-Id: <20141010.144630.1064476304941331059.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: pxa168_eth: PXA168_ETH should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412864142-21468-1-git-send-email-geert@linux-m68k.org>
References: <1412864142-21468-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 11:46:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu,  9 Oct 2014 16:15:42 +0200

> If NO_DMA=y:
...
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thank you.
