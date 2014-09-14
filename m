Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaINGhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 02:37:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:65329 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402AbaINGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 02:37:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+c24h9Ge7xDUI3AacB5UgA0jCZ49NL7vg=
X-DKIM: OpenDKIM Filter v2.0.1 titan 13CD45E14F4
Date: Sun, 14 Sep 2014 02:37:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/8] irqchip: atmel-aic5: Add sama5d4 support
Message-ID: <20140914063713.GN21986@titan.lakedaemon.net>
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410536587-24607-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410536587-24607-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 05:43:00PM +0200, Alexandre Belloni wrote:
> Add sama5d4 support to irq-atmel-aic5.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
>  .../devicetree/bindings/interrupt-controller/atmel,aic.txt     |  2 +-
>  drivers/irqchip/irq-atmel-aic5.c                               | 10 ++++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)

Applied to irqchip/atmel

thx,

Jason.
