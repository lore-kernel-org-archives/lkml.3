Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaEOALK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:11:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44196 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEOALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:11:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/G6nESPrCt9LaFdRDRzk0B
Date: Wed, 14 May 2014 17:11:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] bus/omap_l3: avoid sync initcall for modules
Message-ID: <20140515001100.GB31594@atomide.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <20140513162731.GD16837@atomide.com>
 <20140514173931.GA14003@kroah.com>
 <5640589.bzCk17dFyc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5640589.bzCk17dFyc@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [140514 11:16]:
> On Wednesday 14 May 2014 10:39:31 Greg KH wrote:
> > On Tue, May 13, 2014 at 09:27:33AM -0700, Tony Lindgren wrote:
> > > * Arnd Bergmann <arnd@arndb.de> [140513 08:13]:
> > > 
> > > I did not look what percentage has tristate in the Kconfig,
> > > but that might keep some people from making loadable drivers.
> > > 
> > > Greg, is the following patch something you may want to
> > > consider picking up?
> > 
> > Sure, is this needed to fix issues in 3.15-final, or is 3.16-rc1 ok?
> 
> I don't think anyone cares about it outside of randconfig builds,
> so 3.16-rc1 is ok.

Yeah thanks.

Tony
