Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3AQQ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:29:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:34603 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab3AQQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:29:27 -0500
Date: Thu, 17 Jan 2013 08:29:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
Message-ID: <20130117162924.GC1396@kroah.com>
References: <20130110144626.GA26279@breakpoint.cc>
 <20130110155058.12f66e73@bob.linux.org.uk>
 <20130110162907.GB26279@breakpoint.cc>
 <50EEF8FD.9000004@suse.cz>
 <20130110224554.1724a791@bob.linux.org.uk>
 <50EF45DF.4010905@suse.cz>
 <50EFF366.2000303@suse.cz>
 <20130111124129.GA23516@breakpoint.cc>
 <50F00926.3070000@suse.cz>
 <20130111131802.2986ba61@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111131802.2986ba61@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 01:18:02PM +0000, Alan Cox wrote:
> On Fri, 11 Jan 2013 13:44:22 +0100
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
> > On 01/11/2013 01:41 PM, Florian Westphal wrote:
> > > Jiri Slaby <jslaby@suse.cz> wrote:
> > >> On 01/10/2013 11:51 PM, Jiri Slaby wrote:
> > >>> On 01/10/2013 11:45 PM, Alan Cox wrote:
> > >>>> So we should just fix TIOCGPTN on a pty with no suitable name
> > >>>> answer to return -EINVAL
> > >>>
> > >>> Yes, I agree as I'm expressed in my second mail. Sorry for the
> > >>> confusion.
> > >>
> > >> Does the attached patch help?
> > > 
> > > Yes, it does.  Thanks for fixing this.
> > 
> > Ok, now I'm not sure if we want the patch or to implement TIOCGPTN
> > properly instead. Alan?
> 
> IMHO - fix now for the -rc tree where its clearly low risk, after that
> whatever people feel like doing 8)

I agree.  Jiri, should I take your posted patch for this?

thanks,

greg k-h
