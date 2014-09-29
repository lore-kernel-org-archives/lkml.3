Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaI2XmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:42:07 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37860 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaI2XmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:42:04 -0400
Date: Mon, 29 Sep 2014 18:41:59 -0500
From: Michael Welling <mwelling@ieee.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        pmeerw@pmeerw.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20140929234159.GB13111@sysresccd>
References: <20140922140914.GC25620@saruman>
 <20140923140924.GA28592@saruman>
 <20140924143610.GA17997@saruman>
 <20140925221619.GA10644@saruman>
 <20140927041959.GA28445@saruman>
 <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
 <20140929185325.GA1939@saruman>
 <20140929223833.GA13111@sysresccd>
 <20140929224638.GA21681@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929224638.GA21681@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 05:46:38PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Sep 29, 2014 at 05:38:33PM -0500, Michael Welling wrote:
> > > > > Alright, this is already ridiculous. Andrew, if I resend the patch can
> > > > > you apply it since maintainer has been ignoring this thread anyway ?
> > > > > 
> > > > 
> > > > Do you reall think this is the best way to approach this?
> > > 
> > > when maintainer doesn't respond for weeks, yeah! Sure it is.
> > > 
> > > > Perhaps it would be better to explain what each field of the
> > > > configuration register does and then we can move on.
> > > 
> > > perhaps Jonathan could tell me exactly what he wants because I can't
> > > handle back-and-forth anymore. Specially when he complains about stuff
> > > he asked me to modify himself.
> > >
> > > > In particular the OPT3001_CONFIGURATION_L field needs to be explained
> > > > such that the ABI can be properly applied.
> > > > 
> > > > Looking at the docs for the Windows demo program the field is associated
> > > > with a latch configuration. What does this bit field actually do?
> > 
> > Still no technical information. Without all the facts how can you expect
> > him to tell you what he wants?
> 
> yeah, because clearly he doesn't know himself, right ?

Could you explain how it works to me then?

> 
> > > > Either have TI release the documentation or add comments to each of the
> > > > fields of each of the registers such that we can understand what exactly
> > > > they are doing.
> > > 
> > > TI will release the documentation when that's all cleared up with Legal.
> > > You can't expect it to be any earlier than that.
> > 
> > I am a little fuzzy on how the source code can be released when an NDA
> > is required to access the datasheet.
> >
> > Isn't the source code going to be breaking the NDA by releasing information
> > that is in the datasheet?
>
> that's really not my role inside TI, though. I have no degree by any law
> school from any country. When I get asked to write a driver, all I do is
> request permission to release it, if that says "okay, release it", I
> don't go after the Lawyer who decided it was okay to release the driver.
> 
> On top of that, what does that has anything to do with anything ? I'm
> pretty sure many have released code based off of either simulation or
> pre-release HW. Lack of public documentation does not prevent source
> code from being released at all.
>
> Try to get documentation for most of SoCs supported under the ARM tree
> and you'll see at least 80% of them will require NDA and/or a big
> purchase order of many SoCs before you can get documentation.
>

I don't know I am just trying to the more facts so my mailbox will stop
pinging. :)

> -- 
> balbi


