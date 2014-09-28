Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaI1UoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:44:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47358 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaI1UoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:44:22 -0400
Date: Sun, 28 Sep 2014 16:44:21 -0400 (EDT)
Message-Id: <20140928.164421.1247481867383564525.davem@davemloft.net>
To: m.grzeschik@pengutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 0/5] ARCNET: add support for EAE multi interfac card
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411566113-15583-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1411566113-15583-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Sep 2014 13:44:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Wed, 24 Sep 2014 15:41:48 +0200

> this series adds support for the PLX Bridge based multi interface
> pci cards and adds support to change device address on com200xx chips
> during runtime.
> 
> This series is based on v3.17-rc6.

Series applied to net-next, thanks.
