Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3ERAgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 20:36:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46391 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3ERAgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 20:36:47 -0400
Date: Fri, 17 May 2013 17:36:44 -0700 (PDT)
Message-Id: <20130517.173644.1877140985770026320.davem@davemloft.net>
To: linux@prisktech.co.nz
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
Subject: Re: [PATCHv6 0/3] Add support for velocity network driver on
 platform devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130517.141938.2120801813213703422.davem@davemloft.net>
References: <1368768078-16121-1-git-send-email-linux@prisktech.co.nz>
	<20130517.141938.2120801813213703422.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 17 May 2013 17:36:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4I0awU5002168

From: David Miller <davem@davemloft.net>
Date: Fri, 17 May 2013 14:19:38 -0700 (PDT)

> 
> Series applied, thanks.

I'm reverting this, you're not using the correct types for the PM
functions you're hooking up.

drivers/net/ethernet/via/via-velocity.c:3238:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/via/via-velocity.c:3238:8: warning: (near initialization for ¡velocity_pm_ops.suspend¢) [enabled by default]
drivers/net/ethernet/via/via-velocity.c:3238:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/via/via-velocity.c:3238:8: warning: (near initialization for ¡velocity_pm_ops.freeze¢) [enabled by default]
drivers/net/ethernet/via/via-velocity.c:3238:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/via/via-velocity.c:3238:8: warning: (near initialization for ¡velocity_pm_ops.poweroff¢) [enabled by default]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
