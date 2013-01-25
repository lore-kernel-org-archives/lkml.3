Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3AYIwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:52:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55032 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3AYIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:52:44 -0500
Date: Fri, 25 Jan 2013 08:52:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Venkatraman S <svenkatr@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [BUG] panda board locks up on boot
Message-ID: <20130125085234.GY23505@n2100.arm.linux.org.uk>
References: <1359082886.21576.199.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359082886.21576.199.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:01:26PM -0500, Steven Rostedt wrote:
> I've recently started testing my work on arm boards and have found that
> they both don't boot under the latest kernel anymore. I already posted
> about my snowball board, but my panda board also locks up.

You need to enable DMA engine and the OMAP DMA engine driver.  I believe
someone was going to work on adding PIO-mode support to the driver but
I suspect as TI's OMAP division is being reorganized, all that is now
uncertain.
