Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaBRUZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:25:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaBRUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:25:37 -0500
Date: Tue, 18 Feb 2014 12:27:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, rob@landley.net,
        linux@arm.linux.org.uk, galak@kernel.crashing.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        rob.herring@calxeda.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        grygorii.strashko@ti.com, dwmw2@infradead.org, nsekhar@ti.com
Subject: Re: [PATCH v4 0/2] Introduce AEMIF driver for Davinci/Keystone archs
Message-ID: <20140218202702.GA18642@kroah.com>
References: <1391629574-18955-1-git-send-email-ivan.khoronzhuk@ti.com>
 <53037113.3090105@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53037113.3090105@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:41:23AM -0500, Santosh Shilimkar wrote:
> Greg,
> 
> On Wednesday 05 February 2014 02:46 PM, Ivan Khoronzhuk wrote:
> > These patches introduce Async External Memory Interface (EMIF16/AEMIF)
> > controller driver for Davinci/Keystone archs.
> > 
> > For more informations see documentation:
> > Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
> > OMAP-L138 - http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
> > Kestone - http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf
> > 
> Can you please have a look at the series ? It has been on the list for
> sometime and all the outstanding comments are addressed so far. If
> you are ok with it, I would like to get these queued up for 3.15
> via your tree.

Why my tree?  Am I the drivers/memory/ maintainer?

/me digs in git...

Ah, it looks like I might be...

Ok, let me go review this.

greg k-h
