Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030966Ab3HIUBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:01:02 -0400
Received: from 1wt.eu ([62.212.114.60]:35245 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030899Ab3HIUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:01:00 -0400
Date: Fri, 9 Aug 2013 22:00:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809200056.GF4079@1wt.eu>
References: <20130809015010.208118575@linuxfoundation.org> <20130809192030.GD4079@1wt.eu> <20130809193329.GA5792@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809193329.GA5792@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 12:33:29PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2013 at 09:20:30PM +0200, Willy Tarreau wrote:
> > Hi Greg,
> > 
> > On Thu, Aug 08, 2013 at 06:56:36PM -0700, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.10.6 release.
> > > There are 102 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Just checked on my OpenBlocks AX3 (dual-core ARMv7 in thumbs mode),
> > everything seems OK, I did not even notice any performance regression
> > compared to 3.10.5 on syscall intensive workloads with the recent
> > changes. I'm sure that I'm using the kuser helpers page since the
> > system doesn't boot without. Also I did observe minor changes in
> > /proc/self/maps, but I don't think they should have any impact, so
> > all in all it's OK :
> 
> Wonderful, thanks so much for testing the arm stuff, I wasn't sure I got
> it all correct in the backport.

Note that I have not tested in ARM mode nor on older archs. But I don't
think it should change anything from what I've seen in the diffs.

> One of these days I'll get a system here that I can test arm changes
> on...

Just get a Beaglebone Black, it's $45 and Cortex A8 (armv7). Well buy
two, since you'll use the first one for hacking GPIOs to everything :-)

   http://beagleboard.org/Products/BeagleBone%20Black

If you want to do cool stuff, the AX3 is by far the best thing I've seen
to date, really, but it's too expensive for a non-profit developer in my
opinion :

   https://openblocks.plathome.com/form/obs_verification/input.html

Cheers,
Willy

