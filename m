Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3HZUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:46:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15408 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949Ab3HZUqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:46:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX198r4IKgkbUBXe6W2lDGsAUzBzM4f3lQpc=
Date: Mon, 26 Aug 2013 16:46:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com,
        ezequiel.garcia@free-electrons.com, mturquette@linaro.org,
        sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/3] pinctrl: mvebu: Convert to use
 devm_ioremap_resource
Message-ID: <20130826204605.GE24470@titan.lakedaemon.net>
References: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
 <1377517018-7716-4-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377517018-7716-4-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 07:36:58PM +0800, Jisheng Zhang wrote:
> The resource mapped by of_iomap() isn't unmapped in error path. This
> patch fix the resource leakage by using devm_ioremap_resource() instead
> of of_iomap().
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
