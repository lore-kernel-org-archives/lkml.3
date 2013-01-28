Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3A1UQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:16:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3A1UQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:16:01 -0500
Date: Mon, 28 Jan 2013 15:15:50 -0500
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Fix irqfd resampler list walk
Message-ID: <20130128201550.GA31457@amt.cnet>
References: <20121206214355.24853.71852.stgit@bling.home>
 <20121210201650.GA2402@amt.cnet>
 <1359386700.11144.174.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359386700.11144.174.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 08:25:00AM -0700, Alex Williamson wrote:
> On Mon, 2012-12-10 at 18:16 -0200, Marcelo Tosatti wrote:
> > On Thu, Dec 06, 2012 at 02:44:59PM -0700, Alex Williamson wrote:
> > > Typo for the next pointer means we're walking random data here.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: stable@vger.kernel.org [3.7]
> > > ---
> > > 
> > > Not sure if this will make 3.7, so preemptively adding the stable flag
> > > 
> > >  virt/kvm/eventfd.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Applied, thanks.
> > 
> 
> Hi Marcelo,
> 
> This didn't seem to make it into 3.7.0 or any stable 3.7.  Can we
> promote it for stable?  Thanks,
> 
> Alex

Yes, please send the patch with the backport you're interested in being
included to stable@kernel.org.

http://www.kernel.org/doc/Documentation/stable_kernel_rules.txt


