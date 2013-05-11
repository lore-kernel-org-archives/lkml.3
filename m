Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3EKX3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 19:29:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60319 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3EKX32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 19:29:28 -0400
Date: Sat, 11 May 2013 16:29:27 -0700 (PDT)
Message-Id: <20130511.162927.1183636865062729244.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 08/12] net/ethernet: MACB should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368133494-22198-8-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
	<1368133494-22198-8-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu,  9 May 2013 23:04:50 +0200

> If NO_DMA=y:
 ...
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
