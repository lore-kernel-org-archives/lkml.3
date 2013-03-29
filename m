Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3C2Kob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:44:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36774 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3C2Koa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:44:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 29 Mar 2013 11:44:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
Message-ID: <20130329114409.3634676e@stein>
In-Reply-To: <20130326213532.38a7bd4c@stein>
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
	<20130326195653.470b09d6@stein>
	<1364324929.3866.13.camel@thor.lan>
	<20130326213532.38a7bd4c@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 26 Stefan Richter wrote:
> On Mar 26 Peter Hurley wrote:
> > On Tue, 2013-03-26 at 19:56 +0100, Stefan Richter wrote:
> > > It has been a long time though since I last checked whether PhyUpperBound
> > > is implemented; maybe it has become more widespread than it was back then.
> > > 
> > > Or maybe it hasn't:  All OHCI-1394 chips that ever came to market are 32
> > > bit chips anyway.  So the few rare ones that do support PhyUpperBound
> > > larger than 4 GB cannot in fact use it.
> > > 
> > > Or am I severely behind the times about this?
> > 
> > The FW643e-2 is natively PCIe (not behind a bridge) and supports phys
> > DMA past 4GB (the datasheet says all 48 bits but I can only test it out
> > to 10GB).
> > 
> > I thought the FW643e was as well? You'll have to test that out :)
> 
> OK, will do.

Does lspci or something similar show which PCI devices are capable of 64 bit
wide addressing?
-- 
Stefan Richter
-=====-===-= --== ===-=
http://arcgraph.de/sr/
