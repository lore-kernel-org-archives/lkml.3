Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3E0JXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:23:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33587 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3E0JXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:23:42 -0400
Date: Mon, 27 May 2013 02:23:39 -0700 (PDT)
Message-Id: <20130527.022339.791886107453761860.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: buytenh@wantstofly.org, jason@lakedaemon.net, andrew@lunn.ch,
        benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address
 workaround on DT ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <51A26B62.4050009@gmail.com>
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130525.210441.818472895703230779.davem@davemloft.net>
	<51A26B62.4050009@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Sun, 26 May 2013 22:06:58 +0200

> good you mention it. I added Grant on Cc and will give a short
> sum-up why I casted the const from property->value away here.
> 
> Maybe I overlooked the API for modifying the DT property but as
> far as I've seen - there is no API for modifying it. And yes,
> you are right, it is kind of an abuse of DT here.

Sparc has an of_set_property(), it needs to become generic.
