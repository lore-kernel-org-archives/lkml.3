Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941AbaE3XbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:31:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60463 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934913AbaE3XbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:31:04 -0400
Date: Fri, 30 May 2014 16:31:02 -0700 (PDT)
Message-Id: <20140530.163102.1981140061094569862.davem@davemloft.net>
To: ivan@ru.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, alistair@popple.id.au, robh+dt@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 1/2] emac: add missing support of 10mbit in emac/rgmii
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401128657.24099.17.camel@localhost.localdomain>
References: <1401128657.24099.17.camel@localhost.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 16:31:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan Mikhaylov <ivan@ru.ibm.com>
Date: Mon, 26 May 2014 22:24:17 +0400

> In chips of emac/rgmii b'000' for 0/1 channel isn't suitable which
> resulted in non working network interface in this mode.
> 
> Signed-off-by: Ivan Mikhaylov <ivan@ru.ibm.com>

Applied.
