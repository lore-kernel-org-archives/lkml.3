Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3DKTFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:05:35 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47387 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DKTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:05:33 -0400
Date: Thu, 11 Apr 2013 12:05:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>, David Schleef <ds@schleef.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/26] comedi: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130411190531.GA32045@kroah.com>
References: <5166D1BB.3070101@mev.co.uk>
 <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411132819.32763.72806.stgit@warthog.procyon.org.uk>
 <23048.1365693352@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23048.1365693352@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 04:15:52PM +0100, David Howells wrote:
> Ian Abbott <abbotti@mev.co.uk> wrote:
> 
> > > Don't use create_proc_read_entry() as that is deprecated, but rather use
> > > proc_create_data() and seq_file instead.
> > 
> > It seems to work okay and is simpler than I thought it would be!  You changed
> > the mode of the file to 0644 for some reason though.  Please change it back to
> > 0444 or S_IFREG | S_IRUGO.  Thanks.
> 
> Ah... cut'n'paste error.  Sorry about that.

I can fix that up by hand when I apply it, no worries.

thanks,

greg k-h
