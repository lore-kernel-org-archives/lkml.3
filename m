Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaDXXUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:20:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaDXXUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:20:39 -0400
Date: Thu, 24 Apr 2014 16:23:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-serial@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [GIT PULL] serial: Cadence
Message-ID: <20140424232332.GB10457@kroah.com>
References: <53575983.3030508@monstr.eu>
 <20140423234832.GB17827@kroah.com>
 <5358A188.4080404@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358A188.4080404@monstr.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 07:30:48AM +0200, Michal Simek wrote:
> On 04/24/2014 01:48 AM, Greg Kroah-Hartman wrote:
> > On Wed, Apr 23, 2014 at 08:11:15AM +0200, Michal Simek wrote:
> >> Hi Greg,
> >>
> >> this is around for a while and I would like to close it.
> >> I have applied patches 1-7 from v3.
> >> Patches 8 and 9 should go through arm-soc tree and I will add them
> >> to my zynq/dt branch.
> >>
> >> Please apply these patches to your tree.
> >> If this should go through different tree please let me know.
> >>
> >> Thanks,
> >> Michal
> >>
> >>
> >> The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:
> >>
> >>   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
> >>
> >> are available in the git repository at:
> >>
> >>   git://git.monstr.eu/linux-2.6-microblaze.git tags/cadence-uart-for-3.16
> > 
> > I can't take git pulles from random internet sites, sorry.  Just send
> > these as email and I will queue them up.
> 
> I wouldn't say random. This repo is listed in my Microblaze maintainer fragment
> and I used signed tag and you have sign my key that's why you can easily
> check it.

If you have a signed key, why aren't you using git.kernel.org?  Again, I
can't pull from any non-kernel.org sites, sorry.

> Anyway we have sent v3 patches via email twice.
> Origin v3:
> https://lkml.org/lkml/2014/3/12/499
> 
> Resent v3:
> https://lkml.org/lkml/2014/4/4/523
> 
> Patches 1-7 should go through your tree.

I've now applied these, sorry for the delay.

greg k-h
