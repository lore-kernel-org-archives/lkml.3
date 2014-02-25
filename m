Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaBYGJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:09:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaBYGJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:09:52 -0500
Date: Tue, 25 Feb 2014 07:09:51 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: David Miller <davem@davemloft.net>, ben@decadent.org.uk,
        mcgrof@do-not-panic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: kdoc struct net_device flags and priv_flags
Message-ID: <20140225060951.GA8299@wotan.suse.de>
References: <1393287245-4549-1-git-send-email-mcgrof@do-not-panic.com> <1393294265.6823.154.camel@deadeye.wl.decadent.org.uk> <20140224.235343.1936318499491821387.davem@davemloft.net> <2446186.I4KkJ8Hjdb@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2446186.I4KkJ8Hjdb@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:37:34PM -0800, Florian Fainelli wrote:
> Le lundi 24 février 2014, 23:53:43 David Miller a écrit :
> > From: Ben Hutchings <ben@decadent.org.uk>
> > Date: Tue, 25 Feb 2014 02:11:05 +0000
> > 
> > > On Mon, 2014-02-24 at 16:14 -0800, Luis R. Rodriguez wrote:
> > >> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > >> 
> > >> ---
> > >> 
> > >>  include/uapi/linux/if.h | 201
> > >>  +++++++++++++++++++++++++++++++++++------------- 1 file changed, 149
> > >>  insertions(+), 52 deletions(-)
> > >> 
> > >> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> > >> index d758163..1555623 100644
> > >> --- a/include/uapi/linux/if.h
> > >> +++ b/include/uapi/linux/if.h
> > > 
> > > [...]
> > > 
> > >> +/**
> > >> + * enum net_device_priv_flags - &struct net_device priv_flags
> > >> + *
> > >> + * These are the &struct net_device, they are only set internally
> > >> + * by drivers and used in the kernel but are invisible to userspace.
> > > 
> > > [...]
> > > 
> > > Indeed, I wonder why they are in the UAPI header.  As userland doesn't
> > > have a legitimate use for them, maybe you could move them back to
> > > include/linux/if.h instead of bothering with adding macros?
> > 
> > They are visible to userspace via sysfs.
> 
> In /sys/class/net/*/flags, although we are lacking quite a lot of documentation 
> for the exported attributes there.
> 
> The only attributes for which there is some sort of documentation are 
> "operstate" and the XPS/RFS/RPS attributes, maybe that could be fixed too as 
> part of this documentation patch?

Sure, but how about we take it one step at a time? I wanted to do this first
so I can extend the documentation of some flags private flags I'm reviewing
right now, so figured we'd start with the basic, non contravertial simple
documentation and then we can start piling up new shiny documentation.

  Luis
