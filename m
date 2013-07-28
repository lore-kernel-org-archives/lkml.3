Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3G1Shy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:37:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3G1Shx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:37:53 -0400
Date: Sun, 28 Jul 2013 11:37:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        odanet@caramail.com
Subject: Re: [ 15/59] sparc32: vm_area_struct access for old Sun SPARCs.
Message-ID: <20130728183752.GA27253@kroah.com>
References: <20130726205013.795696531@linuxfoundation.org>
 <20130726205015.440894498@linuxfoundation.org>
 <1374961508.3607.18.camel@deadeye.wl.decadent.org.uk>
 <20130727.192725.1220037383953385935.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130727.192725.1220037383953385935.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 07:27:25PM -0700, David Miller wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Sat, 27 Jul 2013 22:45:08 +0100
> 
> > On Fri, 2013-07-26 at 13:52 -0700, Greg Kroah-Hartman wrote:
> >> 3.4-stable review patch.  If anyone has any objections, please let me know.
> >> 
> >> ------------------
> >> 
> >> From: Olivier DANET <odanet@caramail.com>
> > [...]
> > 
> > This, and the other SPARC fixes for 3.4 and 3.0, are missing upstream
> > commit references, which should be:
> > 
> > [SPARC] sparc32: vm_area_struct access for old Sun SPARCs.
> > commit 961246b4ed8da3bcf4ee1eb9147f341013553e3c upstream.
> > 
> > sparc64 address-congruence property
> > commit 771a37ff4d80b80db3b0df3e7696f14b298c67b7 upstream.
> > 
> > sparc: tsb must be flushed before tlb
> > commit 23a01138efe216f8084cfaa74b0b90dd4b097441 upstream.
> 
> Sorry, I forgot the upstream commit tags on these Sparc bits.
> :-/

No worries, I should have noticed this before, thanks Ben for pointing
them out.  I've fixed them all up in my tree now.

greg k-h
