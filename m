Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbaGBTJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:09:55 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:42203 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaGBTJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:09:53 -0400
Date: Wed, 2 Jul 2014 22:09:44 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Felipe Balbi <balbi@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140702190944.GA567@drone.musicnaut.iki.fi>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702160932.GF5541@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
> > It has been only tested as console UART.
> > The tty name is ttyS based instead of ttyO. How big is the pain here,
> > what could be the easiest way to provide compatibility?
> 
> have been considering that myself for months. You could pass an optional
> argument to serial8250_register_8250_port() but that only solves part of
> the problem :-(

When ttyS -> ttyO change was done on OMAP, compatibility was not an issue.
Why should we care about it now?

A.
