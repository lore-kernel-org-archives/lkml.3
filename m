Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3AQTAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:00:04 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:42004 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3AQTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:00:01 -0500
Date: Thu, 17 Jan 2013 19:00:00 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: Tony Lindgren <tony@atomide.com>, balbi@ti.com, sameo@linux.intel.com,
        kishon@ti.com, sshtylyov@mvista.com, bjorn@mork.no,
        linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v7 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
In-Reply-To: <20130117170321.GJ14149@atomide.com>
Message-ID: <alpine.DEB.2.00.1301171854280.14118@utopia.booyaka.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com> <1358422231-24736-20-git-send-email-rogerq@ti.com> <20130117170321.GJ14149@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Thu, 17 Jan 2013, Tony Lindgren wrote:

> * Roger Quadros <rogerq@ti.com> [130117 03:34]:
> > We don't need multiple aliases for the OMAP USB host clocks and neither
> > the dummy clocks so remove them.
> 
> It's best that Paul queues this and the next patch as these clock alias
> clean-up patches can be done separately. That way the dependency between
> arch/arm/*omap* code is cut away as these files should be moved to live
> under drivers/clk/omap.

Per Tony's request, I'll queue these two cleanup patches for 3.10 -- or 
whatever Linus will call it.


- Paul
