Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3KXRG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 12:06:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41685 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3KXRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 12:06:25 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19NEW6S+7crkVxlXBo1shjSDM1eI46aYn4=
Date: Sun, 24 Nov 2013 12:06:15 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Nicolas Pitre <nico@fluxnic.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] mmc: mvsdio: workaround for spurious irqs
Message-ID: <20131124170615.GI29241@titan.lakedaemon.net>
References: <1384525354-901-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1384525354-901-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384525354-901-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:22:33PM +0100, Sebastian Hesselbarth wrote:
> SDIO controllers found on Marvell Kirkwood SoCs seem to cause a late,
> spurious irq although all interrupts have been disabled. This irq
> doesn't do any harm, neither to HW nor driver. To avoid some
> "unexpected irq" warning later, we workaround above issue by bailing
> out of irq handler early, if we didn't expect any.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/mvsdio.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
