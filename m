Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3C3Uz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:55:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39240 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3C3Uz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:55:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/FlgFe3VlG+4/Lg9vkrWElg+X1xtMbpFU=
Date: Sat, 30 Mar 2013 16:55:51 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>, linux-kernel@vger.kernel.org,
        Soeren Moch <smoch@web.de>, linux-arm-kernel@lists.infradead.org,
        Stefan Peter <s.peter@mpl.ch>
Subject: Re: [PATCH] ARM: kirkwood: add MACH_GURUPLUG_DT to defconfig
Message-ID: <20130330205551.GY13280@titan.lakedaemon.net>
References: <1364043502-17716-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364043502-17716-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 01:58:22PM +0100, Sebastian Hesselbarth wrote:
> This patch just adds the missing MACH_GURUPLUG_DT to kirkwood_defconfig.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Soeren Moch <smoch@web.de>
> ---
> Cc: Soeren Moch <smoch@web.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Stefan Peter <s.peter@mpl.ch>
> Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/configs/kirkwood_defconfig |    1 +
>  1 file changed, 1 insertion(+)

Applied to mvebu/boards

thx,

Jason.
