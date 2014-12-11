Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbaLKBlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:41:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49430 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKBlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:41:15 -0500
Date: Wed, 10 Dec 2014 20:41:10 -0500 (EST)
Message-Id: <20141210.204110.618599360537141819.davem@davemloft.net>
To: m-karicheri2@ti.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH v7 2/3] net: Add Keystone NetCP ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <5488BB96.9070609@ti.com>
References: <1417556503-22290-3-git-send-email-m-karicheri2@ti.com>
	<20141209.131053.2026868499542642866.davem@davemloft.net>
	<5488BB96.9070609@ti.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 17:41:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Wed, 10 Dec 2014 16:31:02 -0500

> Are you referring to the static code analyser sparse that is invoked
> through?

You have to explicitly enable endian checking, it's not on by
default.
