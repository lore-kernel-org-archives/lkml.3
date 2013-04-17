Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875Ab3DQRRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:17:19 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50160 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab3DQRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:17:16 -0400
X-Auth-Info: aUixKpHlSflG8p8B/r4CU1/w+UW6EbX0MhDzP/v4pic=
From: Marek Vasut <marex@denx.de>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] gpio: ucb1400: Can be built as a module
Date: Wed, 17 Apr 2013 19:17:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.8-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1366216474.8215.1.camel@chaos.site>
In-Reply-To: <1366216474.8215.1.camel@chaos.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304171917.11871.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean Delvare,

> With the recent code cleanup from Marek Vasut, driver gpio-ucb1400 can
> be built as a module, so change symbol GPIO_UCB1400 from bool to
> tristate.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Marek Vasut <marex@denx.de>

Thanks

Best regards,
Marek Vasut
