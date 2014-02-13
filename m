Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaBMXaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:30:22 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59665 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751923AbaBMXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:30:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/1qbQhMxbS1MSZ6ynLn4BU
Date: Thu, 13 Feb 2014 15:30:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: Remove legacy macros for zoom platforms
Message-ID: <20140213233000.GT28216@atomide.com>
References: <1392198352.23759.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392198352.23759.10.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [140212 01:48]:
> Commit 97411608fd5f ("ARM: OMAP2+: Remove legacy support for zoom
> platforms") removed the Kconfig symbols MACH_OMAP_ZOOM2 and
> MACH_OMAP_ZOOM3. Remove the last usage of the related macros too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested, but should have zero impact.

Thanks applying into omap-for-v3.14/fixes.

Tony
