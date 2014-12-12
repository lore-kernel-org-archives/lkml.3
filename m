Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbaLLCjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:39:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58959 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854AbaLLCjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:39:16 -0500
Date: Thu, 11 Dec 2014 21:39:13 -0500 (EST)
Message-Id: <20141211.213913.1129074366073203370.davem@davemloft.net>
To: hau@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8169:update rtl8168g pcie ephy parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418218118-15018-1-git-send-email-hau@realtek.com>
References: <1418218118-15018-1-git-send-email-hau@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 18:39:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunhao Lin <hau@realtek.com>
Date: Wed, 10 Dec 2014 21:28:38 +0800

> Add ephy parameter to rtl8168g.
> Also change the common function of rtl8168g from "rtl_hw_start_8168g_1" to
>  "rtl_hw_start_8168g". And function "rtl_hw_start_8168g_1" is used for
> setting rtl8168g hardware parameters.
> 
> Following is the explanation of what hardware parameter change for.
> rtl8168g may erroneous judge the PCIe signal quality and show the error bit
> on PCI configuration space when in PCIe low power mode.
> The following ephy parameters are for above issue.
> { 0x00, 0x0000,	0x0008 }
> { 0x0c, 0x37d0,	0x0820 }
> { 0x1e, 0x0000,	0x0001 }
> 
> rtl8168g may return to PCIe L0 from PCIe L0s low power mode too slow.
> The following ephy parameter is for above issue.
> { 0x19, 0x8000,	0x0000 }
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>

Applied, thanks.
