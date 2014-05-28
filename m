Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaE1UjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:39:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54752 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbaE1Ui7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:38:59 -0400
X-Sasl-enc: TE+R3KNh3/Q5y1KLdpXWf90U2riLx+gqcYHjwXw5PzYE 1401309537
Date: Wed, 28 May 2014 13:42:32 -0700
From: Greg KH <greg@kroah.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20140528204232.GA8224@kroah.com>
References: <20140528194629.0757af1b@canb.auug.org.au>
 <1401271041.28714.22.camel@x220>
 <1401272095.28714.30.camel@x220>
 <1401308488.6186.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401308488.6186.10.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:21:28PM +0200, Paul Bolle wrote:
> Greg,
> 
> On Wed, 2014-05-28 at 12:14 +0200, Paul Bolle wrote:
> > I must have compile tested this with CONFIG_LIB80211_CRYPT_TKIP=m while
> > the code checks for CONFIG_LIB80211_CRYPT_TKIP only (ie, builtin only).
> > I'll have to have a better look at this.
> > 
> > Greg, can the cleaning up of this mess involve an entirely new patch? An
> > incremental patch would leave this build error in a certain range of
> > commits.

As I already have the patch in my tree, I can't do that, we can live
with the build issue.

> The pieces of the latest linux-next build were handed to me by Stephen
> as my patch managed to break it.
> 
> I'm assuming you'd like to include rtl8192u in linux-next's builds
> again. Currently I got nothing to offer to you but a request to either
> drop "staging: rtl8192u: rename CONFIG_IEEE80211_CRYPT_TKIP" from
> staging-next or, if that's not how staging-next works, a request to
> revert it. What do you prefer?

Either is fine with me, I can revert it, or apply a fix, which ever you
want, just let me know.

thanks,

greg k-h
