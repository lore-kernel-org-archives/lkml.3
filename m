Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3AVRhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:37:14 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49472 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3AVRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:37:12 -0500
Date: Tue, 22 Jan 2013 09:37:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/33] ARM: Convert to devm_ioremap_resource()
Message-ID: <20130122173707.GA25022@kroah.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-3-git-send-email-thierry.reding@avionic-design.de>
 <20130121155846.GN23505@n2100.arm.linux.org.uk>
 <20130121160547.GA10790@avionic-0098.adnet.avionic-design.de>
 <20130121161611.GS23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121161611.GS23505@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 04:16:11PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 21, 2013 at 05:05:47PM +0100, Thierry Reding wrote:
> > On Mon, Jan 21, 2013 at 03:58:46PM +0000, Russell King - ARM Linux wrote:
> > > On Mon, Jan 21, 2013 at 11:08:55AM +0100, Thierry Reding wrote:
> > > > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > > > devm_ioremap_resource() which provides more consistent error handling.
> > > 
> > > Does this include the resource part of the handling too?
> > 
> > I'm not sure I understand your question. devm_ioremap_resource() does a
> > devm_request_mem_region() internally if that's what you were asking.
> 
> Ah, that's fine then.  The function name is a little misleading, and as
> it doesn't exist in mainline at present, it is not something I know about.

Can I assume this is an Acked-by: from you for this patch so that I can
take this through my driver-core tree?

thanks,

greg k-h
