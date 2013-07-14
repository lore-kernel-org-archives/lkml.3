Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3GNRcE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 13:32:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3GNRcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 13:32:01 -0400
Date: Sun, 14 Jul 2013 10:32:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH v2 0/7] Driver core and sysfs changes for attribute groups
Message-ID: <20130714173258.GA19592@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
 <20130714172703.GA26513@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130714172703.GA26513@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 10:27:03AM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 05:35:58PM -0700, Greg Kroah-Hartman wrote:
> > Hi all,
> > 
> > Here's the second iteration of the patchset to add better attribute
> > group support to the driver core and sysfs.
> > 
> > I've tested these (shocker!) and everything works fine with them (I'm
> > sending this from Linus's latest kernel with these 7 on top of it.)
> > 
> > I'd like to send these to Linus for 3.11 unless someone objects.
> > 
> Hi Greg,
> 
> I have not seen the series in the upstream kernel. Do you have an updated
> plan to get it upstream ?
> 
> If needed I can carry the patches I need in my branch for now, so it doesn't
> matter too much if the code misses 3.11. Still, it would help to know the
> plan going forward.

I was planning on doing one more respin of the patches on Monday, and
then getting them into 3.11-rc2 if possible so that everyone can start
taking advantage of them.

Got sucked into the "discussion" of the stable kernels on Friday and
didn't do the update like I was wanting to do so :)

thanks,

greg k-h
