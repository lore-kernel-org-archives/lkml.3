Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3CDCpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:45:53 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40680 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab3CDCpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:45:50 -0500
Date: Mon, 4 Mar 2013 10:45:28 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
Message-ID: <20130304024528.GA9385@kroah.com>
References: <20130301194351.913471337@linuxfoundation.org>
 <20130301194355.578429064@linuxfoundation.org>
 <1362172344.20156.15.camel@x61.thuisdomein>
 <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
 <1362263724.1334.18.camel@x61.thuisdomein>
 <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk>
 <1362306002.1334.29.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362306002.1334.29.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 11:20:02AM +0100, Paul Bolle wrote:
> On Sat, 2013-03-02 at 23:10 +0000, Ben Hutchings wrote:
> > On Sat, 2013-03-02 at 23:35 +0100, Paul Bolle wrote:
> > > 1) So if xen_vbd_translate() fails, it can return before setting
> > > preq.dev. That makes the call of pr_debug() use an uninitialized value,
> > > doesn't it?
> > 
> > Oh yes, so it's a completely valid warning in this case!
> 
> Thanks.
> 
> Perhaps Konrad, Jan, Or Ian can tell whether the patch still needs to go
> in stable as is, because the problem it fixes is more severe than the
> problem it apparently creates. Maybe a mainline fix is needed before
> this can go in, or perhaps even a stable specific fix (if context
> changes are to blame).

I've left it in, as-is.  If this is a problem, please fix it in Linus's
tree, and then I'll be glad to accept the same fix here in the stable
kernel releases as well.  Just be sure to let me know if that happens.

thanks,

greg k-h
