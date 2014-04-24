Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaDXMef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:34:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:46758 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752678AbaDXMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:34 -0400
Date: Thu, 24 Apr 2014 08:34:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@kernel.org>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net, linux-spi@vger.kernel.org
Subject: Re: [PATCH] spi-bfin: Add missing gpio.h include
Message-ID: <20140424083432.70c80f64@gandalf.local.home>
In-Reply-To: <20140424113346.GM12304@sirena.org.uk>
References: <20140423224035.1de64093@gandalf.local.home>
	<20140424103329.GL12304@sirena.org.uk>
	<20140424113346.GM12304@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 12:33:46 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Thu, Apr 24, 2014 at 11:33:29AM +0100, Mark Brown wrote:
> > On Wed, Apr 23, 2014 at 10:40:35PM -0400, Steven Rostedt wrote:
> > > Running my ktest.pl tests on all the archs, I stumbled over this for
> > > 3.15-rc2:
> > 
> > Applied, thanks.
> 
> Actually not - I already have a fix for this in -next (on a slightly
> different branch to the one I looked for it on).  Anyway, it's fixed.

Heh, OK, I figured someone may have already fixed it, but still wanted
to let people know it was broken. It's amazing how long something like
this can take.

It's just annoying when my tests break on something that I'm not
testing ;-)

-- Steve
