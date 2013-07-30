Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3G3XQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:16:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43258 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3G3XQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:16:35 -0400
Date: Tue, 30 Jul 2013 16:16:34 -0700 (PDT)
Message-Id: <20130730.161634.1378046909890599017.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] tile: handle 64-bit statistics in tilepro network
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <201307251642.r6PGgHx2002404@farm-0012.internal.tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	<40362053a9f02d56a4f0c07a9982d96203723ec8.1374609948.git.cmetcalf@tilera.com>
	<201307251642.r6PGgHx2002404@farm-0012.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 16:16:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 25 Jul 2013 12:41:15 -0400

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Applied, thanks.

Your PTP patch for the Tile driver doesn't even come close to
applying properly to net-next, please respin it and report if
you want me to apply it.

Thanks.
