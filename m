Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3I3BxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:53:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3I3BxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:53:03 -0400
Date: Sun, 29 Sep 2013 18:53:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, Bastian Blank <waldi@debian.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq: Allow access to sensitive keys to be restricted
 by default
Message-ID: <20130930015305.GE13344@kroah.com>
References: <1380504668.14493.22.camel@deadeye.wl.decadent.org.uk>
 <20130930014009.GA30635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930014009.GA30635@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 09:40:09PM -0400, Dave Jones wrote:
> On Mon, Sep 30, 2013 at 02:31:08AM +0100, Ben Hutchings wrote:
>  > From: Bastian Blank <waldi@debian.org>
>  > 
>  > Add a Kconfig variable to set the initial value of the Magic SysRq mask
>  > (sysctl: kernel.sysrq).
>  > 
>  > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>  > ---
>  > This has been in Debian for a while, but should probably be signed-off
>  > by Bastian as well.
>  > 
>  > Debian sets this to 0x01b6, which excludes.
>  > 
>  >           8 - enable debugging dumps of processes etc.
>  >          64 - enable signalling of processes (term, kill, oom-kill)
>  > ...
>  >  
>  > +config MAGIC_SYSRQ_DEFAULT_MASK
>  > +	hex "Default mask for Magic SysRq keys on the console"
>  > +	depends on MAGIC_SYSRQ
>  > +	default 1
>  > +	help
>  > +	  Specifies the default mask for the allowed SysRq keys.  This can be
>  > +	  used to disable several sensitive keys by default.
> 
> Might be nice to have the mask values duplicated here to save having to
> go grepping through code ?

Yeah, a hit would be good.  Like what '1' does as default would be a
nice start :)

thanks,

greg k-h
