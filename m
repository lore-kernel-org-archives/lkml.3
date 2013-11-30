Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab3K3Wvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:51:52 -0500
Received: from forward2m.mail.yandex.net ([37.140.138.2]:47615 "EHLO
	forward2m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K3Wvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:51:49 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Alexander Shiyan <shc_work@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
In-Reply-To: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
References: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
Subject: Re: [PATCH 1/3] w1: mxc_w1: Remove unused field "clkdiv" from private structure
MIME-Version: 1.0
Message-Id: <61631385851897@web3m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 01 Dec 2013 02:51:37 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

29.11.2013, 15:40, "Alexander Shiyan" <shc_work@mail.ru>:
> Private field "clkdiv" is not used outside "probe", so there are
> no reason to keep it in driver.

The whole serie looks good, thank you
Greg, please pull it into your tree

> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
