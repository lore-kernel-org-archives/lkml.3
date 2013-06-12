Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3FLOqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:46:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3FLOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:46:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 21/33 v2] clk: ux500: Add Device Tree support for the PRCC Kernel clock
Date: Wed, 12 Jun 2013 16:46:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org> <1370521041-32318-22-git-send-email-lee.jones@linaro.org> <20130611110923.GB3330@laptop>
In-Reply-To: <20130611110923.GB3330@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121646.30279.arnd@arndb.de>
X-Provags-ID: V02:K0:hPYG4Dh74hdfvndboqkNdulKdb/saVI3B6+prFe50Tp
 1BNok3k1P+LFiknxhLzfx3hwxCMASnRHtJ1RDHIdFnzXF8gIwY
 eF83JG8M0J310nRm7HNZ9foi3CSjq9E+DaRYdw/ggY0UD6zdIM
 Vvx2IIUITR2nAsxdlmk37ZA6q+XVKxzznexgB5Vic80tYPoP5x
 FUjyo9sSFB95gkM4M0jS3hq48gY1IsFc2+dz58mIrpP+psRkOW
 ww3TJ7h2wsLWG4Wa+ylyvrXeHwjLJb/zsy7hGxtpPTEs93lL6Y
 FlhVsBdK5aF4AI0AbNCz3ho8qxwbu87eEl2k1lqEecSU1K1jSv
 ctvdCLNOkX0qAzCsP7n4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 June 2013, Lee Jones wrote:
> This patch enables clocks to be specified from Device Tree via phandles
> to the "prcc-kernel-clock" node.
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 

I don't understand the design of the common clock subsystem here, but is it really
necessary to hardcode all the clocks using clk_reg_prcc_kclk() here *and* register
a clkdev *and* store the pointer in an array, when you can get all that information
from the device tree?

Mike?

	Arnd
