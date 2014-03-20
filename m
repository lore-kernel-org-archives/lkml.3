Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbaCTVKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:10:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759376AbaCTVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:10:51 -0400
Date: Thu, 20 Mar 2014 17:10:49 -0400 (EDT)
Message-Id: <20140320.171049.532173053790368494.davem@davemloft.net>
To: jgunthorpe@obsidianresearch.com
Cc: robh+dt@kernel.org, f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2a 1/2] dt: Document a compatible entry for MDIO
 ethernet Phys
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395267324-5788-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1395267324-5788-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Mar 2014 14:10:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Wed, 19 Mar 2014 16:15:23 -0600

> This describes a compatible entry of the form:
>   ethernet-phy-idAAAA,BBBB
> Which is modelled after the PCI structured compatible entry
> (pciVVVV,DDDD.SSSS.ssss.RR)
> 
> If present the OF core will be able to use this information to
> directly create the correct phy without auto probing the bus.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied to net-next.
