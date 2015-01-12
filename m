Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbbALR5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:57:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51508 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbALR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:57:04 -0500
Date: Mon, 12 Jan 2015 12:56:57 -0500 (EST)
Message-Id: <20150112.125657.1106579867206771114.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, perex@perex.cz,
        tiwai@suse.de, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] net: atarilance: Remove obsolete IRQ_TYPE_PRIO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421052021-12560-2-git-send-email-geert@linux-m68k.org>
References: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
	<1421052021-12560-2-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 09:57:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 12 Jan 2015 09:40:17 +0100

> IRQ_TYPE_PRIO is no longer used by the Atari platform interrupt code
> since commit 734085651c9b80aa ("[PATCH] m68k: convert atari irq code")
> in v2.6.18-rc1, so drop it.
> 
> Note that its value has been reused for a different purpose
> (IRQ_TYPE_EDGE_FALLING) since commit 6a6de9ef5850d063 ("[PATCH] genirq:
> core") in v2.6.18-rc1.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: David S. Miller <davem@davemloft.net>
