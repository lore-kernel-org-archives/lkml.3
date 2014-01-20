Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaATEDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:03:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41129 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:03:34 -0500
Date: Sun, 19 Jan 2014 20:03:33 -0800 (PST)
Message-Id: <20140119.200333.695302698969720789.davem@davemloft.net>
To: wens@csie.org
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com, srinivas.kandagatla@st.com,
        vapier@gentoo.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/8] net: stmmac: Add Allwinner A20 GMAC
 ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389965087-21971-1-git-send-email-wens@csie.org>
References: <1389965087-21971-1-git-send-email-wens@csie.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 17 Jan 2014 21:24:39 +0800

> This is v3 of the  Allwinner A20 GMAC glue layer for stmmac.
> I have split the series into stmmac driver changes for net-next,
> and clock and DT patches for their respective trees.

Series applied, thanks.
