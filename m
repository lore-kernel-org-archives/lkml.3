Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaEWTPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:15:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54772 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaEWTPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:15:05 -0400
Date: Fri, 23 May 2014 15:15:02 -0400 (EDT)
Message-Id: <20140523.151502.1106354754894891974.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, nm@ti.com
Subject: Re: [PATCH 0/5] ks8851 DT updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
References: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 May 2014 12:15:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Thu, 22 May 2014 14:00:08 -0700

> This set of patches properly documents the micrel ks8851 spi ethernet
> controller, converts to devm_regulator_get_optional() to make error
> paths slightly simpler, and finally adds supports for another
> optional regulator and a reset gpio.

Please do not submit patch sets that you expect different trees to
integrate, this is painful for maintainers to deal with.

Instead, submit the changes separately.  One series for one
maintainer's tree, another for the other maintainer's tree.

