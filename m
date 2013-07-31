Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3GaMse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:48:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3GaMsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:48:33 -0400
Date: Wed, 31 Jul 2013 05:49:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Cc: devel@driverdev.osuosl.org, Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, ngupta@vflare.org,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 1/2] staging: zram: add Crypto API support
Message-ID: <20130731124950.GB30635@kroah.com>
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
 <20130730135333.GB27962@kroah.com>
 <51F8E404.6070507@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8E404.6070507@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:16:36PM +0200, Piotr Sarna wrote:
> Hi,
> 
> On 07/30/2013 03:53 PM, Greg KH wrote:
> > On Tue, Jul 30, 2013 at 02:30:48PM +0200, Piotr Sarna wrote:
> >> Current version of zram does not allow any substitution of a default
> >> compression algorithm. Therefore, I decided to change the existing
> >> implementation of page compression by adding Crypto API compability.
> > 
> > As I have stated before, I want this code to get merged out of the
> > drivers/staging/ area _before_ any new features get added to it.  People
> > are taking too much time adding new stuff, like this, and no one seems
> > to be working to get it merged to the proper place anymore.
> > 
> 
> OK, but we actually need those features in order to test zram
> against other, competitive solutions - and then decide whether
> and how to merge it out of /drivers/staging.

Where is another "competitive solution" in the kernel?

And you are implying that as-is, zram isn't acceptable, right?  If so, I
should just delete it now as I was originally told otherwise, that's why
I merged it :(

> > So again, I'm going to have to say no to a new feature here, sorry.
> > zcache, zram, and zsmalloc need to get cleaned up and merged out of
> > staging before anything new can be added to them.
> > 
> > Or, if no one is working on that, I guess I can just delete them,
> > right?...
> > 
> 
> Is there any official TODO list of cleaning up and merging out zram?

As it came from the "zswap" code, there doesn't seem to be one :(

The code is over 2 years old now, with no percieved movement out of
staging.  If it doesn't get fixed up in the next kernel version or so, I
will have to remove it entirely.

sorry,

greg k-h
