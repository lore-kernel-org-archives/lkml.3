Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaH3Dtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:49:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53043 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaH3Dtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:49:45 -0400
Date: Fri, 29 Aug 2014 20:49:44 -0700 (PDT)
Message-Id: <20140829.204944.664583582819173206.davem@davemloft.net>
To: lftan@altera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lftan.linux@gmail.com, peppe.cavallaro@st.com, vbridger@altera.com
Subject: Re: [PATCH (net-next) v3] net: stmmac: fix warning from Sparse for
 socfpga
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409201986-3514-1-git-send-email-lftan@altera.com>
References: <1409201986-3514-1-git-send-email-lftan@altera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 Aug 2014 20:49:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ley Foon Tan <lftan@altera.com>
Date: Thu, 28 Aug 2014 12:59:46 +0800

> Warning:
> drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c:122:41:
> sparse: cast removes address space of expression
> drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c:122:38:
> sparse: incorrect type in assignment (different address spaces)
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

Applied, thanks.
