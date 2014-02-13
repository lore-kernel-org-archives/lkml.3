Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaBMX3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:29:08 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57137 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbaBMX3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:29:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dKx9M2jzJjU94hJVbD7XU
Date: Thu, 13 Feb 2014 15:28:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: Remove MACH_NOKIA_N800
Message-ID: <20140213232842.GS28216@atomide.com>
References: <1391958088.25424.17.camel@x220>
 <20140209195021.GE573@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140209195021.GE573@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Aaro Koskinen <aaro.koskinen@iki.fi> [140209 11:53]:
> Hi,
> 
> On Sun, Feb 09, 2014 at 04:01:28PM +0100, Paul Bolle wrote:
> > The last caller of machine_is_nokia_n800() was removed in commit
> > 5a87cde490e1 ("ARM: OMAP2+: Remove legacy booting support for n8x0").
> > That means that the Kconfig symbol MACH_NOKIA_N800 is now unused. It can
> > safely be removed.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks applying into omap-for-v3.14/fixes.

Tony
