Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3AWBLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:11:51 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:13287 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855Ab3AWBLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:11:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+eCTN7jb4m6Dt30TDkTgTlmXWIB2ML9iA=
Date: Tue, 22 Jan 2013 20:11:25 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jean-Francois Moine <moinejf@free.fr>,
        Jamie Lentin <jm@lentin.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: fix missing #interrupt-cells property
Message-ID: <20130123011125.GC1758@titan.lakedaemon.net>
References: <1358883993-17280-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358883993-17280-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 08:46:33PM +0100, Sebastian Hesselbarth wrote:
> The gpio controller on kirkwood can provide interrupts but is missing
> the #interrupt-cells property. This patch just adds it to both gpio
> controllers.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Jamie Lentin <jm@lentin.co.uk>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/kirkwood.dtsi |    2 ++
>  1 file changed, 2 insertions(+)

Applied to mvebu/fixes

thx,

Jason.
