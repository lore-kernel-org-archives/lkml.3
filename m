Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaEOTrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:47:51 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:39350 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaEOTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:47:50 -0400
Date: Thu, 15 May 2014 22:43:17 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: remove some dead code
Message-ID: <20140515194317.GB4752@drone.musicnaut.iki.fi>
References: <1400181381.11786.18.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400181381.11786.18.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 09:16:21PM +0200, Paul Bolle wrote:
> A check for CONFIG_CBUS_TAHVO_USB was added in v2.6.17. The related
> Kconfig symbol has never been part of the tree. Remove that check.
> 
> Replace the while (...) loop with a simple if (...) statement, while
> we're at it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>

> ---
> Untested, as usual.
> 
> A quick search across the history of the tree suggests CBUS_TAHVO_USB
> was N770 related. Not that this matters much.

Yes, Tahvo USB is only used on Nokia 770 (which is the correct name,
not N770). The driver is nowadays behind TAHVO_USB, but like you said
the old symbol was never part of the mainline so it's OK to delete it.

A.
