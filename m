Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3AJX6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:58:02 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35364 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3AJX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:58:00 -0500
Date: Thu, 10 Jan 2013 15:57:59 -0800 (PST)
Message-Id: <20130110.155759.127269416182567301.davem@davemloft.net>
To: bh74.an@samsung.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, jeffrey.t.kirsher@intel.com,
        kgene.kim@samsung.com
Subject: Re: [PATCH v2 3/3] net: stmmac: add gmac autonego set for ethtool
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <003d01cdef8d$d25b2bf0$771183d0$@samsung.com>
References: <000601cdedf8$5d39bdf0$17ad39d0$@samsung.com>
	<20130110.000208.2040524620441942742.davem@davemloft.net>
	<003d01cdef8d$d25b2bf0$771183d0$@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungho An <bh74.an@samsung.com>
Date: Thu, 10 Jan 2013 15:54:24 -0800

> @@ -348,6 +349,10 @@ stmmac_set_pauseparam(struct net_device *netdev,
>  
>  	if (phy->autoneg) {
>  		if (netif_running(netdev))
> +			if((interface == PHY_INTERFACE_MODE_SGMII) ||
> +			   (interface == PHY_INTERFACE_MODE_TBI) ||
> +			   (interface == PHY_INTERFACE_MODE_RTBI)) 
> +				priv->hw->mac->set_autoneg(priv->ioaddr);

This is still not properly formatted.

You also didn't submit this properly.  Never use email thread replies
to submit new versions of patches.

Always use fresh, new, mailing list postings to submit new versions
of patches.

Also, when one patch has to change in a series, you must reubmit
the entire set of patches even if some of them have no changes
at all.  I do not see patch #2 here at all.
