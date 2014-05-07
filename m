Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaEGUwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:52:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51798 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaEGUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:52:07 -0400
Date: Wed, 07 May 2014 16:52:04 -0400 (EDT)
Message-Id: <20140507.165204.912551375605501069.davem@davemloft.net>
To: hchaumette@adeneo-embedded.com
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, xobs@kosagi.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 0/2] net/phy: micrel: Add DT configuration support
 and documentation for KSZ9031
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399362017-25787-1-git-send-email-hchaumette@adeneo-embedded.com>
References: <1399362017-25787-1-git-send-email-hchaumette@adeneo-embedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 07 May 2014 13:52:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hubert Chaumette <hchaumette@adeneo-embedded.com>
Date: Tue,  6 May 2014 09:40:15 +0200

>  - Adds DT configuration support for ksz9031
>  - Renames micrel-ksz9021.txt to micrel-ksz90x1.txt and adds ksz9031 binding
>    documentation
> 
> Changes since v3:
>  - Rebased on net-next
> Changes since v2:
>  - Merged together ksz9031_load_{clk,data,ctrl}_skew_values()
>  - Added field length and number of fields prameter to account for registers
>   specificities
>  - Added binding documentation
> Changes since v1:
>  - Removed ksz9021 and ksz9031 fixup deletions from arch/arm/mach-imx/mach-imx6q.c

Series applied to net-next, thanks.
