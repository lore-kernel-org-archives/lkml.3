Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaEVREs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:04:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32824 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaEVREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:04:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+UWiQT6kGYiZyi5JXQZc9QBHBEWFMoHk0=
X-DKIM: OpenDKIM Filter v2.0.1 titan DB85357D6C4
Date: Thu, 22 May 2014 13:04:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jake Edge <jake@lwn.net>
Cc: Anton Saraev <antonysaraev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140522170441.GW8664@titan.lakedaemon.net>
References: <20140520075612.220a13ae@chukar.edge2.net>
 <20140520144757.GA8664@titan.lakedaemon.net>
 <20140520102411.413d565d@chukar.edge2.net>
 <20140520215217.GB1692@Ruffial>
 <20140522105206.0115e1a4@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522105206.0115e1a4@chukar.edge2.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 10:52:06AM -0600, Jake Edge wrote:
> On Wed, 21 May 2014 01:52:17 +0400 Anton Saraev wrote:
> > On Tue, May 20, 2014 at 10:24:11AM -0600, Jake Edge wrote:
> > > On Tue, 20 May 2014 10:47:57 -0400 Jason Cooper wrote:
> > >
> > > but some kind of tests are needed to ensure nothing breaks before
> > > digging into that ...
> > 
> > I have some test: slightly modified version of tests from
> > https://github.com/wernerd/Skein3Fish. It works as debugfs entry
> > and require some modification needed for module support
> > ("public" function must be extern). As I can understand Jason
> > has his own tests. That would be logical to share them but
> > I don't know where.
> 
> well, it seems to me that we want tests that eventually can be added
> into the crypto test framework once skein moves out of staging and into
> crypto ... Jason's objdiff seems like it would be used as another
> development tool ...
> 
> so do you have your tests anywhere that we can look at them?  or,
> failing that, maybe you can just email me a copy off-list or something?

https://github.com/wernerd/Skein3Fish/tree/master/c/test

This is the same repo I pulled the original source files from.  I looked
at integrating into the crypto test framework a few months back and
realized the crypto API needed to be modified to handle tweakable block
ciphers.

> do you have patches pending for skein?  i might get a chance to hack on
> this some over the weekend, and we may as well try to avoid duplicating
> each other's efforts ...

I do not, I'm unsure if Anton has anything pending capable of
upstreaming.

thx,

Jason.
