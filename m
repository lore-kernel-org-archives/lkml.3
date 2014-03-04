Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaCDTpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:45:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCDTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:45:12 -0500
Date: Tue, 4 Mar 2014 11:46:55 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim McDonough <jmcd@samba.org>,
        David Disseldorp <ddiss@samba.org>, Steve French <smfrench@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Stable backport of cifs nlink workaround?
Message-ID: <20140304194655.GC19462@kroah.com>
References: <20140225152443.GA15552@sucs.org>
 <20140225161156.GA27235@kroah.com>
 <20140225094306.63cccecb@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225094306.63cccecb@corrin.poochiereds.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:43:06AM -0800, Jeff Layton wrote:
> On Tue, 25 Feb 2014 08:11:56 -0800
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Feb 25, 2014 at 03:24:43PM +0000, Sitsofe Wheeler wrote:
> > > Hi,
> > > 
> > > Is there any chance that 74d290da476f672ad756634d12aa707375d3564d
> > > ([CIFS] Provide sane values for nlink) could be backported to the stable
> > > 3.2 kernel?
> > 
> > Why just 3.2?  What's wrong with all of the other kernels before 3.12
> > that do not have this patch in it?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Yeah, you'd probably need to apply it to every stable kernel > 3.2 or
> you'd technically have a regression. I've no real objection to putting
> that fix in, but backporting to older kernels may not be trivial. There
> have been other changes in this area over the years...

It doesn't apply to 3.10 or 3.4-stable trees, so I'll wait for someone
to provide a working backport before I can commit it.

thanks,

greg k-h
