Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaHONF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:05:57 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:47881 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHONFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:05:55 -0400
Date: Fri, 15 Aug 2014 14:05:50 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        zhangfei.gao@marvell.com, prakity@marvell.com,
        rmk+kernel@arm.linux.org.uk
Cc: patches@linaro.org, lee.jones@linaro.org
Subject: Re: [PATCH v2] mmc: sdhci-pxav3: set_uhs_signaling is initialized
 twice differently
Message-ID: <20140815130550.GA20932@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1408107342-20318-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408107342-20318-1-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This means that uhs is currently broken for this platform currently, as pxav3
> has some special constriants which means it can't use the generic callback.
> 
> This happened in
> commit 96d7b78cfc2f ("mmc: sdhci: convert sdhci_set_uhs_signaling() into a library function")
> commit a702c8abb2a9 ("mmc: host: split up sdhci-pxa, create sdhci-pxav3.c")'
> 
> Fix this and hopefully prevent it happening in the future by ensuring named
> initialisers always follow the declaration order in the structure definition.

Or it would if I actually committed the change. Sorry for the noise, please ignore this patch.
I've just sent a V3.

regards,

Peter.
