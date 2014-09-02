Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaIBDg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:36:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46868 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaIBDgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:36:55 -0400
Date: Mon, 01 Sep 2014 20:36:54 -0700 (PDT)
Message-Id: <20140901.203654.169816832338808793.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: isubramanian@apm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: NET_XGENE should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409329301-6747-1-git-send-email-geert@linux-m68k.org>
References: <1409329301-6747-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Sep 2014 20:36:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 29 Aug 2014 18:21:41 +0200

> If NO_DMA=y:
 ...
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
