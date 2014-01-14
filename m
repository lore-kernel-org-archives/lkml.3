Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaANVpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:45:40 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51226 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbaANVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:45:37 -0500
X-Sasl-enc: YKLfXFn8dL/6Lm4Sx4NMNxls4loevfNwBChammbKlSHB 1389735936
Date: Tue, 14 Jan 2014 13:46:14 -0800
From: Greg KH <gregkh@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Makefile: Build with -Werror=date-time if the
 compiler supports it
Message-ID: <20140114214614.GA26965@kroah.com>
References: <cover.1387833347.git.josh@joshtriplett.org>
 <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org>
 <52C6E814.7090301@suse.cz>
 <20140103202915.GB12111@leaf>
 <52C723B4.1080902@suse.cz>
 <20140103210030.GE12111@leaf>
 <52D5A495.80500@suse.cz>
 <20140114214014.GA10837@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114214014.GA10837@jtriplet-mobl1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 01:40:15PM -0800, Josh Triplett wrote:
> On Tue, Jan 14, 2014 at 09:56:53PM +0100, Michal Marek wrote:
> > Dne 3.1.2014 22:00, Josh Triplett napsal(a):
> > > On Fri, Jan 03, 2014 at 09:55:16PM +0100, Michal Marek wrote:
> > >> On 3.1.2014 21:29, Josh Triplett wrote:
> > >>> Please feel free to take the entire series through your tree; I received
> > >>> some maintainer acks, but no indications that the patches are going
> > >>> through their trees.
> > >>
> > >> OK. I will wait until mid next week and commit with any acks received.
> > > 
> > > Thanks!
> > 
> > I did not find time last week and Greg was faster and merged the driver
> > patches. But I'm reluctant to only merge the Makefile patch now, because
> > the kbuild branch would not build. I think I will send the patch to
> > Linus after 3.14-rc1.
> 
> Greg, if you already have all the driver patches in your tree, perhaps
> you could go ahead and take the Makefile patch through your tree as
> well?  (Assuming that's OK with you, Michal?)

Did I really grab all of the other patches?  I don't remember how many
there were in this series for stuff I maintain.  If I have them all,
sure, I'll be glad to take it, otherwise I agree with Michal, it should
be sent to Linus after 3.14-rc1 is out to make sure everything is
properly synced up and you didn't miss any new drivers coming in that
missed getting converted.

thanks,

greg k-h
