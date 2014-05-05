Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaEERQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:16:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59632 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaEERQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:16:49 -0400
Date: Mon, 05 May 2014 13:16:47 -0400 (EDT)
Message-Id: <20140505.131647.76491395366261755.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: vbridgers2013@gmail.com, netdev@vger.kernel.org,
        nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Altera TSE: ALTERA_TSE should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399004962-19530-1-git-send-email-geert@linux-m68k.org>
References: <1399004962-19530-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 10:16:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri,  2 May 2014 06:29:21 +0200

> If NO_DMA=y:
 ...
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks a lot Geert.
