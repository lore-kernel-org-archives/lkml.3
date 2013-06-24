Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3FXXuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:50:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47948 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976Ab3FXXuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:50:06 -0400
X-Sasl-enc: TdsmATSl1zNByNSYVWje27nHp8+XT02eRsL4C9jpG/ef 1372117804
Date: Mon, 24 Jun 2013 16:50:03 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peng Tao <bergwolf@gmail.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20130624235003.GA1263@kroah.com>
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
 <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
 <20130624224035.GD24099@kroah.com>
 <20130625094051.b9cf8f8950eeeeed0dd266b2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625094051.b9cf8f8950eeeeed0dd266b2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 09:40:51AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 24 Jun 2013 15:40:35 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > We are running out of time, my tree is pretty much closed for 3.11 now,
> > should I just disable the build of this module for 3.11?
> 
> That's what I've been doing - it has never been enabled in a final
> linux-next release.  So, it should probably just be disabled properly.

I agree, now disabled.

greg k-h
