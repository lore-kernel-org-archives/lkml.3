Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3GJVO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:14:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45525 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3GJVO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:14:57 -0400
Date: Wed, 10 Jul 2013 14:14:56 -0700 (PDT)
Message-Id: <20130710.141456.975401714119737529.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: wsa@the-dreams.de, linux-kernel@vger.kernel.org, wg@grandegger.com,
        anilkumar@ti.com, tony@atomide.com, jg1.han@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/12] drivers/net/can/c_can: don't use
 devm_pinctrl_get_select_default() in probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <51DDCC01.1090104@pengutronix.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	<1373471889-18107-7-git-send-email-wsa@the-dreams.de>
	<51DDCC01.1090104@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 10 Jul 2013 23:02:57 +0200

> On 07/10/2013 05:57 PM, Wolfram Sang wrote:
>> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
>> we can rely on device core for setting the default pins. Compile tested only.
>> 
>> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Who takes care of this patch/patch series?

Good question :-)
