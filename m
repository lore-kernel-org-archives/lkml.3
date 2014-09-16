Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaIPDWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:22:19 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33959 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaIPDWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:22:18 -0400
Date: Mon, 15 Sep 2014 20:22:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Cc: jespern@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, edgar.iglesias@gmail.com
Subject: Re: Status of 'cris' architecture support in Linux kernel
Message-ID: <20140916032212.GA7759@roeck-us.net>
References: <20140915145203.GK4659@axis.com>
 <201409151549.s8FFnner005703@ignucius.se.axis.com>
 <20140915183007.GA25962@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915183007.GA25962@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:30:07AM -0700, Guenter Roeck wrote:
> On Mon, Sep 15, 2014 at 05:49:49PM +0200, Hans-Peter Nilsson wrote:
> > Following up on Jesper's reply...
> > 
> > > From: Jesper Nilsson <jespern@axis.com>
> > > Date: Mon, 15 Sep 2014 16:52:03 +0200
> > 
> > > > Toolchain
> > > > 
> > > > Creating a toolchain from upstream sources required a number of patches.
> > 
> > > > - gcc 4.7.4
> > > >   Requires a backport from upstream gcc to compile.
> > > >   Later versions of gcc (4.8.3, 4.9.1) fail with internal compiler errors
> > > >   even after patching.
> > 
> > This sounds like PR61737 (fixed; use 4.9.2 not released yet),
> > but of course with the above sentence serving as your complete
> > bug-report (or did I miss one?) that will only be a guess.
> > 
> Confirmed; gcc 4.9.1 for crisv32 builds after applying the patch fixing
> PR61737 (and the patch to fic config.gcc) on top of gcc 4.9.1.
> 
Not-so-good update: I got the toolchain with gcc 4.9.1 to build,
but the resulting image hangs early during boot. This does not happen
if I use the toolchain with gcc 4.7.4. Guess I'll stick with that.

Guenter
