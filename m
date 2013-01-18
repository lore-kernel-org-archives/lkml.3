Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3ARU16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:27:58 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:50805 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARU15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:27:57 -0500
Date: Fri, 18 Jan 2013 20:27:56 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: sameo@linux.intel.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rajendra Nayak <rnayak@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v8 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
In-Reply-To: <1358511445-26656-20-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.00.1301182027040.19470@utopia.booyaka.com>
References: <1358511445-26656-1-git-send-email-rogerq@ti.com> <1358511445-26656-20-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Fri, 18 Jan 2013, Roger Quadros wrote:

> We don't need multiple aliases for the OMAP USB host clocks and neither
> the dummy clocks so remove them.
> 
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Rajendra Nayak <rnayak@ti.com>
> CC: Benoit Cousson <b-cousson@ti.com>
> CC: Mike Turquette <mturquette@linaro.com>
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Paul Walmsley <paul@pwsan.com>

Per Tony's earlier request, you can drop this patch and patch 20 from your 
series now.  I've got them queued for 3.10 or late 3.9 merge window.

- Paul
