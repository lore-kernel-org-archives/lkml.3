Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaK0PZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:25:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaK0PZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:25:39 -0500
Date: Thu, 27 Nov 2014 07:24:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: devel@driverdev.osuosl.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking
 module params state
Message-ID: <20141127152417.GB23247@kroah.com>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
 <1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
 <20141126215801.GA32756@kroah.com>
 <20141127132657.GA12298@firebird>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127132657.GA12298@firebird>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:26:59PM +0100, Mariusz Gorski wrote:
> On Wed, Nov 26, 2014 at 01:58:01PM -0800, Greg Kroah-Hartman wrote:
> > On Wed, Nov 19, 2014 at 09:38:46PM +0100, Mariusz Gorski wrote:
> > > Avoid magic number and use a comparison with a defined value instead
> > > that checks whether module param has been set by the user to some
> > > value at loading time.
> > > 
> > > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > > Acked-by: Willy Tarreau <w@1wt.eu>
> > > ---
> > > v2: Don't introduce new macros for param value check
> > > 
> > >  drivers/staging/panel/panel.c | 86 +++++++++++++++++++++----------------------
> > >  1 file changed, 43 insertions(+), 43 deletions(-)
> > 
> > Ugh, I messed up here, and applied the first series, which was acked.
> > 
> > Mariusz, can you resend the patches that I didn't apply, I can't seem to
> > get the rest of these to work properly.
> 
> Greg, if I get you here correctly, you've applied all 9 patches from v1
> and none from v2, so what you need now is a v1->v2 patch, right?

No, I think I applied the patches sent _before_ the 9 series, it was 4
or 5 or so, you should have gotten an email about them.  Pull my
staging-testing branch and redo your remaining patches please.

thanks,

greg k-h
