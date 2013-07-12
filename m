Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab3GLATL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:19:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33792 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3GLATI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:19:08 -0400
Date: Thu, 11 Jul 2013 17:19:07 -0700 (PDT)
Message-Id: <20130711.171907.1475265685676501670.davem@davemloft.net>
To: wsa@the-dreams.de
Cc: linux-kernel@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 09/12] drivers/net/ieee802154: don't use
 devm_pinctrl_get_select_default() in probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373471889-18107-9-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	<1373471889-18107-9-git-send-email-wsa@the-dreams.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>
Date: Wed, 10 Jul 2013 16:57:44 +0100

> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied.
