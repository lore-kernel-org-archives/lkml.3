Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3GYG7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:59:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3GYG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:59:47 -0400
Date: Wed, 24 Jul 2013 23:59:46 -0700 (PDT)
Message-Id: <20130724.235946.2251164173355173515.davem@davemloft.net>
To: wsa@the-dreams.de
Cc: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/27] drivers/net/ethernet/stmicro/stmmac: don't check
 resource with devm_ioremap_resource
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374602524-3398-13-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	<1374602524-3398-13-git-send-email-wsa@the-dreams.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 23:59:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>
Date: Tue, 23 Jul 2013 20:01:45 +0200

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied, thanks.
