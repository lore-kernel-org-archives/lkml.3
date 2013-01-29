Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3A2QIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:08:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57976 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3A2QIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:08:36 -0500
Date: Tue, 29 Jan 2013 16:08:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [RFC PATCH 1/2] ARM: kernel: update cpuinfo to print CPU model
	name
Message-ID: <20130129160827.GJ2637@n2100.arm.linux.org.uk>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com> <1359474865-15408-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359474865-15408-2-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 05:54:24PM +0200, Ruslan Bilovol wrote:
> CPU implementer : 0x41
> CPU name        : OMAP4470 ES1.0 HS

Sigh.  No.  Look at what you're doing - look carefully at the above.

"CPU implementer" - 0x41.  That's A.  For ARM Ltd.  ARM Ltd implemented
this CPU.  Did ARM Ltd really implement OMAP4470 ?  I think TI would be
very upset if that were to be the case.

So no, OMAP4470 is _NOT_ a CPU.  It is a SoC.  The CPU inside the SoC is
a collection of ARM Ltd Cortex A9 _CPUs_.

See?  Please, learn what a CPU is as opposed to a SoC.
