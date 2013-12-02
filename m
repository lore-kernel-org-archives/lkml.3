Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3LBLwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:52:38 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43813 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3LBLwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:52:36 -0500
Date: Mon, 2 Dec 2013 11:52:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 05/11] serial: support for 16550 serial ports on LP-8x4x
Message-ID: <20131202115226.GI16735@n2100.arm.linux.org.uk>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com> <1385879185-22455-6-git-send-email-ynvich@gmail.com> <20131202113052.GG16735@n2100.arm.linux.org.uk> <1385984366.12531.24.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385984366.12531.24.camel@host5.omatika.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:39:26PM +0400, Sergei Ianovich wrote:
> On Mon, 2013-12-02 at 11:30 +0000, Russell King - ARM Linux wrote:
> > On Sun, Dec 01, 2013 at 10:26:18AM +0400, Sergei Ianovich wrote:
> > > +static struct platform_device lp8x4x_device = {
> > > +	.name			= "serial8250",
> > > +	.id			= PLAT8250_DEV_ACCENT,
> > 
> > You should not re-use the enum value here.  The enum is designed as a
> > method to provide the platform devices with a unique id, not as a means
> > to identify the manufacturer or anything else like that.
> 
> Should I add a new enum?

Add a new enum.
