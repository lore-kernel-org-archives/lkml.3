Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3FAAXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:23:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43279 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab3FAAXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:23:37 -0400
Date: Fri, 31 May 2013 17:23:36 -0700 (PDT)
Message-Id: <20130531.172336.1848458955586893446.davem@davemloft.net>
To: maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sr@denx.de, florian@openwrt.org,
        emilio@elopez.com.ar, kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCHv4 0/6] ARM: sunxi: Add support for A10 Ethernet
 controller
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369921765-3367-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1369921765-3367-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Thu, 30 May 2013 15:49:19 +0200

> The Allwinner A10 SoC has an ethernet controller that seem to be specific to
> Allwinner. This IP has no public documentation, so exact
> details are quite sparse, and this code come from refactored Allwinner
> code.
> 
> The rework to use NAPI is taking more time than expected, I'm still working
> on it, but it could probably be sent as a follow-up patch.

Looks good.

All applied to net-next, thanks.
