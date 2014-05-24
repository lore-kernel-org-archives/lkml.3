Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaEXSED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 14:04:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37708 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXSEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 14:04:01 -0400
Date: Sat, 24 May 2014 14:03:58 -0400 (EDT)
Message-Id: <20140524.140358.1963098926345179335.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        nm@ti.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/4] ks8851 DT/regulator/gpio updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400875040-13269-1-git-send-email-sboyd@codeaurora.org>
References: <1400875040-13269-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 May 2014 11:04:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Fri, 23 May 2014 12:57:16 -0700

> This set of patches properly documents the micrel ks8851 spi ethernet
> controller, converts to devm_regulator_get_optional() to make error
> paths slightly simpler, and finally adds supports for another
> optional regulator and a reset gpio. This allows me to use the ks8851
> on my MSM8960 CDP board.
> 
> Changes since v1:
>  * Dropped vendor prefix patch as that should go through DT tree

Series applied, thanks Stephen!
