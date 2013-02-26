Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab3BZSXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:23:40 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42019 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615Ab3BZSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:23:39 -0500
Date: Tue, 26 Feb 2013 10:23:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jean Delvare <khali@linux-fr.org>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit "USB: EHCI: remove ASS/PSS polling timeout"
Message-ID: <20130226182336.GA28796@kroah.com>
References: <20130226182409.046bdecd@endymion.delvare>
 <Pine.LNX.4.44L0.1302261316450.1832-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1302261316450.1832-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 01:21:30PM -0500, Alan Stern wrote:
> On Tue, 26 Feb 2013, Jean Delvare wrote:
> 
> > Hi Alan, Greg,
> > 
> > Since kernel 3.7.7, my Hauppauge Nova-T 500 Dual DVB-T TV card stopped
> > working reliably. Half of the boots it will work, the other half it
> > won't, with different error messages. For example
> 
> Yes, I know.  Other people have already reported the same problem -- 
> but only for EHCI controllers made by VIA.  Do you also have a VIA EHCI 
> controller?
> 
> > So please revert this commit upstream as well as in 3.8 and 3.7 stable
> > kernel series.
> 
> I intend to as soon as the current merge window closes.
> 
> Or should I do it sooner?  Greg, if I send in a reversion patch now, 
> will it get pushed to Linus within the merge window?

Yes, I can and will get it in as soon as possible, as people are having
problems with this, and I want to get it fixed in the 3.8.y releases as
well.

thanks,

greg k-h
