Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab3BZTpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:45:15 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:41489 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3BZTpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:45:13 -0500
Date: Tue, 26 Feb 2013 12:45:11 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] gpio/gpio-generic: Add OF bindings
Message-ID: <20130226194511.GA2380@obsidianresearch.com>
References: <20121207231017.GC29262@obsidianresearch.com>
 <20130226074118.BA9F83E08BF@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226074118.BA9F83E08BF@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 07:41:18AM +0000, Grant Likely wrote:
> On Fri, 7 Dec 2012 16:10:17 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> > Allow the platform driver to bind through OF. The existing
> > OF machinery for setting the resource names through OF is used to
> > configure the device, so the change is minimally intrusive and
> > fully featured.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Hi Jason,
> 
> Thanks for looking at this. I've wanted this feature for a while now,
> but I haven't liked the bindings that I've seen so far because each
> individual register is broken out into separate reg tuples. Blech. Too
> much unlike existing bindings.

Thanks for looking at the patch. I agree with your comments, and will
try to find some time to fiddle with this - but I can't give it a very
high priority..

Regards,
Jason
