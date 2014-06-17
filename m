Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaFQEe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:34:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51306 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaFQEe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:34:28 -0400
Date: Mon, 16 Jun 2014 21:34:27 -0700 (PDT)
Message-Id: <20140616.213427.126923556571858602.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, tklauser@distanz.ch
Subject: Re: [PATCH v2] net: tile: fix unused variable warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <201406161816.s5GIGptF028053@farm-0039.internal.tilera.com>
References: <201406161816.s5GIGptF028053@farm-0039.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Jun 2014 21:34:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 16 Jun 2014 13:14:05 -0400

> 'i' is unused in tile_net_dev_init() after commit d581ebf5a1f
> ("net: tile: Use helpers from linux/etherdevice.h to check/set MAC").
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> v2: includes previous commit's summary line as suggested by Sergei Shtylyov.

Applied, thanks.
