Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaKBCX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 22:23:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33862 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaKBCXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 22:23:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/VzYe+bRZ9Dn7CneJNWZO1OC+DclYWmgs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 110D560F4E5
Date: Sat, 1 Nov 2014 22:23:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: tglx@linutronix.de, sebastian.hesselbarth@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] irqchip: dw-apb-ictl: select GENERIC_IRQ_CHIP
Message-ID: <20141102022311.GS3698@titan.lakedaemon.net>
References: <1413982750-832-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413982750-832-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jisheng,

On Wed, Oct 22, 2014 at 08:59:10PM +0800, Jisheng Zhang wrote:
> The dw-apb-ictl driver uses the generic-chip functions.
> Thus it needs to select GENERIC_IRQ_CHIP in Kconfig.
> 
> Change-Id: If748beffc4e0d0b47062bb067a59c10994a9148b

Please don't include this is future patches.

> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/irqchip/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Applied to irqchip/core

thx,

Jason.
