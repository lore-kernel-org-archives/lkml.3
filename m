Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3HZUpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:45:49 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14165 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102Ab3HZUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:45:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/r8YaIEz/pu7FE5tV1Rqc4g3zU7Tsqi4E=
Date: Mon, 26 Aug 2013 16:45:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com,
        ezequiel.garcia@free-electrons.com, mturquette@linaro.org,
        sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/3] arm: mvebu: fix resource leak
Message-ID: <20130826204523.GD24470@titan.lakedaemon.net>
References: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 07:36:55PM +0800, Jisheng Zhang wrote:
> These patches try to fix resource leak by adding missing of_node_put(),
> iounmap or using devm_ioremap_resource() if available.
> 
> v4:
>   - re-generate since Ezequiel's patches add DT support to the
> mvebu-mbus driver

grrr.  I hate to ask this, but can you please rebase patches 1 and 2
against mvebu/fixes-non-critical?  No need to add back in the mvebu-mbus
hunk.

thx,

Jason.
