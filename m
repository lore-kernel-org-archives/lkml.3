Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3H0OnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:43:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16156 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3H0OnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:43:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zqVdBYhAfQ95SmBLQYNLMvFsEr+W9pXc=
Date: Tue, 27 Aug 2013 10:42:53 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com,
        ezequiel.garcia@free-electrons.com, mturquette@linaro.org,
        sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/3] arm: mvebu: fix resource leak
Message-ID: <20130827144253.GC19598@titan.lakedaemon.net>
References: <1377578476-3268-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377578476-3268-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jisheng,

On Tue, Aug 27, 2013 at 12:41:13PM +0800, Jisheng Zhang wrote:
> These patches try to fix resource leak by adding missing of_node_put(),
> iounmap or using devm_ioremap_resource() if available.
> 
> v5:
>   - rebase against mvebu/fixes-non-critical

Thanks!

> v4:
>   - re-generate since Ezequiel's patches add DT support to the
> mvebu-mbus driver
> 
> v3:
>   - remove the clk patch since it's already taken by Mike
>   - Add more commit log as suggested by Ezequiel Garcia
> 
> v2:
>   - use devm_ioremap_resource() as suggested by Ezequiel Garcia
>   - use gates_out instead of bail_out as suggested by Mike Turquette
> 
> Jisheng Zhang (3):
>   arm: mvebu: add missing of_node_put() to fix reference leak
>   bus: mvebu: add missing of_node_put() to fix reference leak

Applied patched 1 and 2 to mvebu/fixes-non-critical,

>   pinctrl: mvebu: Convert to use devm_ioremap_resource

Previously Acked patch 3 for LinusW

thx,

Jason.
