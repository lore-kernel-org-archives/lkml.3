Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3AYNuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:50:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23030 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3AYNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:50:12 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=fGM4yXGx12wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RaCtCyzfOO0A:10 a=fEr_rIeP3ubOS7shDNcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359121811.21576.217.camel@gandalf.local.home>
Subject: Re: [BUG] panda board locks up on boot
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Date: Fri, 25 Jan 2013 08:50:11 -0500
In-Reply-To: <20130125085234.GY23505@n2100.arm.linux.org.uk>
References: <1359082886.21576.199.camel@gandalf.local.home>
	 <20130125085234.GY23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 08:52 +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 24, 2013 at 10:01:26PM -0500, Steven Rostedt wrote:
> > I've recently started testing my work on arm boards and have found that
> > they both don't boot under the latest kernel anymore. I already posted
> > about my snowball board, but my panda board also locks up.
> 
> You need to enable DMA engine and the OMAP DMA engine driver.  I believe
> someone was going to work on adding PIO-mode support to the driver but
> I suspect as TI's OMAP division is being reorganized, all that is now
> uncertain.

Well, I be darn...


Yep, selecting DMA_OMAP which selects DMA_ENGINE makes everything
better. Who'da thunk?

Now only if there was a config option missing for my snowball?

Thanks!

-- Steve


