Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbbAWIyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:54:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46205 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbAWIye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:54:34 -0500
Date: Fri, 23 Jan 2015 00:54:30 -0800 (PST)
Message-Id: <20150123.005430.1746414428211289227.davem@davemloft.net>
To: arnd@arndb.de
Cc: wstephen@codeaurora.org, jcliburn@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1753817.oBE21Kj2o0@wuerfel>
References: <1702448.pOVnDx4KzI@wuerfel>
	<f9cbb34c9228b2af7ed6c1c96a6aa61c.squirrel@www.codeaurora.org>
	<1753817.oBE21Kj2o0@wuerfel>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Jan 2015 00:54:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 22 Jan 2015 11:18:50 +0100

> I see. In this case, I think merging your new driver is not a good idea:

+1
