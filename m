Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaDVT5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:57:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaDVT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:57:08 -0400
Date: Tue, 22 Apr 2014 15:55:35 -0400 (EDT)
Message-Id: <20140422.155535.567731041058340048.davem@davemloft.net>
To: max.schwarz@online.de
Cc: Alexey.Brodkin@synopsys.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de
Subject: Re: [PATCH] arc_emac: write initial MAC address from devicetree to
 hw
From: David Miller <davem@davemloft.net>
In-Reply-To: <1664530.jeK9vBIgft@typ>
References: <1664530.jeK9vBIgft@typ>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Apr 2014 12:57:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Schwarz <max.schwarz@online.de>
Date: Fri, 18 Apr 2014 02:17:32 +0200

> The MAC address retrieved from dt was not actually written to the
> hardware. This meant proper communication was only possible after
> changing the MAC address.
> 
> Fix that by always writing the mac address during probing.
> 
> Signed-off-by: Max Schwarz <max.schwarz@online.de>

Applied, thank you.
