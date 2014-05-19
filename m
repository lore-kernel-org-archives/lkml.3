Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaESTnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:43:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42836 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751331AbaESTnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:43:02 -0400
Date: Mon, 19 May 2014 15:43:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <joe@perches.com>,
        <auttamchandani@logicube.com>
Subject: Re: [PATCH 4/5] usb: gadget: net2280: Code Cleanup
In-Reply-To: <1400526693-29776-5-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405191540040.1538-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:

> Move logical continuations to end of line

This is almost totally unnecessary.  Some people prefer the 
operators at the end of the first line, other people prefer them at the 
start of the next line.  It's just a matter of taste and it doesn't 
matter.

> @@ -402,8 +402,8 @@ static void ep_reset_228x(struct net2280_regs __iomem *regs,
>  		BIT(DATA_PACKET_RECEIVED_INTERRUPT) |
>  		BIT(DATA_PACKET_TRANSMITTED_INTERRUPT) |
>  		BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
> -		BIT(DATA_IN_TOKEN_INTERRUPT)
> -		, &ep->regs->ep_stat);
> +		BIT(DATA_IN_TOKEN_INTERRUPT),
> +		&ep->regs->ep_stat);

This is an example of the one type of change that does make sense.  
Nobody should start lines with a ','.

Alan Stern

