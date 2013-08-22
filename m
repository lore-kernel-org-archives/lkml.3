Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3HVNWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:22:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44135 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752663Ab3HVNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:22:16 -0400
Date: Thu, 22 Aug 2013 10:22:08 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: jason@lakedaemon.net, andrew@lunn.ch, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, mturquette@linaro.org,
        sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pinctrl: mvebu: add missing iounmap
Message-ID: <20130822132207.GA27167@localhost>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
 <1377175611-4241-5-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377175611-4241-5-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Thu, Aug 22, 2013 at 08:46:51PM +0800, Jisheng Zhang wrote:
> Add missing iounmap to prove error path and remove path
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)

How about using devm_ioremap_resource() instead?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
