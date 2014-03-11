Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaCKSpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:45:31 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:46404 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaCKSp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:45:28 -0400
Date: Tue, 11 Mar 2014 12:45:13 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: linux-sunxi@googlegroups.com,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        dev@linux-sunxi.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-sunxi] Re: [RFC PATCH v2 08/14] mtd: nand: add sunxi NAND
 flash controller support
Message-ID: <20140311184513.GC31835@obsidianresearch.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
 <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com>
 <20140129175641.GF1427@obsidianresearch.com>
 <20140129184619.GC27143@localhost>
 <20140129191005.GG1427@obsidianresearch.com>
 <531D9F4B.6040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531D9F4B.6040505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 12:17:31PM +0100, Boris BREZILLON wrote:
> Hello Jason,
> 
> Le 29/01/2014 20:10, Jason Gunthorpe a écrit :
> >On Wed, Jan 29, 2014 at 03:46:20PM -0300, Ezequiel Garcia wrote:
> >
> >>After CE# has been pulled high and then transitioned low again, the host
> >>should issue a Set Features to select the appropriate asynchronous timing mode.
> >>"""
> >Oh, I had forgot you should do a set feature too
> >
> >Boris, I think the core core should handle this dance and the driver
> >should just implement a call back to change the timing mode on the
> >interface..
> >
> >If I ever get a moment I can work on support for timing setting in the
> >mvebu driver, I have boards here with ONFI NAND..
> 
> Any progress on this ?
> I'm about to post the 3rd version of this series and if you already have
> something working I could base my work on your proposal.

Sorry, no, I will try to look over your v3 though.

Regards,
Jason
