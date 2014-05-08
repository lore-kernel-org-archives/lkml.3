Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaEHXIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 19:08:46 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:37296 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaEHXIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 19:08:44 -0400
Date: Fri, 9 May 2014 02:04:15 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: Re: [PATCH 13/13] video: omap: allow building on !MMU
Message-ID: <20140508230415.GA6670@drone.musicnaut.iki.fi>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-14-git-send-email-peter.griffin@linaro.org>
 <5369F973.10803@ti.com>
 <20140508215338.GE2198@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508215338.GE2198@atomide.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 08, 2014 at 02:53:38PM -0700, Tony Lindgren wrote:
> * Tomi Valkeinen <tomi.valkeinen@ti.com> [140507 02:15]:
> > I don't have omap1 boards, and I don't know anyone that has. I don't
> > even know if the omap1 fb is working or not...

OMAP1 fb is working very well. As a matter of fact, it's much more usable
for me than fb on OMAP2/3 - apart from N900 (on which fb is working again
with 3.15) none of my 4 other OMAP2/3 boards have a working display/fb
in mainline yet. :-(

> > Tony, any idea of omap1's fb? Are you able to test this?
> 
> I have three omap1 boards in my rack that I use for my boot
> testing. Tried to enable framebuffer but so far no luck on
> any of them. So I'm not much of a help here. Looks like the
> patch should work though..
> 
> Aaro & Janusz, care to take a look at the patch in this
> thread?

I couldn't figure out how to enter this code path. Amstrad E3 & Nokia
770 will take the alloc_fbmem() path & exit, and based on quick look
I could not see way to enter mmap_kern(). Is that dead code?

A.
