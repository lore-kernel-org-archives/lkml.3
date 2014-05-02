Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaEBT6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:58:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37019 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaEBT6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:58:16 -0400
Date: Fri, 02 May 2014 15:58:13 -0400 (EDT)
Message-Id: <20140502.155813.1370156727988237449.davem@davemloft.net>
To: hchaumette@adeneo-embedded.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, xobs@kosagi.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net/phy: micrel: Add DT configuration support
 and
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398764005-23855-1-git-send-email-hchaumette@adeneo-embedded.com>
References: <1398764005-23855-1-git-send-email-hchaumette@adeneo-embedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 May 2014 12:58:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hubert Chaumette <hchaumette@adeneo-embedded.com>
Date: Tue, 29 Apr 2014 11:33:23 +0200

>  - Adds DT configuration support for ksz9031
>  - Renames micrel-ksz9021.txt to micrel-ksz90x1.txt and adds ksz9031 binding
>    documentation
> 
> Changes since v2:
>  - Merged together ksz9031_load_{clk,data,ctrl}_skew_values()
>  - Added field length and number of fields prameter to account for registers
>   specificities
>  - Added binding documentation

These patches do not apply cleanly to net-next, please respin.

Thanks.
