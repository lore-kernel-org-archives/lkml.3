Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaK0N1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:27:13 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56497 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaK0N1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:27:12 -0500
Date: Thu, 27 Nov 2014 14:26:59 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Willy Tarreau <w@1wt.eu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking
 module params state
Message-ID: <20141127132657.GA12298@firebird>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
 <1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
 <20141126215801.GA32756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126215801.GA32756@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 01:58:01PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Nov 19, 2014 at 09:38:46PM +0100, Mariusz Gorski wrote:
> > Avoid magic number and use a comparison with a defined value instead
> > that checks whether module param has been set by the user to some
> > value at loading time.
> > 
> > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > Acked-by: Willy Tarreau <w@1wt.eu>
> > ---
> > v2: Don't introduce new macros for param value check
> > 
> >  drivers/staging/panel/panel.c | 86 +++++++++++++++++++++----------------------
> >  1 file changed, 43 insertions(+), 43 deletions(-)
> 
> Ugh, I messed up here, and applied the first series, which was acked.
> 
> Mariusz, can you resend the patches that I didn't apply, I can't seem to
> get the rest of these to work properly.

Greg, if I get you here correctly, you've applied all 9 patches from v1
and none from v2, so what you need now is a v1->v2 patch, right?

> thanks,
> 
> greg k-h

Cheers,
Mariusz
