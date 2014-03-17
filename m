Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbaCQPaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:30:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58656 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbaCQPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:30:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/RKjnOR7sDEFNYVIGCGqmpMRYzI4HoxOM=
X-DKIM: OpenDKIM Filter v2.0.1 titan B00505451FD
Date: Mon, 17 Mar 2014 11:29:58 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM: add Marvell Dove and some drivers to multi_v7
 defconfig
Message-ID: <20140317152958.GJ15608@titan.lakedaemon.net>
References: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393536486-3827-5-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140304040729.GJ1872@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304040729.GJ1872@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

Here's the multi_v7_defconfig change I was referring to:

https://lkml.kernel.org/r/1393536486-3827-5-git-send-email-sebastian.hesselbarth@gmail.com

On Mon, Mar 03, 2014 at 11:07:29PM -0500, Jason Cooper wrote:
> Arnd, Olof, Kevin,
> 
> On Thu, Feb 27, 2014 at 10:28:05PM +0100, Sebastian Hesselbarth wrote:
> > With Marvell Dove now being part of the multi_v7 family, add some Dove
> > specific drivers to multi_v7 defconfig.
> > 
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Olof Johansson <olof@lixom.net>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Gregory Clement <gregory.clement@free-electrons.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/configs/multi_v7_defconfig | 4 ++++
> >  1 file changed, 4 insertions(+)
> 
> I'm taking the other part of this series in, so:
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
