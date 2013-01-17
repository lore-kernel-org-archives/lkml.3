Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3AQW3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:29:54 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:43290 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3AQW3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:29:53 -0500
Date: Thu, 17 Jan 2013 22:29:52 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        sameo@linux.intel.com, kishon@ti.com, sshtylyov@mvista.com,
        bjorn@mork.no, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v7 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
In-Reply-To: <20130117210034.GA27671@arwen.pp.htv.fi>
Message-ID: <alpine.DEB.2.00.1301172228140.14118@utopia.booyaka.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com> <1358422231-24736-20-git-send-email-rogerq@ti.com> <20130117170321.GJ14149@atomide.com> <alpine.DEB.2.00.1301171854280.14118@utopia.booyaka.com> <20130117210034.GA27671@arwen.pp.htv.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Felipe Balbi wrote:

> do you mean v3.9 ?

It sounds like the other patches need to be merged first before these 
cleanups can be merged.  So rather than adding a merge order dependency 
during 3.9, it seems best to queue the non-essential clock cleanup side 
for 3.10.


- Paul
