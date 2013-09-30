Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3I3TJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:09:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3I3TJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:09:14 -0400
Date: Mon, 30 Sep 2013 15:09:12 -0400 (EDT)
Message-Id: <20130930.150912.46415312099350726.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: t.sailer@alumni.ethz.ch, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hamradio: baycom: remove deprecated IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380133065-13712-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1380133065-13712-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 30 Sep 2013 12:09:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Wed, 25 Sep 2013 20:17:45 +0200

> This patch proposes to remove the IRQF_DISABLED flag
> from drivers/net/hamradio/baycom_*
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied to net-next, thanks.
