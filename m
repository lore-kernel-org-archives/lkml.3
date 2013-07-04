Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab3GDVfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:35:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50958 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab3GDVfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:35:02 -0400
Date: Thu, 04 Jul 2013 14:35:01 -0700 (PDT)
Message-Id: <20130704.143501.1841830283181488951.davem@davemloft.net>
To: srinivas.kandagatla@st.com
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] extend stmmac DT support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372930496-18923-1-git-send-email-srinivas.kandagatla@st.com>
References: <1372930496-18923-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Date: Thu,  4 Jul 2013 10:34:56 +0100

> Thankyou for the comments on v1 patches.
> 
> This patch series adds support to new gmac versions 3.6.10 and 3.710, these
> versions of IP are integrated into ST STiH415/STiH416 SOCs.
> This patchset also adds phy reset capablity to stmmac-mdio driver via DT.
> 
> Changes since v1:
> 	- Fixed unused variable warings pointed by Dave M.
> 
> Changes since RFC:
> 	- re-use existing compatible strings to select right properties.
> 	- clean up reset callback support so that DT is not parsed everytime.

Series applied, thanks.
