Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaEHVxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:53:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52858 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755378AbaEHVxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:53:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/IyuEwTmQIP+xVGtAakhBi
Date: Thu, 8 May 2014 14:53:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Peter Griffin <peter.griffin@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: Re: [PATCH 13/13] video: omap: allow building on !MMU
Message-ID: <20140508215338.GE2198@atomide.com>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-14-git-send-email-peter.griffin@linaro.org>
 <5369F973.10803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369F973.10803@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [140507 02:15]:
> On 24/04/14 15:28, Peter Griffin wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The omap lcdc driver has an elaborate mmap_kern function
> > to map the frame buffer into kernel address space as
> > write-combined. This uses functions that are only available
> > on MMU-enabled builds.
> > 
> > It does seem equivalent to ioremap_wc though, so we should
> > be able to just use that instead.
> > 
> > This patch is build-tested only, it needs to be run on real
> > hardware before applying.
> 
> I don't have omap1 boards, and I don't know anyone that has. I don't
> even know if the omap1 fb is working or not...
> 
> Tony, any idea of omap1's fb? Are you able to test this?

I have three omap1 boards in my rack that I use for my boot
testing. Tried to enable framebuffer but so far no luck on
any of them. So I'm not much of a help here. Looks like the
patch should work though..

Aaro & Janusz, care to take a look at the patch in this
thread?

Regards,

Tony
