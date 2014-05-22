Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaEVTSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:18:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41613 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaEVTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:18:20 -0400
Date: Thu, 22 May 2014 15:18:17 -0400 (EDT)
Message-Id: <20140522.151817.763033809324051260.davem@davemloft.net>
To: f.fainelli@gmail.com
Cc: netdev@vger.kernel.org, pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        leoli@freescale.com, grant.likely@linaro.org,
        sergei.shtylyov@cogentembedded.com,
        thomas.petazzoni@free-electrons.com, aida.mynzhasova@skitlab.ru,
        richardcochran@gmail.com, claudiu.manoil@freescale.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next v2 0/9] net: of_phy_connect_fixed_link removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
References: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:18:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 22 May 2014 09:47:42 -0700

> This patch set removes of_phy_connect_fixed_link() from the tree now that
> we have a better solution for dealing with fixed PHY (emulated PHY) devices
> for drivers that require them.
> 
> First two patches update the 'fixed-link' Device Tree binding and drivers to
> refere to it.
> 
> Patches 3 to 7 update the in-tree network drivers that use
> of_phy_connect_fixed_link()
> 
> Patch 8 removes of_phy_connect_fixed_link
> 
> Patch 9 removes the PowerPC code that parsed the 'fixed-link' property.
> 
> Patch 9 can be merged via the net-next tree if the PowerPC folks ack it,
> but it really has to be merged after the first 8 patches in order to avoid
> breakage.

Series applied, if someone doesn't like patch #9 we can fix it up with a
followup patch or revert.
