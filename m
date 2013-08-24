Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3HXPGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:06:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54496 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754145Ab3HXPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:06:31 -0400
Date: Sat, 24 Aug 2013 12:06:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: jason@lakedaemon.net, andrew@lunn.ch, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, mturquette@linaro.org,
        sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] pinctrl: mvebu: Convert to use
 devm_ioremap_resource
Message-ID: <20130824150624.GA12907@localhost>
References: <1377225242-5854-1-git-send-email-jszhang@marvell.com>
 <1377225242-5854-5-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377225242-5854-5-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jisheng,

On Fri, Aug 23, 2013 at 10:34:02AM +0800, Jisheng Zhang wrote:
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 

Mmm.. I would prefer to see a better commit log for this patch.
In particular, the current code is buggy (for there's a leak) and
this patch fixes it.
Care to write something meaningful and re-send? (except the patch
Mike already took, I guess).

With that changes you can add:

Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>T

for the whole series.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
